import numpy as np
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go


def plot_regression_over_age(data, data_info, predictions, group):

    age_min = data["age"].min()
    age_max = data["age"].max()
    age_grid = np.arange(age_min, age_max + 1)

    plot_data = predictions.copy()
    plot_data["age"] = age_grid
    plot_data = plot_data.melt(
        id_vars="age",
        value_vars=predictions.columns,
        value_name="prediction",
        var_name=group,
    )

    raw_outcomes = pd.Categorical(data[data_info["dependent_variable"]]).codes

    fig = px.line(plot_data, x="age", y="prediction", color=group, labels={"age": "Age", "predictions": "Probability of Smoking"})

    fig.add_traces(
        go.Scatter(
            x=data["age"],
            y=raw_outcomes,
            mode="markers",
            marker_color="black",
            marker_opacity=0.1,
            name="Raw Data",
        )
    )
    return fig
