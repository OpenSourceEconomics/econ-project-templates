import pandas as pd


def clean_data(data, data_info):
    """Clean data set.

    Information on data columns is stored in ``data_management/data_info.yaml``.

    Args:
        data (pandas.DataFrame): The data set.
        data_info (dict): Information on data set. Contains keys
            - 'dependent_variable': Name of dependent variable column in data
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
    return data


def convert_outcome_to_numerical(outcome):
    """Convert categorical outcome series to numerical.
    
    Args:
        outcome (pandas.Series): The outcome column.
    
    Returns:
        pandas.Series: The converted series.
    
    """
    converted = pd.Categorical(outcome).codes
    return converted