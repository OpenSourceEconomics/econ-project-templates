import numpy as np
import pandas as pd


def predict_prob_over_age(data, model, group):

    age_min = data["age"].min()
    age_max = data["age"].max()
    age_grid = np.arange(age_min, age_max + 1)

    mode = data.mode()

    new_data = pd.DataFrame(age_grid, columns=["age"])

    cols_to_set = list(set(data.columns) - {group, "age", "smoke"})
    new_data = new_data.assign(**dict(mode.loc[0, cols_to_set]))

    predicted = {"age": age_grid}
    for group_value in data[group].unique():
        _new_data = new_data.copy()
        _new_data[group] = group_value
        predicted[group_value] = model.predict(_new_data)

    predicted = pd.DataFrame(predicted)
    return predicted
