"""Tasks running the core analyses."""

import pandas as pd
import pytask

from template_project.analysis.model_template import fit_logit_model
from template_project.analysis.predict_template import predict_prob_by_age
from template_project.config import BLD, SRC, TEMPLATE_GROUPS

# In practical scenarios, fitting multiple models for different formulas is common. With
# pytask, we can iterate over these formulas to fit each model using the same code block
# and storing the results in different locations. For simplicity, this example uses a
# single formula.
formula = (
    # logit functions in Python and R expect the binary outcome to be numerical
    "current_smoker_numerical ~ "
    "gender + marital_status + age + highest_qualification"
)


def task_fit_model(
    script=SRC / "analysis" / "model_template.py",
    formula=formula,
    data=BLD / "data" / "stats4schools_smoking.pickle",
    produces=BLD / "estimation_results" / "baseline.pickle",
):
    """Fit a logistic regression model."""
    data = pd.read_pickle(data)
    # Realistic projects often involve complex model fitting. Here, the
    # `fit_logit_model` function simplifies this process by encapsulating it into a
    # single call. Ideally, tasks should be streamlined to load data, execute one main
    # function, and save the output, no matter how simple or complex the underlying
    # functionality is.
    model = fit_logit_model(data, formula)
    model.save(produces)


for group in TEMPLATE_GROUPS:
    predict_deps = {
        "data": BLD / "data" / "stats4schools_smoking.pickle",
        "model": BLD / "estimation_results" / "baseline.pickle",
    }

    @pytask.task(id=group)
    def task_predict(
        script=SRC / "analysis" / "predict_template.py",
        group=group,
        data_path=BLD / "data" / "stats4schools_smoking.pickle",
        model_path=BLD / "estimation_results" / "baseline.pickle",
        produces=BLD / "predictions" / f"{group}.pickle",
    ):
        """Predict based on the model estimates."""
        model = pd.read_pickle(model_path)
        data = pd.read_pickle(data_path)
        predicted_prob = predict_prob_by_age(data, model, group)
        predicted_prob.to_pickle(produces)


@pytask.mark.r(script=SRC / "analysis" / "model_template.r", serializer="yaml")
def task_fit_model_r(
    formula=formula,
    data=BLD / "data" / "stats4schools_smoking.rds",
    produces=BLD / "estimation_results" / "baseline.rds",
):
    """Fit a logistic regression model (R version)."""


for group in TEMPLATE_GROUPS:

    @pytask.task(id=group)
    @pytask.mark.r(script=SRC / "analysis" / "predict_template.r", serializer="yaml")
    def task_predict_r(
        group=group,
        data_path=BLD / "data" / "stats4schools_smoking.rds",
        model_path=BLD / "estimation_results" / "baseline.rds",
        produces=BLD / "predictions" / f"{group}.rds",
    ):
        """Predict based on the model estimates (R version)."""
