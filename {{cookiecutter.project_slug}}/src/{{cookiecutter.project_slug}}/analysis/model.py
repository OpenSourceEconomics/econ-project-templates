import statsmodels.formula.api as smf
from statsmodels.iolib.smpickle import load_pickle
from {{cookiecutter.project_slug}}.data_management import convert_outcome_to_numerical


def fit_logit_model(data, data_info, model_type):
    """Fit a logit model to data.
    
    Args:
        data (pandas.DataFrame): The data set.
        data_info (dict): Information on data set. Contains keys
            - 'dependent_variable': Name of dependent variable column in data
            - 'columns_to_drop': Names of columns that are dropped in data cleaning step
            - 'categorical_columns': Names of columns that are converted to categorical
            - 'column_rename_mapping': Rename mapping
            - 'url': URL to data set
        model_type (str): What model to build for the linear relationship of the logit
            model. Currently implemented:
            - 'linear': Numerical covariates enter the regression linearly, and
            categorical covariates are expanded to dummy variables.

    Returns:
        statsmodels.base.model.Results: The fitted model.
    
    """
    outcome_name = data_info["dependent_variable"]
    feature_names = data.columns[data.columns != outcome_name]

    if model_type == "linear":
        formula = f"{outcome_name} ~ " + " + ".join(feature_names)
    else:
        message = "Only 'linear' model_type is supported right now."
        raise ValueError(message)

    # convert outcome to binary data
    data = data.copy()
    data[outcome_name] = convert_outcome_to_numerical(data[outcome_name])

    model = smf.logit(formula, data=data).fit()
    return model


def load_model(path):
    """Load statsmodels model.

    Args:
        path (str or pathlib.Path): Path to model file.
        
    Returns:
        statsmodels.base.model.Results: The stored model.
    
    """
    model = load_pickle(path)
    return model
