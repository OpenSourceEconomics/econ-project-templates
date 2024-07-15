"""Function(s) for cleaning the data set(s)."""

import pandas as pd


def clean_data_old(data, data_info):
    """Clean data set.

    Information on data columns is stored in ``data_management/data_info_template.yaml``

    Args:
        data (pandas.DataFrame): The data set.
        data_info (dict): Information on data set stored in data_info_template.yaml. The
            following keys can be accessed:
            - 'outcome': Name of dependent variable column in data
            - 'outcome_numerical': Name to be given to the numerical version of outcome
            - 'columns_to_drop': Names of columns that are dropped in data cleaning step
            - 'categorical_columns': Names of columns that are converted to categorical
            - 'column_rename_mapping': Old and new names of columns to be renamend,
                stored in a dictionary with design: {'old_name': 'new_name'}
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



def clean_data(data):
    """Clean the data set.

    Args:
        data (pandas.DataFrame): The (uncleaned) data set.
        
    Returns:
        pandas.DataFrame: The cleaned data set.
    
    """
    clean = pd.DataFrame()
    
    clean["gender"] = _clean_gender(data["gender"])
    clean["marital_status"] = _clean_marital_status(data["marital_status"])
    clean["smoke"] = _clean_smoke(data["smoke"])
    clean["smoke_numerical"] = clean["smoke"].cat.codes
    clean["highest_qualification"] = _clean_highest_qualification(data["highest_qualification"])
    clean["age"] = data["age"].astype(int)
    return clean
    

def _clean_gender(sr):
    return _clean_unordered_categorical(sr, ["Male", "Female"])

def _clean_marital_status(sr):
    return _clean_unordered_categorical(sr, ["Single", "Married", "Divorced", "Widowed", "Separated"])

def _clean_smoke(sr):
    return _clean_unordered_categorical(sr, ["No", "Yes"])

def _clean_unordered_categorical(sr, categories):
    dtype = pd.CategoricalDtype(categories, ordered=False)
    return sr.astype(dtype)

def _clean_highest_qualification(sr):
    replace = {
        "GCSE/CSE": "GCSE/CSE or GCSE/O Level",
        "GCSE/O Level": "GCSE/CSE or GCSE/O Level",
        "Other/Sub Degree": "Other or Higher/Sub Degree",
        "Higher/Sub Degree": "Other or Higher/Sub Degree",
    }
    ordered_qualifications = [
        "No Qualification",
        "GCSE/CSE or GCSE/O Level",
        "ONC/BTEC",
        "Other or Higher/Sub Degree",
        "A Levels",
        "Degree"
    ]
    sr = sr.replace(replace)
    dtype = pd.CategoricalDtype(ordered_qualifications, ordered=True)
    return sr.astype(dtype)

