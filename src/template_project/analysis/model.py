"""Functions for fitting the regression model."""

import statsmodels.formula.api as smf
from statsmodels.iolib.smpickle import load_pickle


def fit_logit_model(data, data_info, model_type):
    """Fit a logit model to data.

    Args:
        data (pandas.DataFrame): The data set.
        data_info (dict): Information on data set stored in data_info.yaml. The
            following keys can be accessed:
            - 'outcome': Name of dependent variable column in data
            - 'outcome_numerical': Name to be given to the numerical version of outcome
            - 'columns_to_drop': Names of columns that are dropped in data cleaning step
            - 'categorical_columns': Names of columns that are converted to categorical
            - 'column_rename_mapping': Old and new names of columns to be renamend,
                stored in a dictionary with design: {'old_name': 'new_name'}
            - 'url': URL to data set
        model_type (str): What model to build for the linear relationship of the logit
            model. Currently implemented:
            - 'linear': Numerical covariates enter the regression linearly, and
            categorical covariates are expanded to dummy variables.

    Returns:
        statsmodels.base.model.Results: The fitted model.

    """
    outcome_name = data_info["outcome"]
    outcome_name_numerical = data_info["outcome_numerical"]
    feature_names = list(set(data.columns) - {outcome_name, outcome_name_numerical})

    if model_type == "linear":
        # smf.logit expects the binary outcome to be numerical
        formula = f"{outcome_name_numerical} ~ " + " + ".join(feature_names)
    else:
        message = "Only 'linear' model_type is supported right now."
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
