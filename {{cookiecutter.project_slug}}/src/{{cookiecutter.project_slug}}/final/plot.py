import numpy as np
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from {{cookiecutter.project_slug}}.data_management import convert_outcome_to_numerical


def plot_regression_over_age(data, data_info, predictions, group):
    """Plot regression results over age grid.
    
    Args:
        data (pandas.DataFrame): The data set.
        data_info (dict): Information on data set. Contains keys
            - 'dependent_variable': Name of dependent variable column in data
            - 'columns_to_drop': Names of columns that are dropped in data cleaning step
            - 'categorical_columns': Names of columns that are converted to categorical
            - 'column_rename_mapping': Rename mapping
            - 'url': URL to data set
        predictions (pandas.DataFrame): Model predictions for different age values.
        group (str): Categorical col in data. For each category we have one prediction
            column in data frame predictions.
    
    Returns:
        plotly.graph_objects.Figure: The figure.
    
    """
    plot_data = predictions.melt(
        id_vars="age",
        value_vars=predictions.columns,
        value_name="prediction",
        var_name=group,
    )

    outcomes = convert_outcome_to_numerical(data[data_info["dependent_variable"]])

    fig = px.line(
        plot_data,
        x="age",
        y="prediction",
        color=group,
        labels={"age": "Age", "predictions": "Probability of Smoking"}
    )

    fig.add_traces(
        go.Scatter(
            x=data["age"],
            y=outcomes,
            mode="markers",
            marker_color="black",
            marker_opacity=0.1,
            name="Data",
        )
    )
    return fig
