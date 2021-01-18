"""Run a Schelling (1969, :cite:`Schelling69`) segregation
model and store a list with locations by type at each cycle.

The scripts expects that a model name is passed as an
argument. The model name must correspond to a file called
``[model_name].json`` in the "IN_MODEL_SPECS" directory.

"""
import json
import pickle

import numpy as np
import pytask

from src.config import BLD
from src.config import SRC
from src.model_code.agent import Agent


def setup_agents(model, initial_locations):
    """Load the simulated initial locations and return a list
    that holds all agents.

    """
    initial_locations = initial_locations.reshape(2, model["n_types"], 30000)

    agents = []
    for typ in range(model["n_types"]):
        for i in range(model["n_agents_by_type"][typ]):
            agents.append(
                Agent(
                    typ=typ,
                    initial_location=initial_locations[typ, :, i],
                    n_neighbours=model["n_neighbours"],
                    require_same_type=model["require_same_type"],
                    max_moves=model["max_moves"],
                )
            )

    return agents


def _get_locations_by_round_dict(model):
    """Return a dictionary with arrays to store locations for each type."""
    return {
        typ: np.zeros((model["n_agents_by_type"][typ], 2)) * np.nan
        for typ in range(model["n_types"])
    }


def _store_locations_by_round(loc, agents):
    """Update the dictionary *loc* with the locations of each agent.

    Doing so is a bit tedious because we do so by type.

    """
    counter = {0: 0, 1: 0}
    for agent in agents:
        typ = agent.type
        loc[typ][counter[typ], :] = agent.location
        counter[typ] += 1


def run_analysis(agents, model):
    """Given an initial set of *agents* and the *model*'s parameters,
    return a list of dictionaries with *type: N x 2* items.

    """
    locations_by_round = [_get_locations_by_round_dict(model)]
    _store_locations_by_round(locations_by_round[-1], agents)

    for _ in range(model["max_iterations"]):
        # Make room for locations.
        locations_by_round.append(_get_locations_by_round_dict(model))
        # Update locations as necessary
        someone_moved = False
        for agent in agents:
            old_location = agent.location
            # If necessary, move around until happy
            agent.move_until_happy(agents)
            if not (agent.location == old_location).all():
                someone_moved = True
        _store_locations_by_round(locations_by_round[-1], agents)
        # We are done if everybody is happy.
        if not someone_moved:
            break

    if someone_moved:
        print(
            "No convergence achieved after {} iterations".format(
                model["max_iterations"]
            )
        )

    return locations_by_round


@pytask.mark.parametrize(
    "depends_on, produces",
    [
        (
            {
                "model": SRC / "model_specs" / f"{model_name}.json",
                "agent": SRC / "model_code" / "agent.py",
                "data": BLD / "data" / "initial_locations.csv",
            },
            BLD / "analysis" / f"schelling_{model_name}.pickle",
        )
        for model_name in ["baseline", "max_moves_2"]
    ],
)
def task_schelling(depends_on, produces):
    model = json.loads(depends_on["model"].read_text(encoding="utf-8"))

    np.random.seed(model["rng_seed"])

    # Load initial locations and setup agents
    initial_locations = np.loadtxt(depends_on["data"], delimiter=",")
    agents = setup_agents(model, initial_locations)
    # Run the main analysis
    locations_by_round = run_analysis(agents, model)
    # Store list with locations after each round
    with open(produces, "wb") as out_file:
        pickle.dump(locations_by_round, out_file)
