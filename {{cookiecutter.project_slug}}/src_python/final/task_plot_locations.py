import itertools
import pickle

import numpy as np
import plotly.graph_objects as go
import pytask
from plotly.subplots import make_subplots

from src.config import BLD


def plot_locations(locations_by_round, path):
    "Plot the distribution of agents after cycle_num rounds of the loop."
    n_cycles = len(locations_by_round)
    nrows = int(np.ceil(n_cycles / 2 - 0.01))
    ncols = 2
    # figure measurements are specified in pixels in plotly
    width, height = (200 * ncols, 200 * nrows)

    fig = make_subplots(
        rows=nrows,
        cols=ncols,
        shared_xaxes=True,
        shared_yaxes=True,
        vertical_spacing=0.07,
        horizontal_spacing=0.07,
        subplot_titles=[f"Cycle {n}" for n in range(len(locations_by_round))],
    )

    for row, col in itertools.product(range(nrows), range(ncols)):
        n_cycle = row * ncols + col
        if n_cycle == n_cycles:
            break

        locs = locations_by_round[n_cycle]

        for key, color in zip([0, 1], ["orange", "green"]):
            data = go.Scatter(
                x=locs[key][:, 0],
                y=locs[key][:, 1],
                mode="markers",
                marker_size=5,
                marker_color=color,
                marker_line_color="black",
                marker_line_width=0.5,
                opacity=0.6,
                showlegend=False,
            )
            # rows and cols are indexed starting from (1, 1) in plotly
            fig = fig.add_trace(
                data,
                row=row + 1,
                col=col + 1,
            )

    fig = fig.update_xaxes(
        showline=True,
        linecolor="black",
        mirror=True,
        dtick=0.25,
        showticklabels=True,
    )

    fig = fig.update_yaxes(
        showline=True,
        linecolor="black",
        mirror=True,
        dtick=0.25,
        scaleanchor="x",
        scaleratio=1,
    )

    # subplot titles are defined as annotations
    fig = fig.update_annotations(font_size=14)

    fig = fig.update_layout(
        margin_l=10,
        margin_r=10,
        margin_b=10,
        margin_t=20,
        width=width,
        height=height,
        plot_bgcolor="azure",
        font_size=14,
    )
    fig.write_image(path)


specifications = (
    (
        BLD / "analysis" / f"schelling_{model_name}.pickle",
        BLD / "figures" / f"schelling_{model_name}.png",
    )
    for model_name in ["baseline", "max_moves_2"]
)


@pytask.mark.parametrize("depends_on, produces", specifications)
def task_plot_locations(depends_on, produces):
    # Load locations after each round
    with open(depends_on, "rb") as f:
        locations_by_round = pickle.load(f)

    plot_locations(locations_by_round, produces)
