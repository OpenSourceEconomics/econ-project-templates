import itertools
from pathlib import Path

import pytask

from src.config import BLD
from src.config import SRC


model_names = ["baseline", "rmconj"]
stages = ["first", "second"]
specs = [
    {
        "r": Path(f"{stage}_stage_estimation.r"),
        "deps": [
            SRC / "model_code" / "functions.r",
            SRC / "model_specs" / f"{model}.json",
            SRC / "model_specs" / "geography.json",
            BLD / "data" / "ajrcomment_all.csv",
        ],
        "result": BLD / "analysis" / f"{stage}_stage_estimation_{model}.csv",
    }
    for model, stage in itertools.product(model_names, stages)
]


@pytask.mark.parametrize(
    "r, depends_on, produces",
    [
        (
            [str(x) for x in [*s["deps"], s["result"]]],
            [s["r"], *s["deps"]],
            [s["result"]],
        )
        for s in specs
    ],
)
def task_estimate():
    pass
