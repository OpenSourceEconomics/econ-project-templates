import itertools
from pathlib import Path

import pytask

from src.config import BLD


model_names = ["baseline", "rmconj"]
stages = ["first", "second"]
specs = [
    {
        "do": Path(f"{stage}_stage_estimation.do"),
        "deps": [
            BLD / "model_specs" / f"{model}.do",
            BLD / "model_specs" / "geography.do",
            BLD / "data" / "ajrcomment_all.dta",
        ],
        "log": BLD / "analysis" / "log" / f"{stage}_stage_estimation_{model}.log",
        "result": BLD / "analysis" / f"{stage}_stage_estimation_{model}.dta",
    }
    for model, stage in itertools.product(model_names, stages)
]


@pytask.mark.parametrize(
    "stata, depends_on, produces",
    [
        (
            [str(x) for x in [s["log"], *s["deps"], s["result"]]],
            [s["do"], *s["deps"]],
            [s["log"], s["result"]],
        )
        for s in specs
    ],
)
def task_estimate():
    pass
