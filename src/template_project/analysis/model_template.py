"""Functions for fitting the regression model."""

import statsmodels.formula.api as smf


def fit_logit_model(data, formula):
    """Fit a logit model to data.

    Args:
        data (pandas.DataFrame): The data set.
        formula (str): The formula used to fit the logit model.

    Returns:
        statsmodels.base.model.Results: The fitted model.

    """
    return smf.logit(formula, data=data).fit()
