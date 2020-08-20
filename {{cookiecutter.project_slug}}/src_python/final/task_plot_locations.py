import json
import pickle

import matplotlib
import numpy as np
import pytask
from src.config import BLD, SRC

matplotlib.use("TkAgg")
import matplotlib.pyplot as plt


PLOT_ARGS = {"markersize": 4, "alpha": 0.6}


def plot_locations(locations_by_round, path):
    "Plot the distribution of agents after cycle_num rounds of the loop."
    n_cycles = len(locations_by_round)
    nrows = int(np.ceil(n_cycles / 2 - 0.01))
    figsize = (2 * 3, nrows * 2)
    fig, axes = plt.subplots(nrows=nrows, ncols=2, figsize=figsize)
    fig.subplots_adjust(
        left=0.05, right=0.95, bottom=0.05, top=0.95, wspace=0.25, hspace=0.25
    )
    for item, ax in np.ndenumerate(axes):
        n_cycle = item[0] * 2 + item[1]
        if n_cycle == n_cycles:
            # Remove last element if number of cycles is uneven
            fig.delaxes(ax)
            break
        locs = locations_by_round[n_cycle]
        ax.set_title(f"Cycle {n_cycle}")
        ax.tick_params(labelbottom="off", labelleft="off")
        ax.set_facecolor("azure")
        ax.plot(
            locs[0][:, 0], locs[0][:, 1], "o", markerfacecolor="orange", **PLOT_ARGS
        )
        ax.plot(locs[1][:, 0], locs[1][:, 1], "o", markerfacecolor="green", **PLOT_ARGS)

    fig.savefig(path)


@pytask.mark.parametrize(
    "model, depends_on, produces",
    [
        (
            model,
            [
                BLD / "analysis" / f"schelling_{model}.pickle",
                SRC / "model_specs" / f"{model}.json",
            ],
            BLD / "figures" / f"schelling_{model}.png",
        )
        for model in ["baseline", "max_moves_2"]
    ],
)
def task_plot_locations(model, depends_on, produces):
    # model = json.load(depends_on[1].read_text(encoding="utf-8"))

    # Load locations after each round
    with open(depends_on[0], "rb") as in_file:
        locations_by_round = pickle.load(in_file)

    plot_locations(locations_by_round, produces)
