"""Functions for fitting the regression model."""

import pandas as pd
import statsmodels.formula.api as smf
from statsmodels.discrete.discrete_model import BinaryResultsWrapper


def fit_logit_model(data: pd.DataFrame, formula: str) -> BinaryResultsWrapper:
    """Fit a logit model to data.

    Args:
        data (pandas.DataFrame): The data set.
        formula (str): The formula used to fit the logit model.

    Returns:
        statsmodels.base.model.Results: The fitted model.

    """
    return smf.logit(formula, data=data).fit()
