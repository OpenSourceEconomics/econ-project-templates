import shutil
import subprocess
import time
from pathlib import Path

import plotly.graph_objects as go
import pytask

DOCS = Path(__file__).parent.parent.resolve()  # root/docs
DOCS_SCRIPTS = DOCS / "scripts"
FIGURES = DOCS / "source" / "figures" / "generated"


for case in ("model_steps_full", "model_steps_select", "steps_only_full"):

    @pytask.task(id=case)
    def task_visualize_organisational_steps(
        case=case,
        produces=FIGURES / f"{case}.png",
    ):
        fig = _visualize_organisational_steps(case)
        fig.write_image(produces)


for tex_file in ("root_bld_src", "src"):

    @pytask.task(id=tex_file)
    def task_compile_latex(
        depends_on=DOCS_SCRIPTS / "latex" / f"{tex_file}.tex",
        produces=DOCS_SCRIPTS / "latex" / f"{tex_file}.png",
    ):
        subprocess.run(  # noqa: S603
            ("pdflatex", "--shell-escape", depends_on.name),
            cwd=depends_on.parent,
            check=True,
        )
        time.sleep(1)
        subprocess.run(  # noqa: S603
            ("pdflatex", "--shell-escape", depends_on.name),
            cwd=depends_on.parent,
            check=True,
        )
        time.sleep(1)

    @pytask.task(id=tex_file)
    def task_copy_png_to_figures(
        depends_on=DOCS_SCRIPTS / "latex" / f"{tex_file}.png",
        produces=FIGURES / f"{tex_file}.png",
    ):
        shutil.copyfile(str(depends_on), str(produces))


def _visualize_organisational_steps(case):
    """Create pipeline sketch dependent on {case}.

    Args:
        case (str): Must be in {'steps_only_full', 'model_steps_full',
            'model_steps_select'}

    Returns:
        fig (plotly.graph_objects.Figure): Figure object.

    """
    fig = go.Figure()

    # define coordinate dimensions
    fig.add_trace(
        go.Scatter(
            x=[0.75, 4.3],
            y=[0.60, 2.5],
            mode="text",  # this tells plotly to hide the 'data points'
        ),
    )

    # add shapes
    fig = _update_fig_with_shape(case, fig)

    fig.update_xaxes(
        tickvals=[1, 2, 3, 4],
        ticktext=["Data mgmt.", "Analysis", "Final", "Documents"],
        title="Steps to be performed",
    )
    fig.update_yaxes(
        tickvals=[1, 2],
        ticktext=["marital-status", "highest-qualification"],
        title="Variable",
    )

    fig.update_layout(
        margin_l=10,
        margin_r=10,
        margin_b=10,
        margin_t=20,
        width=600,
        height=450,
        template="simple_white",
    )
    return fig


def _update_fig_with_shape(case, fig):
    """Takes figure object and adds a shape on top."""
    fig = go.Figure(fig)  # copy

    if case == "steps_only_full":
        for k in range(4):
            fig = fig.add_shape(
                type="rect",
                x0=0.75 + k,
                x1=1.25 + k,
                y0=0.75,
                y1=2.25,
                fillcolor="green",
            )
    elif case == "model_steps_full":
        for k in range(2):
            fig = fig.add_shape(
                type="rect",
                x0=0.75,
                x1=4.25,
                y0=0.75 + k,
                y1=1.25 + k,
                fillcolor="blue",
            )
    elif case == "model_steps_select":
        for k in (0, 3):
            fig = fig.add_shape(
                type="rect",
                x0=0.75 + k,
                x1=1.25 + k,
                y0=0.75,
                y1=2.25,
                fillcolor="red",
            )
        for k in (1, 2):
            for y0, y1 in ((0.75, 1.25), (1.75, 2.25)):
                fig = fig.add_shape(
                    type="rect",
                    x0=0.75 + k,
                    x1=1.25 + k,
                    y0=y0,
                    y1=y1,
                    fillcolor="red",
                )
    else:
        msg = (
            "Case must be in {'steps_only_full', 'model_steps_full', "
            "'model_steps_select'}",
        )
        raise ValueError(msg)
    return fig
