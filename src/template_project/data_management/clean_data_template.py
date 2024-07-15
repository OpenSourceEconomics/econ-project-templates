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


def _clean_gender(sr):
    return _clean_unordered_categorical(sr, categories=["Male", "Female"])


def _clean_marital_status(sr):
    return _clean_unordered_categorical(
        sr,
        categories=["Divorced", "Widowed", "Separated", "Single", "Married"],
    )


def _clean_smoke(sr):
    return _clean_unordered_categorical(sr, categories=["No", "Yes"])


def _clean_highest_qualification(sr):
    replace_mapping = {
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
        "Degree",
    ]
    sr = sr.replace(replace_mapping)
    dtype = pd.CategoricalDtype(ordered_qualifications, ordered=True)
    return sr.astype(dtype)


def _clean_unordered_categorical(sr, categories):
    dtype = pd.CategoricalDtype(categories, ordered=False)
    return sr.astype(dtype)
