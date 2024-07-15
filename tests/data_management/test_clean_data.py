import pandas as pd
import pytest
from pandas.testing import assert_series_equal
from template_project.data_management.clean_data_template import (
    _clean_gender,
    _clean_highest_qualification,
    _clean_marital_status,
    _clean_smoke,
    clean_data,
)


@pytest.fixture()
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
    got = clean_data(data)["age"]
    exp = pd.Series(8 * [20], name="age")
    assert_series_equal(got, exp)


def test_smoke_numerical_is_numerical(data):
    got = clean_data(data)["smoke_numerical"]
    exp = pd.Series(4 * [1] + 4 * [0], name="smoke_numerical", dtype="int8")
    assert_series_equal(got, exp)


def test_clean_gender(data):
    got = _clean_gender(data["gender"])
    exp = pd.Series(
        pd.Categorical(
            4 * ["Male"] + 4 * ["Female"],
            categories=["Male", "Female"],
            ordered=False,
        ),
        name="gender",
    )
    assert_series_equal(got, exp)


def test_clean_marital_status(data):
    got = _clean_marital_status(data["marital_status"])
    exp = pd.Series(
        pd.Categorical(
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
            categories=["Divorced", "Widowed", "Separated", "Single", "Married"],
            ordered=False,
        ),
        name="marital_status",
    )
    assert_series_equal(got, exp)


def test_clean_smoke(data):
    got = _clean_smoke(data["smoke"])
    exp = pd.Series(
        pd.Categorical(
            4 * ["Yes"] + 4 * ["No"],
            categories=["No", "Yes"],
            ordered=False,
        ),
        name="smoke",
    )
    assert_series_equal(got, exp)


def test_clean_highest_qualification(data):
    got = _clean_highest_qualification(data["highest_qualification"])

    exp_vals = [
        "No Qualification",
        "GCSE/CSE or GCSE/O Level",
        "GCSE/CSE or GCSE/O Level",
        "ONC/BTEC",
        "Other or Higher/Sub Degree",
        "Other or Higher/Sub Degree",
        "A Levels",
        "Degree",
    ]
    exp = pd.Series(
        pd.Categorical(
            exp_vals,
            categories=[
                "No Qualification",
                "GCSE/CSE or GCSE/O Level",
                "ONC/BTEC",
                "Other or Higher/Sub Degree",
                "A Levels",
                "Degree",
            ],
            ordered=True,
        ),
        name="highest_qualification",
    )
    assert_series_equal(got, exp)
