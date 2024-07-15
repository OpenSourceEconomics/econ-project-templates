"""Functions for fitting the regression model."""

import statsmodels.formula.api as smf
from statsmodels.iolib.smpickle import load_pickle


def fit_logit_model(data, formula, model_type):
    """Fit a logit model to data.

    Args:
        data (pandas.DataFrame): The data set.
        formula (str): The formula for the logit model.
        model_type (str): What model to use for the logit. Currently implemented:
            - 'linear_index': Numerical covariates enter the logit index linearly; and
            categorical covariates are expanded to dummy variables.

    Returns:
        statsmodels.base.model.Results: The fitted model.

    """
    if model_type != "linear_index":
        message = "Only 'linear_index' model_type is supported right now."
        raise ValueError(message)

    return smf.logit(formula, data=data).fit()


def load_model(path):
    """Load statsmodels model.

    Args:
        path (str or pathlib.Path): Path to model file.

    Returns:
        statsmodels.base.model.Results: The stored model.

    """
    return load_pickle(path)
