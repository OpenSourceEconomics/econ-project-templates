"""Draw simulated samples from two uncorrelated uniform variables
(locations in two dimensions) for two types of agents and store
them in a 3-dimensional NumPy array.

*Note:* In principle, one would read the number of dimensions etc.
from the "IN_MODEL_SPECS" file, this is to demonstrate the most basic
use of *run_py_script* only.

"""

import numpy as np
from bld.project_paths import project_paths_join as ppj


np.random.seed(12345)

n_types = 2
n_draws = 30000


def draw_sample():
    shape = (2, n_types, n_draws)
    s = np.random.uniform(size=np.product(shape))
    return s.reshape(shape)


def save_data(sample):
    sample.tofile(ppj("OUT_DATA", "initial_locations.csv"), sep=",")


if __name__ == "__main__":
    sample = draw_sample()
    save_data(sample)
