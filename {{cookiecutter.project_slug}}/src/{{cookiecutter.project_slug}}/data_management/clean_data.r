clean_data = function(data, data_info) {
  data[data_info[["columns_to_drop"]]] = NULL
  data = na.omit(data)
  for (cat_col in data_info[["categorical_columns"]]) {
    data[[cat_col]] = as.factor(data[[cat_col]])
  }
  data = plyr::rename(data, data_info[["column_rename_mapping"]])
  
  numerical_outcome = ifelse(data[[data_info[["outcome"]]]] == "Yes", 1, 0)
  data[data_info[["outcome_numerical"]]] = numerical_outcome

  return(data)
}