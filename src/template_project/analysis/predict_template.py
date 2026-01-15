"""Functions for predicting outcomes based on the estimated model."""

import numpy as np
import pandas as pd
from numpy.typing import NDArray
from statsmodels.discrete.discrete_model import BinaryResultsWrapper


def predict_prob_by_age(
    data: pd.DataFrame,
    model: BinaryResultsWrapper,
    group: str,
) -> pd.DataFrame:
    """Predict smoking probability for varying age values.

    For each group value in column data[group] we create new data that runs through a
    grid of age values from data.age.min() to data.age.max() and fixes all column
    values to the ones returned by data.mode(), except for the group column.

    Args:
        data (pandas.DataFrame): The data set.
        model (statsmodels.base.model.Results): The fitted model.
        group (str): Categorical column in data set. We create predictions for each
            unique value in column data[group]. Cannot be 'age' or 'current_smoker'.

    Returns:
        pandas.DataFrame: Predictions. Has columns 'age' and one column for each
            category in column group.

    """
    age_min: int = data["age"].min()
    age_max: int = data["age"].max()
    age_grid: NDArray[np.int_] = np.arange(age_min, age_max + 1)

    mode = data.mode()

    new_data = pd.DataFrame(age_grid, columns=pd.Index(["age"]))

    cols_to_set = list(set(data.columns) - {group, "age", "current_smoker"})
    new_data = new_data.assign(**dict(mode.loc[0, cols_to_set]))

    result = pd.DataFrame({"age": age_grid})
    for group_value in data[group].unique():
        _new_data = new_data.copy()
        _new_data[group] = group_value
        result[group_value] = model.predict(_new_data)

    return result
