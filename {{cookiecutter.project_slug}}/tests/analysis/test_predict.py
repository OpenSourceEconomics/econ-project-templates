import pytest
import pandas as pd
from pandas.testing import assert_frame_equal

from {{cookiecutter.project_slug}}.analysis.predict import predict_prob_over_age


@pytest.fixture
def data():
    out = pd.DataFrame([1, 2, 3], columns=["age"])
    out["education"] = ["high-school", "high-school", "university"]
    out["income"] = ["high", "low", "low"]
    return out
    

@pytest.fixture
class model:
    @staticmethod
    def predict(data):
        if data["education"] == "high-school":
            if data["income"] == "low":
                prob = 0.1
            else:
                prob = 0.2
        else:
            if data["income"] == "low":
                prob = 0.3
            else:
                prob = 0.4
        prob = prob * data["age"]
        return prob
    

@pytest.mark.parametrize("group", ["education", "income"])
def test_predict_prob_over_age(data, model, group):
    got = predict_prob_over_age(data, model, group)
    
    if group == "education":
        expected = pd.DataFrame([
            [1, 0.1, 0.3],
            [2, 0.2, 0.6],
            [3, 0.3, 0.9]],
            columns=["age", "high-school", "university"]
        )
    else:
        expected = pd.DataFrame([
            [1, 0.2, 0.1],
            [2, 0.4, 0.2],
            [3, 0.3, 0.3]],
            columns=["age", "high", "low"]
        )
    
    assert_frame_equal(got, expected)