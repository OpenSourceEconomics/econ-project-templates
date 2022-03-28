import pandas as pd


def clean_data(data, data_info):
    """Clean data set.

    Information on data columns is stored in ``data_management/data_info.yaml``.

    Args:
        data (pandas.DataFrame): The data set.
        data_info (dict): Information on data set. Contains keys
            - 'outcome': Name of dependent variable column in data
            - 'outcome_numerical': Name to be given to the numerical version of outcome
            - 'columns_to_drop': Names of columns that are dropped in data cleaning step
            - 'categorical_columns': Names of columns that are converted to categorical
            - 'column_rename_mapping': Rename mapping
            - 'url': URL to data set

    Returns:
        pandas.DataFrame: The cleaned data set.

    """
    data = data.drop(columns=data_info["columns_to_drop"])
    data = data.dropna()
    for cat_col in data_info["categorical_columns"]:
        data[cat_col] = data[cat_col].astype("category")
    data = data.rename(columns=data_info["column_rename_mapping"])

    numerical_outcome = pd.Categorical(data[data_info["outcome"]]).codes
    data[data_info["outcome_numerical"]] = numerical_outcome

    return data
