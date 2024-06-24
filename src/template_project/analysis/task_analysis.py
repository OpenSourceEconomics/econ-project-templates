"""Tasks running the core analyses."""

import pandas as pd
import pytask

from template_project.analysis.model import fit_logit_model, load_model
from template_project.analysis.predict import predict_prob_by_age
from template_project.config import BLD, GROUPS, SRC
from template_project.utilities import read_yaml


def task_fit_model_python(
    script=SRC / "analysis" / "model.py",
    data=BLD / "python" / "data" / "data_clean.csv",
    data_info=SRC / "data_management" / "data_info.yaml",
    produces=BLD / "python" / "models" / "model.pickle",
):
    """Fit a logistic regression model (Python version)."""
    data_info = read_yaml(data_info)
    data = pd.read_csv(data)
    model = fit_logit_model(data, data_info, model_type="linear")
    model.save(produces)


for group in GROUPS:
    predict_deps = {
        "data": BLD / "python" / "data" / "data_clean.csv",
        "model": BLD / "python" / "models" / "model.pickle",
    }

    @pytask.task(id=group)
    def task_predict_python(
        script=SRC / "analysis" / "predict.py",
        group=group,
        data_path=BLD / "python" / "data" / "data_clean.csv",
        model_path=BLD / "python" / "models" / "model.pickle",
        produces=BLD / "python" / "predictions" / f"{group}.csv",
    ):
        """Predict based on the model estimates (Python version)."""
        model = load_model(model_path)
        data = pd.read_csv(data_path)
        predicted_prob = predict_prob_by_age(data, model, group)
        predicted_prob.to_csv(produces, index=False)


@pytask.mark.r(script=SRC / "analysis" / "model.r", serializer="yaml")
def task_fit_model_r(
    data=BLD / "r" / "data" / "data_clean.csv",
    data_info=SRC / "data_management" / "data_info.yaml",
    produces=BLD / "r" / "models" / "model.rds",
):
    """Fit a logistic regression model (R version)."""


for group in GROUPS:

    @pytask.task(id=group)
    @pytask.mark.r(script=SRC / "analysis" / "predict.r", serializer="yaml")
    def task_predict_r(
        group=group,
        data_path=BLD / "r" / "data" / "data_clean.csv",
        model_path=BLD / "r" / "models" / "model.rds",
        produces=BLD / "r" / "predictions" / f"{group}.csv",
    ):
        """Predict based on the model estimates (R version)."""
