"""Draw simulated samples from two uncorrelated uniform variables
(locations in two dimensions) for two types of agents and store
them in a 3-dimensional NumPy array.

*Note:* In principle, one would read the number of dimensions etc.
from the 'IN_MODELS' file, this is to demonstrate the most basic
use of *run_py_script* only.

"""

import numpy as np
from bld.src.library.project_paths import project_paths_join as ppj


np.random.seed(12345)

n_dims = 2
n_types = 2
n_draws = 30000


def draw_sample():
    shape = (n_dims, n_types, n_draws)
    s = np.random.uniform(size=np.product(shape))
    return s.reshape(shape)


def save_data(sample):
    np.save(ppj('OUT_DATA', 'sample.npy'), sample)


if __name__ == '__main__':
    sample = draw_sample()
    save_data(sample)
