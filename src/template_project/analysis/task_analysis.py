"""Tasks running the core analyses."""

from pathlib import Path

import pandas as pd
import pytask

from template_project.analysis.model import fit_logit_model, load_model
from template_project.analysis.predict import predict_prob_by_age
from template_project.config import BLD, GROUPS, SRC
from template_project.utilities import read_yaml


def task_fit_model_python(
    script: Path = SRC / "analysis" / "model.py",
    data: Path = BLD / "python" / "data" / "data_clean.csv",
    data_info: Path = SRC / "data_management" / "data_info.yaml",
    produces: Path = BLD / "python" / "models" / "model.pickle",
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
        script: Path = SRC / "analysis" / "predict.py",
        group: str = group,
        data_path: Path = BLD / "python" / "data" / "data_clean.csv",
        model_path: Path = BLD / "python" / "models" / "model.pickle",
        produces: Path = BLD / "python" / "predictions" / f"{group}.csv",
    ):
        """Predict based on the model estimates (Python version)."""
        model = load_model(model_path)
        data = pd.read_csv(data_path)
        predicted_prob = predict_prob_by_age(data, model, group)
        predicted_prob.to_csv(produces, index=False)


@pytask.mark.r(script=SRC / "analysis" / "model.r", serializer="yaml")
def task_fit_model_r(
    data: Path = BLD / "r" / "data" / "data_clean.csv",
    data_info: Path = SRC / "data_management" / "data_info.yaml",
    produces: Path = BLD / "r" / "models" / "model.rds",
):
    """Fit a logistic regression model (R version)."""


for group in GROUPS:

    @pytask.task(id=group)
    @pytask.mark.r(script=SRC / "analysis" / "predict.r", serializer="yaml")
    def task_predict_r(
        group: str = group,
        data_path: Path = BLD / "r" / "data" / "data_clean.csv",
        model_path: Path = BLD / "r" / "models" / "model.rds",
        produces: Path = BLD / "r" / "predictions" / f"{group}.csv",
    ):
        """Predict based on the model estimates (R version)."""
