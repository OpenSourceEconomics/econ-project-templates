import sys
from pathlib import Path

import pytask

SRC = Path(__file__).parent.resolve()
FIGURES = SRC.parent.resolve()
sys.path.append(str(SRC))

from visualization_functions import visualize_organisational_steps


for case in ["model_steps_full", "model_steps_select", "steps_only_full"]:

    kwargs = {
        "case": case,
        "produces": FIGURES / f"{case}.png",
    }

    @pytask.mark.task(id=case, kwargs=kwargs)
    def task_visualize_organisational_steps(produces, case):
        fig = visualize_organisational_steps(case)
        fig.write_image(produces)


# for doc in ["root_bld_src", "src"]:
#
#     $ pdflatex --shell-escape ${doc}.tex  # call this in a terminal
#
