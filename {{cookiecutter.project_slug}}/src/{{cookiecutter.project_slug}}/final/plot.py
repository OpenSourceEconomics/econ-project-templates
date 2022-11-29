import plotly.express as px
import plotly.graph_objects as go


def plot_regression_by_age(data, data_info, predictions, group):
    """Plot regression results by age.

    Args:
        data (pandas.DataFrame): The data set.
        data_info (dict): Information on data set stored in data_info.yaml. The
            following keys can be accessed:
            - 'outcome': Name of dependent variable column in data
            - 'outcome_numerical': Name to be given to the numerical version of outcome
            - 'columns_to_drop': Names of columns that are dropped in data cleaning step
            - 'categorical_columns': Names of columns that are converted to categorical
            - 'column_rename_mapping': Old and new names of columns to be renamend,
                stored in a dictionary with design: {'old_name': 'new_name'}
            - 'url': URL to data set
        predictions (pandas.DataFrame): Model predictions for different age values.
        group (str): Categorical column in data set. We create predictions for each
            unique value in column data[group]. Cannot be 'age' or 'smoke'.

    Returns:
        plotly.graph_objects.Figure: The figure.

    """
    plot_data = predictions.melt(
        id_vars="age",
        value_vars=predictions.columns,
        value_name="prediction",
        var_name=group,
    )

    outcomes = data[data_info["outcome_numerical"]]

    fig = px.line(
        plot_data,
        x="age",
        y="prediction",
        color=group,
        labels={"age": "Age", "prediction": "Probability of Smoking"},
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
