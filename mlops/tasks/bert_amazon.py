import joblib
import torch
import polars as pl
import pandas as pd

from tqdm import tqdm
from clearml import Dataset, Task
from transformers import AutoModel, AutoTokenizer
from torch.utils.data import DataLoader
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix

task = Task.init(project_name="Amazon reviews", task_name="Bert", output_uri=True)
task.add_requirements("numpy", "1.26.4")
task.add_requirements("pyarrow", "20.0.0")
task.set_base_docker("python:3.11.13-slim-bookworm")
# task.execute_remotely(queue_name='services', exit_process=True)
frame_path = Dataset.get(
    dataset_name="Amazon reviews dataset",
    dataset_project="Amazon reviews",
    dataset_version="1.1.1",
).get_local_copy()
train = pl.read_csv(frame_path + "/raw_train.csv")
test = pl.read_csv(frame_path + "/raw_test.csv")

model_name = "bert-base-uncased"
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

tokenizer = AutoTokenizer.from_pretrained(model_name)
bert_model = AutoModel.from_pretrained(model_name).to(device)

fixed_batch_size = 32
train_dataloader = DataLoader(
    train["Review"].to_list(), batch_size=fixed_batch_size, shuffle=False
)
test_dataloader = DataLoader(
    test["Review"].to_list(), batch_size=fixed_batch_size, shuffle=False
)

def batch_inference(batch):
    tokenized_batch = tokenizer(
        batch, padding=True, truncation=True, return_tensors="pt"
    ).to(device)
    with torch.no_grad():
        hidden_batch = bert_model(**tokenized_batch)
        batch_embeddings = hidden_batch.last_hidden_state[:, 0, :].detach().to("cpu")
        return batch_embeddings


train_embeddings = torch.concat(
    [batch_inference(batch_data) for batch_data in tqdm(train_dataloader)]
)
test_embeddings = torch.concat(
    [batch_inference(batch_data) for batch_data in tqdm(test_dataloader)]
)

task.upload_artifact(
    name="train_embeddings",
    artifact_object=train_embeddings,
)
task.upload_artifact(
    name="test_embeddings",
    artifact_object=test_embeddings,
)

random_state = 42
model_params = {
    "multi_class": "multinomial",
    "solver": "saga",
    "random_state": random_state,
}
task.connect(model_params)
model_lr = LogisticRegression(**model_params)
model_lr.fit(train_embeddings, train["Polarity"])
joblib.dump(model_lr, "model.pkl", compress=True)
predicts = model_lr.predict(test_embeddings)
report = classification_report(test["Polarity"], predicts, output_dict=True)
confusion = confusion_matrix(test["Polarity"], predicts)

logger = task.get_logger()
logger.report_single_value("accuracy", report.pop("accuracy"))
for class_name, metrics in report.items():
    for metric, value in metrics.items():
        logger.report_single_value(f"{class_name}_{metric}", value)
logger.report_table(
    "Classification Report", "Metrics", table_plot=pd.DataFrame(report).T
)
logger.report_confusion_matrix(
    "Classification Report", "ConfusionMatrix", matrix=confusion
)

task.mark_completed()