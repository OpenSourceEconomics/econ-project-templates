import pytask
from {{cookiecutter.project_slug}}.config import BLD
from {{cookiecutter.project_slug}}.config import GROUPS
from {{cookiecutter.project_slug}}.config import SRC
{% if cookiecutter.add_python_example == 'yes' %}
import pandas as pd
from {{cookiecutter.project_slug}}.analysis.model import fit_logit_model
from {{cookiecutter.project_slug}}.analysis.model import load_model
from {{cookiecutter.project_slug}}.analysis.predict import predict_prob_by_age
from {{cookiecutter.project_slug}}.utilities import read_yaml

@pytask.mark.depends_on(
    {
        "data": BLD / "python" / "data" / "data_clean.csv",
        "data_info": SRC / "data_management" / "data_info.yaml",
    }
)
@pytask.mark.produces(BLD / "python" / "models" / "model.pickle")
def task_fit_model_python(depends_on, produces):
    data_info = read_yaml(depends_on["data_info"])
    data = pd.read_csv(depends_on["data"])
    model = fit_logit_model(data, data_info, model_type="linear")
    model.save(produces)


for group in GROUPS:

    kwargs = {
        "group": group,
        "produces": BLD / "python" / "predictions" / f"{group}-predicted.csv",
    }

    @pytask.mark.depends_on(
        {
            "data": BLD / "python" / "data" / "data_clean.csv",
            "model": BLD / "python" / "models" / "model.pickle",
        }
    )
    @pytask.mark.task(id=group, kwargs=kwargs)
    def task_predict_python(depends_on, group, produces):
        model = load_model(depends_on["model"])
        data = pd.read_csv(depends_on["data"])
        predicted_prob = predict_prob_by_age(data, model, group)
        predicted_prob.to_csv(produces, index=False)
{% endif %}

{% if cookiecutter.add_r_example == 'yes' %}
@pytask.mark.r(script=SRC / "analysis" / "task_fit_model.r", serializer="yaml")
@pytask.mark.depends_on(
    {
        "data": BLD / "r" / "data" / "data_clean.csv",
        "data_info": SRC / "data_management" / "data_info.yaml",
        "SRC": SRC,
    }
)
@pytask.mark.produces(BLD / "r" / "models" / "model.rds")
def task_fit_model_r():
    pass


for group in GROUPS:

    kwargs = {
        "group": group,
        "produces": BLD / "r" / "predictions" / f"{group}-predicted.csv",
    }

    @pytask.mark.depends_on(
        {
            "data": BLD / "r" / "data" / "data_clean.csv",
            "model": BLD / "r" / "models" / "model.rds",
            "SRC": SRC,
        }
    )
    @pytask.mark.task(id=group, kwargs=kwargs)
    @pytask.mark.r(script=SRC /  "analysis" / "task_predict.r", serializer="yaml")
    def task_predict_r():
        pass
{% endif %}