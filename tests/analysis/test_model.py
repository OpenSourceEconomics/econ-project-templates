"""Tests for the regression model."""

import numpy as np
import pandas as pd
import pytest

from template_project.analysis.model_template import fit_logit_model

DESIRED_PRECISION = 10e-2


@pytest.fixture
def data():
    rng = np.random.default_rng(seed=0)
    x = rng.normal(size=100_000)
    coef = 2.0
    prob = 1 / (1 + np.exp(-coef * x))
    return pd.DataFrame(
        {"outcome_numerical": rng.binomial(1, prob), "covariate": x},
    )


def test_fit_logit_model_recover_coefficients(data):
    formula = "outcome_numerical ~ covariate"
    model = fit_logit_model(data, formula=formula)
    params = model.params
    assert np.abs(params["Intercept"]) < DESIRED_PRECISION
    assert np.abs(params["covariate"] - 2.0) < DESIRED_PRECISION
