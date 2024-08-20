import numpy as np
import pandas as pd
import pytest
from pandas.testing import assert_series_equal

from template_project.data_management.stats4schools_smoking_template import (
    _clean_current_smoker,
    _clean_gender,
    _clean_highest_qualification,
    _clean_marital_status,
    clean_stats4schools_smoking,
)


def assert_categorical_equal(left, right):
    assert_series_equal(pd.Series(left), pd.Series(right))


@pytest.fixture
def data():
    data = {
        "highest_qualification": [
            "No Qualification",
            "GCSE/CSE",
            "GCSE/O Level",
            "ONC/BTEC",
            "Other/Sub Degree",
            "Higher/Sub Degree",
            "A Levels",
            "Degree",
        ],
        "gender": 4 * ["Male"] + 4 * ["Female"],
        "age": 4 * [20] + 4 * [20.5],
        "marital_status": [
            "Divorced",
            "Widowed",
            "Separated",
            "Single",
            "Married",
            "Widowed",
            "Separated",
            "Married",
        ],
        "smoke": 4 * ["Yes"] + 4 * ["No"],
    }
    return pd.DataFrame(data)


def test_age_is_integer(data):
    got = clean_stats4schools_smoking(data)["age"]
    exp = pd.Series(8 * [20], name="age")
    assert_series_equal(got, exp)


def test_current_smoker_numerical_is_numerical(data):
    got = clean_stats4schools_smoking(data)["current_smoker_numerical"]
    exp = pd.Series(4 * [1] + 4 * [0], name="current_smoker_numerical", dtype="int8")
    assert_series_equal(got, exp)


def test_clean_gender(data):
    got = _clean_gender(data["gender"])
    exp = pd.Categorical(
        4 * ["Male"] + 4 * ["Female"],
        categories=["Female", "Male"],
        ordered=False,
    )
    assert_categorical_equal(got, exp)


def test_clean_marital_status(data):
    got = _clean_marital_status(data["marital_status"])
    exp = pd.Categorical(
        [
            "Divorced",
            "Widowed",
            "Separated",
            "Single",
            "Married",
            "Widowed",
            "Separated",
            "Married",
        ],
        categories=["Single", "Married", "Separated", "Divorced", "Widowed"],
        ordered=False,
    )
    assert_categorical_equal(got, exp)


def test_clean_current_smoker(data):
    got = _clean_current_smoker(data["smoke"])
    exp = pd.Categorical(
        4 * ["Yes"] + 4 * ["No"],
        categories=["No", "Yes"],
        ordered=True,
    )
    assert_categorical_equal(got, exp)


def test_clean_highest_qualification(data):
    got = _clean_highest_qualification(data["highest_qualification"])

    exp_vals = [
        "No Qualification",
        "GCSE/CSE or GCSE/O Level",
        "GCSE/CSE or GCSE/O Level",
        "ONC/BTEC",
        "Other/Sub or Higher/Sub Degree",
        "Other/Sub or Higher/Sub Degree",
        "A Levels",
        "Degree",
    ]
    exp = pd.Categorical(
        exp_vals,
        categories=[
            "No Qualification",
            "GCSE/CSE or GCSE/O Level",
            "ONC/BTEC",
            "Other/Sub or Higher/Sub Degree",
            "A Levels",
            "Degree",
        ],
        ordered=True,
    )
    assert_categorical_equal(got, exp)


def test_clean_invalid_qualification():
    qualification = pd.Series(
        [
            "Degree",  # valid category
            "Doctorate",  # invalid category
        ],
    )
    assert _clean_highest_qualification(qualification).tolist() == ["Degree", np.nan]


def test_set_invalid_qualification(data):
    clean = clean_stats4schools_smoking(data)
    qualification = clean["highest_qualification"]
    qualification.update(["Degree"])  # valid category
    with pytest.raises(TypeError, match="Cannot setitem on a Categorical with a new"):
        qualification.update(["Doctorate"])  # invalid category
