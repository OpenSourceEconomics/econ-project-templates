"""Function(s) for cleaning the data set(s)."""

import pandas as pd


def clean_stats4schools_smoking(data):
    """Clean the smoking data set from stats4schools.

    Original source of the data can be found here: https://www.stem.org.uk/rxvt6.

    Args:
        data (pandas.DataFrame): The (uncleaned) stats4schools smoking data set.

    Returns:
        pandas.DataFrame: The cleaned data set.

    """
    clean = pd.DataFrame()

    clean["gender"] = _clean_gender(data["gender"])
    clean["marital_status"] = _clean_marital_status(data["marital_status"])
    clean["current_smoker"] = _clean_current_smoker(data["smoke"])
    clean["current_smoker_numerical"] = clean["current_smoker"].cat.codes
    clean["highest_qualification"] = _clean_highest_qualification(
        data["highest_qualification"],
    )
    clean["age"] = data["age"].astype(int)
    return clean


def _clean_gender(sr):
    return pd.Categorical(sr, categories=["Female", "Male"], ordered=False)


def _clean_marital_status(sr):
    return pd.Categorical(
        sr,
        categories=["Single", "Married", "Separated", "Divorced", "Widowed"],
        ordered=False,
    )


def _clean_current_smoker(sr):
    """Clean the current smoke variable.

    The original variable name 'smoke' was ambiguous, so it has been renamed to
    'current_smoker' for clarity. Note that this interpretation of the variable's
    meaning may not be accurate, as we could not find an interpretation of the variable
    in the data description.

    """
    return pd.Categorical(sr, categories=["No", "Yes"], ordered=True)


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
    return pd.Categorical(sr, categories=ordered_qualifications, ordered=True)
