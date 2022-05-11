import shutil
import subprocess
import sys
import time
from pathlib import Path

import pytask

SRC = Path(__file__).parent.resolve()  # root/docs/scripts
FIGURES = SRC.parent.resolve().joinpath("source").joinpath("figures").resolve()
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


for tex_file in ["root_bld_src", "src"]:

    @pytask.mark.depends_on(SRC.joinpath("latex").joinpath(f"{tex_file}.tex"))
    @pytask.mark.produces(SRC.joinpath(f"{tex_file}.png"))
    @pytask.mark.task(id=tex_file)
    def task_compile_latex(depends_on):
        subprocess.Popen(["pdflatex", "--shell-escape", str(depends_on)])
        time.sleep(1)
        subprocess.Popen(["pdflatex", "--shell-escape", str(depends_on)])
        time.sleep(1)

    @pytask.mark.depends_on(SRC.joinpath(f"{tex_file}.png"))
    @pytask.mark.produces(FIGURES.joinpath(f"{tex_file}.png"))
    @pytask.mark.task(id=tex_file)
    def task_copy_png_to_figures(depends_on, produces):
        shutil.copyfile(str(depends_on), str(produces))
