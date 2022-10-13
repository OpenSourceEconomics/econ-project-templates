import pandas as pd
import pytask
from {{cookiecutter.project_slug}}.analysis.model import fit_logit_model
from {{cookiecutter.project_slug}}.analysis.model import load_model
from {{cookiecutter.project_slug}}.analysis.predict import predict_prob_by_age
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import GROUPS
from {{cookiecutter.project_slug}}.config import SRC
from {{cookiecutter.project_slug}}.utilities import read_yaml


@pytask.mark.depends_on(
    {
        "data": BLD / "data" / "data_clean.csv",
        "data_info": SRC / "data_management" / "data_info.yaml",
    }
)
@pytask.mark.produces(BLD / "models" / "model.pickle")
def task_fit_model(depends_on, produces):
    data_info = read_yaml(depends_on["data_info"])
    data = pd.read_csv(depends_on["data"])
    model = fit_logit_model(data, data_info, model_type="linear")
    model.save(produces)


for group in GROUPS:

    kwargs = {
        "group": group,
        "produces": BLD / "predictions" / f"{group}-predicted.csv",
    }

    @pytask.mark.depends_on(
        {
            "data": BLD / "data" / "data_clean.csv",
            "model": BLD / "models" / "model.pickle",
        }
    )
    @pytask.mark.task(id=group, kwargs=kwargs)
    def task_predict(depends_on, group, produces):
        model = load_model(depends_on["model"])
        data = pd.read_csv(depends_on["data"])
        predicted_prob = predict_prob_by_age(data, model, group)
        predicted_prob.to_csv(produces, index=False)
