import pandas as pd
import statsmodels.formula.api as smf
from statsmodels.iolib.smpickle import load_pickle


def fit_logit_model(data, data_info, model_type):
    outcome_name = data_info["dependent_variable"]
    feature_names = data.columns[data.columns != outcome_name]

    if model_type == "linear":
        formula = f"{outcome_name} ~ " + " + ".join(feature_names)
    else:
        raise NotImplementedError

    # convert outcome to binary data
    data = data.copy()
    data[outcome_name] = pd.Categorical(data[outcome_name]).codes

    model = smf.logit(formula, data=data).fit()

    return model


def load_model(path):
    model = load_pickle(path)
    return model
