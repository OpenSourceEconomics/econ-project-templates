"""Tasks running the core analyses."""

from pathlib import Path

import pandas as pd
import pytask

from template_project.analysis.model_template import fit_logit_model
from template_project.analysis.predict_template import predict_prob_by_age
from template_project.config import BLD, SRC, TEMPLATE_GROUPS

# In practical scenarios, fitting multiple models for different formulas is common. With
# pytask, we can iterate over these formulas to fit each model using the same code block
# and storing the results in different locations. For simplicity, this example uses a
# single formula.
FORMULA: str = (
    # logit functions in statsmodels expect the binary outcome to be numerical
    "current_smoker_numerical ~ gender + marital_status + age + highest_qualification"
)


def task_fit_model(
    script: Path = SRC / "analysis" / "model_template.py",
    formula: str = FORMULA,
    data: Path = BLD / "data" / "stats4schools_smoking.pickle",
    produces: Path = BLD / "estimation_results" / "baseline.pickle",
) -> None:
    """Fit a logistic regression model."""
    df = pd.read_pickle(data)
    # Realistic projects often involve complex model fitting. Here, the
    # `fit_logit_model` function simplifies this process by encapsulating it into a
    # single call. Ideally, tasks should be streamlined to load data, execute one main
    # function, and save the output, no matter how simple or complex the underlying
    # functionality is.
    model = fit_logit_model(df, formula)
    model.save(produces)


for group in TEMPLATE_GROUPS:
    predict_deps = {
        "data": BLD / "data" / "stats4schools_smoking.pickle",
        "model": BLD / "estimation_results" / "baseline.pickle",
    }

    @pytask.task(id=group)
    def task_predict(
        script: Path = SRC / "analysis" / "predict_template.py",
        group: str = group,
        data_path: Path = BLD / "data" / "stats4schools_smoking.pickle",
        model_path: Path = BLD / "estimation_results" / "baseline.pickle",
        produces: Path = BLD / "predictions" / f"{group}.pickle",
    ) -> None:
        """Predict based on the model estimates."""
        model = pd.read_pickle(model_path)
        data = pd.read_pickle(data_path)
        predicted_prob = predict_prob_by_age(data, model, group)
        predicted_prob.to_pickle(produces)
