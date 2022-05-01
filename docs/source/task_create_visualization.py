import shutil
import sys
from pathlib import Path

import pytask

SRC = Path(__file__).parent.resolve()
sys.path.append(str(SRC))

from visualization_functions import visualize_organisational_steps
from visualization_functions import get_prelude
from visualization_functions import get_body
from visualization_functions import get_end_doc


for case in ["model_steps_full", "model_steps_select", "steps_only_full"]:

    kwargs = {
        "case": case,
        "produces": SRC / "figures" / f"{case}.png",
    }

    @pytask.mark.task(id=case, kwargs=kwargs)
    def task_visualize_organisational_steps(produces, case):
        fig = visualize_organisational_steps(case)
        fig.write_image(produces)


DIRECTORIES = ["data", "data_management", "analysis", "final", "paper"]

for key in DIRECTORIES:

    kwargs = {
        "key": key,
        "produces": SRC / "_tmp" / f"{key}.tex",
    }

    @pytask.mark.try_first
    @pytask.mark.task(id=key, kwargs=kwargs)
    def task_create_tex_file(produces, key):
        prelude = get_prelude()
        body = get_body(key)
        end_doc = get_end_doc()
        with open(produces, "w") as f:
            f.write(prelude)
            f.write(body)
            f.write(end_doc)

    @pytask.mark.depends_on(SRC / "_tmp" / f"{key}.tex")
    @pytask.mark.latex(
        script=SRC / "_tmp" / f"{key}.tex", document=SRC / "_tmp" / f"{key}.pdf"
    )
    @pytask.mark.task(id=key)
    def task_compile_tex_file():
        pass

    kwargs = {
        "depends_on": SRC / "_tmp" / f"{key}.pdf",
        "produces": SRC / "figures" / f"{key}.pdf",
    }

    @pytask.mark.task(id=key, kwargs=kwargs)
    def task_copy_to_root(depends_on, produces):
        shutil.copy(depends_on, produces)


# @pytask.mark.depends_on([SRC / "figures" / f"{key}.pdf" for key in DIRECTORIES])
# def task_remove_tmp_folder():
#     shutil.rmtree(SRC / "_tmp")
