"""Draw simulated samples from two uncorrelated uniform variables
(locations in two dimensions) for two types of agents and store
them in a 3-dimensional NumPy array.

*Note:* In principle, one would read the number of dimensions etc.
from the "IN_MODEL_SPECS" file, this is to demonstrate the most basic
use of *run_py_script* only.

"""
import numpy as np
import pytask

from src.config import BLD


np.random.seed(12345)

n_types = 2
n_draws = 30000


def draw_sample():
    shape = (2, n_types, n_draws)
    s = np.random.uniform(size=np.product(shape))
    return s.reshape(shape)


def save_data(sample, path):
    sample.tofile(path, sep=",")


@pytask.mark.produces(BLD / "data" / "initial_locations.csv")
def task_get_simulation_draws(produces):
    sample = draw_sample()
    save_data(sample, produces)
