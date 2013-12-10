import json
import pickle
import sys
import numpy as np
import matplotlib.pyplot as plt

from bld.src.library.project_paths import project_paths_join as ppj

PLOT_ARGS = {'markersize': 4, 'alpha': 0.6}


def plot_locations(locations_by_round, model_name):
    "Plot the distribution of agents after cycle_num rounds of the loop."
    n_cycles = len(locations_by_round)
    fig, axes = plt.subplots(nrows=int(np.ceil(n_cycles / 2 - 0.01)), ncols=2)
    fig.subplots_adjust(wspace=0.25, hspace=0.5)
    for item, ax in np.ndenumerate(axes):
        n_cycle = item[0] * 2 + item[1]
        if n_cycle == n_cycles:
            # Remove last element if number of cycles is uneven
            fig.delaxes(ax)
            break
        locs = locations_by_round[n_cycle]
        ax.set_title('Cycle {}'.format(n_cycle))
        ax.set_axis_bgcolor('azure')
        ax.plot(locs[0][:, 0], locs[0][:, 1], 'o', markerfacecolor='orange', **PLOT_ARGS)
        ax.plot(locs[1][:, 0], locs[1][:, 1], 'o', markerfacecolor='green', **PLOT_ARGS)

    fig.savefig(ppj('OUT_FIGURES', 'schelling_{}.png'.format(model_name)))


if __name__ == "__main__":
    model_name = sys.argv[1]
    model = json.load(open(ppj("IN_MODELS", model_name + ".json"), encoding="utf-8"))

    # Load locations after each round
    with open(ppj("OUT_ANALYSIS", "schelling_{}.pickle".format(model_name)), "rb") as in_file:
        locations_by_round = pickle.load(in_file)

    plot_locations(locations_by_round, model_name)
