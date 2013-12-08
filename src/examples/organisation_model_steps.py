import matplotlib as mpl

mpl.use("pgf")
pgf_with_pdflatex = {
    "pgf.texsystem": "pdflatex",
    "pgf.preamble": [
        r"\usepackage[utf8x]{inputenc}",
        r"\usepackage[T1]{fontenc}",
        r"\usepackage{cmbright}",
    ]
}
mpl.rcParams.update(pgf_with_pdflatex)

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from collections import OrderedDict
from bld.project_paths import project_paths_join


def path_to(filename):
    return project_paths_join('BLD_EXAMPLES', filename)


EXPORT_TYPE = 'png'
AXIS_MAX = 100
X_LABEL_TEXT = 'Steps to be performed'
Y_LABEL_TEXT = 'Model specification'

STEP_CATEGORIES = ['Data\nmanagement', 'Analysis', 'Final', 'Paper']
MODEL_CATEGORIES = [
    'Replication\nprevious paper',
    'Robustness\ncheck 1',
    'Baseline'
]

X_UNIT = AXIS_MAX / float(len(STEP_CATEGORIES))
X_START_LOC = 7.5
Y_UNIT = (AXIS_MAX - 15) / float(len(MODEL_CATEGORIES))
Y_START_LOC = 7.5 + 20.0 / 3.0

x_ticks = []
y_ticks = []

# Generate ordered dictionaries with different shapes.
step_shapes = {
    'None': OrderedDict(),
    'full': OrderedDict(),
    'full 2': OrderedDict(),
    'part': OrderedDict(),
    'select': OrderedDict()
}
model_shapes = {
    'None': OrderedDict(),
    'full': OrderedDict(),
    'part': OrderedDict()
}


for i, item in enumerate(STEP_CATEGORIES):
    x_loc = i * X_UNIT + X_START_LOC
    y_loc = 7.5
    width = 10
    height = 85
    x_ticks.append(x_loc + width / 2.0)
    for graph_type in list(step_shapes.keys()):
        if graph_type == 'select' or graph_type == 'None':
            step_shapes[graph_type][item] = None
            continue
        elif not graph_type.startswith('full') and (
            item.startswith('Final') or item.startswith('Paper')
        ):
            y_loc = 7.5 + 85 / 3.0
            height = 85 - 85 / 3.0
        else:
            y_loc = 7.5
            height = 85
        step_shapes[graph_type][item] = mpatches.FancyBboxPatch(
            (x_loc, y_loc), width, height,
            boxstyle=mpatches.BoxStyle("Round",
                                       pad=2.5),
            facecolor='DarkSeaGreen',
            edgecolor='none',
            alpha=.75)

# Add stuff 'manually' to select graph.
step_shapes['select']['single boxes'] = []
for x_count in range(len(STEP_CATEGORIES)):
    x_loc = x_count * X_UNIT + X_START_LOC
    for y_count in range(len(MODEL_CATEGORIES)):
        if x_count > 1 and (y_count == 0 or y_count == 2):
            continue
        y_loc = y_count * Y_UNIT + Y_START_LOC
        if x_count <= 1:
            height = 15
        else:
            height = 2 * (15 + 20.0 / 3.0)

        step_shapes['select']['single boxes'].append(
            mpatches.FancyBboxPatch(
                (x_loc, y_loc),
                10,
                height,
                boxstyle=mpatches.BoxStyle("Round", pad=2.5),
                facecolor='DarkRed',
                edgecolor='none',
                alpha=.75
            )
        )

for i, item in enumerate(MODEL_CATEGORIES):
    x_loc = 7.5
    y_loc = i * Y_UNIT + Y_START_LOC
    width = 85
    height = 15
    y_ticks.append(y_loc + height / 2.0)
    for graph_type in list(model_shapes.keys()):
        if graph_type == 'None':
            model_shapes[graph_type][item] = None
        elif graph_type == 'full' or (item.startswith('Baseline') or item.startswith('Robust')):
            model_shapes[graph_type][item] = mpatches.FancyBboxPatch(
                (x_loc, y_loc),
                width,
                height,
                boxstyle=mpatches.BoxStyle("Round", pad=2.5),
                facecolor='DarkBlue',
                edgecolor='none',
                alpha=.5
            )
        else:
            width = 35
            model_shapes[graph_type][item] = mpatches.FancyBboxPatch(
                (x_loc, y_loc),
                width,
                height,
                boxstyle=mpatches.BoxStyle("Round", pad=2.5),
                facecolor='DarkBlue',
                edgecolor='none',
                alpha=.5
            )


def create_fig(out_file, x_items, y_items):

    # Create the figure.
    plt.figure(figsize=(7.5, 5))
    ax = plt.subplot(1, 1, 1)

    # Set the size of the plot region.
    plt.axis([0, AXIS_MAX, 0, AXIS_MAX])

    # Remove normal axis behaviour.
    for name, spine in list(ax.spines.items()):
        if name in ['right', 'top']:
            spine.set_color('none')

    # Set axis labels.
    ax.set_xlabel(
        X_LABEL_TEXT,
        rotation='horizontal',
        ha='right',
        position=(1.1, -0.2)
    )
    ax.set_ylabel(
        Y_LABEL_TEXT,
        rotation='horizontal',
        ha='left',
        position=(-.3, 1.1)
    )
    ax.tick_params(color='white')

    ax.xaxis.set_ticks(x_ticks)
    ax.set_xticklabels(list(x_items.keys()))

    ax.yaxis.set_ticks(y_ticks)
    ax.set_yticklabels(
        list(y_items.keys()),
        horizontalalignment='left',
        position=(-0.225, 0)
    )

    for k, v in list(x_items.items()):
        if v and k != 'single boxes':
            ax.add_patch(v)

    for k, v in list(y_items.items()):
        if v:
            ax.add_patch(v)

    if 'single boxes' in list(x_items.keys()):
        for box in x_items['single boxes']:
            ax.add_patch(box)

    plt.subplots_adjust(left=.25, bottom=.2)

    plt.draw()
    plt.savefig('{}.{}'.format(out_file, EXPORT_TYPE))


create_fig(
    path_to('steps_only_full'),
    x_items=step_shapes['full'],
    y_items=model_shapes['None']
)
create_fig(
    path_to('model_steps_full'),
    x_items=step_shapes['None'],
    y_items=model_shapes['full']
)
create_fig(
    path_to('model_steps_part'),
    x_items=step_shapes['part'],
    y_items=model_shapes['part']
)
create_fig(
    path_to('model_steps_select'),
    x_items=step_shapes['select'],
    y_items=model_shapes['None']
)
