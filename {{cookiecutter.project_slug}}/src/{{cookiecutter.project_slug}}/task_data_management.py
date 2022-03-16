import pandas as pd
import pytask
from src.config import BLD
from src.data_management import clean_data


@pytask.mark.produces(BLD / "data" / "smoking.csv")
def task_get_smoking_data(produces):
    data_url = "https://www.openintro.org/data/csv/smoking.csv"
    data = pd.read_csv(data_url)
    data.to_csv(produces)


@pytask.mark.depends_on(BLD / "data" / "smoking.csv")
@pytask.mark.produces(BLD / "data" / "smoking_clean.csv")
def task_get_smoking_data(depends_on, produces):
    data = pd.read_csv(depends_on)
    data = clean_data(data)
    data.to_csv(produces)
