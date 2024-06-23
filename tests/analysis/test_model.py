"""Tests for the regression model."""

import numpy as np
import pandas as pd
import pytest
from template_project.analysis.model import fit_logit_model

DESIRED_PRECISION = 10e-2


@pytest.fixture()
def data():
    rng = np.random.default_rng(seed=0)
    x = rng.normal(size=100_000)
    coef = 2.0
    prob = 1 / (1 + np.exp(-coef * x))
    return pd.DataFrame(
        {"outcome_numerical": rng.binomial(1, prob), "covariate": x},
    )


@pytest.fixture()
def data_info():
    return {"outcome": "outcome", "outcome_numerical": "outcome_numerical"}


def test_fit_logit_model_recover_coefficients(data, data_info):
    model = fit_logit_model(data, data_info, model_type="linear")
    params = model.params
    assert np.abs(params["Intercept"]) < DESIRED_PRECISION
    assert np.abs(params["covariate"] - 2.0) < DESIRED_PRECISION


def test_fit_logit_model_error_model_type(data, data_info):
    with pytest.raises(ValueError):  # noqa: PT011
        assert fit_logit_model(data, data_info, model_type="quadratic")
