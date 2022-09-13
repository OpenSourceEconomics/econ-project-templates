predict_prob_by_age = function(data, model, group) {
  age_min = min(data[["age"]])
  age_max = max(data[["age"]])
  age_grid = seq(age_min, age_max)
  
  mode = .mode(df)
  
  new_data = data.frame(age=age_grid)
  
  cols_to_set = setdiff(colnames(data), c(group, "age", "smoke"))
  new_data = ... # assign mode values to new_data frame
  
  predicted = list(age=age_grid)
  for (group_value in unique(data[[group]])) {
    .new_data = copy(new_data)
    .new_data[[group]] = group_value
    predicted[[group]] = predict(model, .new_data)
  }
  
  predicted = as.data.frame(predicted)
  return(predicted)
}

.mode = function(df) {
  return(NULL)
}
