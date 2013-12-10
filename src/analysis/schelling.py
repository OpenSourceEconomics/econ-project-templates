"""Store a list of locations at each round.

"""


import sys
import json
import logging
import pickle
import numpy as np

from src.library.agent import Agent
from bld.src.library.project_paths import project_paths_join as ppj


def setup_agents(model):
    initial_locations = np.load(ppj("OUT_DATA", "sample.npy"))

    agents = []
    for typ in range(model["n_types"]):
        for i in range(model["n_agents_by_type"][typ]):
            agents.append(
                Agent(
                    typ=typ,
                    initial_location=initial_locations[typ, :, i],
                    n_neighbours=model["n_neighbours"],
                    require_same_type=model["require_same_type"]
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
    locations_by_round = [_get_locations_by_round_dict(model)]
    _store_locations_by_round(locations_by_round[-1], agents)

    for loop_counter in range(model["max_iterations"]):
        logging.info("Entering loop {}".format(loop_counter))
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
        logging.info("No convergence achieved after {} iterations".format(model["max_iterations"]))

    return locations_by_round


if __name__ == "__main__":
    model_name = sys.argv[1]
    model = json.load(open(ppj("IN_MODELS", model_name + ".json"), encoding="utf-8"))

    logging.basicConfig(
        filename=ppj("OUT_ANALYSIS", "log", "schelling_{}.log".format(model_name)),
        filemode="w",
        level=logging.INFO
    )
    np.random.seed(model["rng_seed"])
    logging.info(model["rng_seed"])

    # Setup agents and run analysis
    agents = setup_agents(model)
    locations_by_round = run_analysis(agents, model)

    # Store locations after each round
    with open(ppj("OUT_ANALYSIS", "schelling_{}.pickle".format(model_name)), "wb") as out_file:
        pickle.dump(locations_by_round, out_file)
