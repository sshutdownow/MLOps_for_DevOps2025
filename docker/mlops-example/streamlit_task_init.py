from clearml import Task
from transformers import pipeline

# Инициализация задачи в ClearML
task = Task.init(project_name='Amazon reviews', task_name='Amazon reviews Web Inference')

# Загрузка модели (например, из Hugging Face)
classifier = pipeline("sentiment-analysis")

# Параметры можно менять прямо в Web UI ClearML
args = {'model_name': 'TF-IDF Vectorize BernoulliNB'}
task.connect(args)
