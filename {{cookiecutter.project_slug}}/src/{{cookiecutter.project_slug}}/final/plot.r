plot_regression_by_age = function(data, data_info, predictions, group) {
  plot_data = reshape2::melt(predictions, id="age", value.name="prediction", variable.name=group)

  outcomes = data[data_info[["outcome_numerical"]]]

  marker_data = data.frame(age=data[["age"]], outcome=outcomes)
  colnames(marker_data) = c("age", "outcome")

  group <- parse(text=group)

  fig = plotly::plot_ly()
  fig = plotly::add_lines(fig, data=plot_data, x=~age, y=~prediction, color=~eval(group))
  fig = plotly::add_markers(fig, data=marker_data, x=~age, y=~outcome, marker=list(color="black", opacity=0.1), name="Data")
  fig = plotly::layout(fig, yaxis=list(title="Probability of Smoking"), xaxis=list(title="Age"))

  return(fig)
}
