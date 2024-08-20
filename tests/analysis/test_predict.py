"""Tests for the prediction model."""

import pandas as pd
import pytest
from pandas.testing import assert_frame_equal

from template_project.analysis.predict_template import predict_prob_by_age


@pytest.fixture
def data():
    out = pd.DataFrame([1, 2, 3], columns=["age"])
    out["education"] = ["high-school", "high-school", "university"]
    out["income"] = ["high", "low", "low"]
    return out


@pytest.fixture
def model():
    class ModelClass:
        @staticmethod
        def predict(data):
            if "high-school" in data["education"].to_numpy():
                prob = 0.1 if "low" in data["income"].to_numpy() else 0.2
            else:
                prob = 0.3 if "low" in data["income"].to_numpy() else 0.4
            return prob * data["age"]

    return ModelClass


@pytest.mark.parametrize("group", ["education", "income"])
def test_predict_prob_over_age(data, model, group):
    got = predict_prob_by_age(data, model, group)

    if group == "education":
        expected = pd.DataFrame(
            [[1, 0.1, 0.3], [2, 0.2, 0.6], [3, 0.3, 0.9]],
            columns=["age", "high-school", "university"],
        )
    else:
        expected = pd.DataFrame(
            [[1, 0.2, 0.1], [2, 0.4, 0.2], [3, 0.6, 0.3]],
            columns=["age", "high", "low"],
        )

    assert_frame_equal(got, expected)
