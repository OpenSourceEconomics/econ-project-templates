"""Functions plotting results."""

import plotly.express as px
import plotly.graph_objects as go


def plot_regression_by_age(data, predictions, group):
    """Plot regression results by age.

    Args:
        data (pandas.DataFrame): The data set.
        predictions (pandas.DataFrame): Model predictions for different age values.
        group (str): Categorical column in data set. We create predictions for each
            unique value in column data[group]. Cannot be 'age' or 'current_smoker'.

    Returns:
        plotly.graph_objects.Figure: The figure.

    """
    plot_data = predictions.melt(
        id_vars="age",
        value_vars=predictions.columns,
        value_name="prediction",
        var_name=group,
    )

    fig = px.line(
        plot_data,
        x="age",
        y="prediction",
        color=group,
        labels={"age": "Age", "prediction": "Probability of Smoking"},
        category_orders={group: data[group].cat.categories},
    )

    fig.add_traces(
        go.Scatter(
            x=data["age"],
            y=data["current_smoker_numerical"],
            mode="markers",
            marker_color="black",
            marker_opacity=0.1,
            name="Data",
        ),
    )
    return fig
