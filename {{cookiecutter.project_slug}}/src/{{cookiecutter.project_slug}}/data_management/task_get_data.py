"""Read the Survey data on smoking habits from the UK
from urls, save them into a csv file.\n
The data collected here includes:\n
1. Gross income with levels\n
2. Smoking status with levels No and Yes\n
3. Further demographic characteristics as gender, age or marital status\n
4. Types of consumed tobacco\n
"""


import pandas as pd
import pytask
from pathlib import Path
from src.config import SRC

df = "https://github.com/LOST-STATS/lost-stats.github.io/raw/source/Model_Estimation/Matching/Data/smoking.csv"


@pytask.mark.produces(SRC / "original_data" / "smoking.csv")
def task_get_smoking_data(produces):
    data = pd.read_csv(df)
    data.to_csv(produces)



