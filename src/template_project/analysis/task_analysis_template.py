"""Tasks running the core analyses."""

import pandas as pd
import pytask
import yaml

from template_project.analysis.model_template import fit_logit_model, load_model
from template_project.analysis.predict_template import predict_prob_by_age
from template_project.config import BLD, SRC, TEMPLATE_GROUPS


def task_fit_model(
    script=SRC / "analysis" / "model_template.py",
    data=BLD / "data" / "data_clean.pickle",
    data_info=SRC / "data_management" / "data_info_template.yaml",
    produces=BLD / "models" / "model.pickle",
):
    """Fit a logistic regression model."""
    with data_info.open() as file:
        data_info = yaml.safe_load(file)
    data = pd.read_pickle(data)
    model = fit_logit_model(data, data_info, model_type="linear")
    model.save(produces)


for group in TEMPLATE_GROUPS:
    predict_deps = {
        "data": BLD / "data" / "data_clean.pickle",
        "model": BLD / "models" / "model.pickle",
    }

    @pytask.task(id=group)
    def task_predict(
        script=SRC / "analysis" / "predict_template.py",
        group=group,
        data_path=BLD / "data" / "data_clean.pickle",
        model_path=BLD / "models" / "model.pickle",
        produces=BLD / "predictions" / f"{group}.pickle",
    ):
        """Predict based on the model estimates."""
        model = load_model(model_path)
        data = pd.read_pickle(data_path)
        predicted_prob = predict_prob_by_age(data, model, group)
        predicted_prob.to_pickle(produces)


@pytask.mark.r(script=SRC / "analysis" / "model_template.r", serializer="yaml")
def task_fit_model_r(
    data=BLD / "data" / "data_clean.rds",
    data_info=SRC / "data_management" / "data_info_template.yaml",
    produces=BLD / "models" / "model.rds",
):
    """Fit a logistic regression model (R version)."""


for group in TEMPLATE_GROUPS:

    @pytask.task(id=group)
    @pytask.mark.r(script=SRC / "analysis" / "predict_template.r", serializer="yaml")
    def task_predict_r(
        group=group,
        data_path=BLD / "data" / "data_clean.rds",
        model_path=BLD / "models" / "model.rds",
        produces=BLD / "predictions" / f"{group}.rds",
    ):
        """Predict based on the model estimates (R version)."""
