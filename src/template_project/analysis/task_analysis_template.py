"""Tasks running the core analyses."""

import pandas as pd
import pytask

from template_project.analysis.model_template import fit_logit_model, load_model
from template_project.analysis.predict_template import predict_prob_by_age
from template_project.config import BLD, SRC, TEMPLATE_GROUPS


def task_fit_model(
    script=SRC / "analysis" / "model_template.py",
    data=BLD / "data" / "stats4schools_smoking.pickle",
    produces=BLD / "models" / "model.pickle",
):
    """Fit a logistic regression model."""
    data = pd.read_pickle(data)
    # smf.logit expects the binary outcome to be numerical
    formula = "smoke_numerical ~ gender + marital_status + age + highest_qualification"
    model = fit_logit_model(data, formula, model_type="linear")
    model.save(produces)


for group in TEMPLATE_GROUPS:
    predict_deps = {
        "data": BLD / "data" / "stats4schools_smoking.pickle",
        "model": BLD / "models" / "model.pickle",
    }

    @pytask.task(id=group)
    def task_predict(
        script=SRC / "analysis" / "predict_template.py",
        group=group,
        data_path=BLD / "data" / "stats4schools_smoking.pickle",
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
    data=BLD / "data" / "stats4schools_smoking.rds",
    produces=BLD / "models" / "model.rds",
):
    """Fit a logistic regression model (R version)."""


for group in TEMPLATE_GROUPS:

    @pytask.task(id=group)
    @pytask.mark.r(script=SRC / "analysis" / "predict_template.r", serializer="yaml")
    def task_predict_r(
        group=group,
        data_path=BLD / "data" / "stats4schools_smoking.rds",
        model_path=BLD / "models" / "model.rds",
        produces=BLD / "predictions" / f"{group}.rds",
    ):
        """Predict based on the model estimates (R version)."""
