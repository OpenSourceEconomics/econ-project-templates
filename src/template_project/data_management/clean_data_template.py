"""Function(s) for cleaning the data set(s)."""

import pandas as pd


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
    clean["highest_qualification"] = _clean_highest_qualification(
        data["highest_qualification"],
    )
    clean["age"] = data["age"].astype(int)
    return clean


def _clean_categorical(sr, categories, ordered):
    dtype = pd.CategoricalDtype(categories, ordered=ordered)
    return sr.astype(dtype)


def _clean_gender(sr):
    return _clean_categorical(sr, categories=["Female", "Male"], ordered=False)


def _clean_marital_status(sr):
    return _clean_categorical(
        sr,
        categories=["Single", "Married", "Separated", "Divorced", "Widowed"],
        ordered=False,
    )


def _clean_smoke(sr):
    return _clean_categorical(sr, categories=["No", "Yes"], ordered=True)


def _clean_highest_qualification(sr):
    replace_mapping = {
        "GCSE/CSE": "GCSE/CSE or GCSE/O Level",
        "GCSE/O Level": "GCSE/CSE or GCSE/O Level",
        "Other/Sub Degree": "Other/Sub or Higher/Sub Degree",
        "Higher/Sub Degree": "Other/Sub or Higher/Sub Degree",
    }
    ordered_qualifications = [
        "No Qualification",
        "GCSE/CSE or GCSE/O Level",
        "ONC/BTEC",
        "Other/Sub or Higher/Sub Degree",
        "A Levels",
        "Degree",
    ]
    sr = sr.replace(replace_mapping)
    return _clean_categorical(sr, ordered_qualifications, ordered=True)
