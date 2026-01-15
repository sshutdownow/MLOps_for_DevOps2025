from clearml import Dataset

dataset = Dataset.create(
    dataset_name="Amazon reviews dataset",
    dataset_project="Amazon reviews",
    dataset_version="1.0",
    description="Data from kagle project",
)
dataset.finalize()

import polars as pl

for index, batch in enumerate(
    pl.read_csv(
        "data/train.csv",
        has_header=False,
        new_columns=["Polarity", "Title", "Review"],
    )
    .with_row_index()
    .with_columns(pl.col("index") // 25000)
    .partition_by("index")
):
    batch.write_csv(f"data/raw/batch_{index}.csv")
    polaritu_distrib = batch.group_by("Polarity").len()
    dataset = Dataset.create(
        dataset_name="Amazon reviews dataset",
        dataset_project="Amazon reviews",
        parent_datasets=[dataset],
        dataset_version=f"1.{index}",
        description="Data from kagle project",
    )
    dataset.add_files(path=f"data/raw/batch_{index}.csv")
    dataset.get_logger().report_table(
        "Dataset Preview", "Dataset Preview", table_plot=batch.head(5).to_pandas()
    )
    dataset.get_logger().report_histogram(
        title="Polarity distribution",
        series="Polarity distribution",
        values=polaritu_distrib["len"].to_list(),
        xlabels=polaritu_distrib["Polarity"].to_list(),
        yaxis="Number of samples",
    )
    dataset.upload()
    dataset.finalize()
