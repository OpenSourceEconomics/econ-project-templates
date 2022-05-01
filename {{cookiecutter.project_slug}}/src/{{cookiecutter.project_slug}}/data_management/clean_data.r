library(dplyr)
library(yaml)
library(jsonlite) 

parent = getwd()
path_to_json = file.path(parent, "src/{{cookiecutter.project_slung}}/.pytask/task_data_management_r_py_task_clean_data.json")

args = read_json(path_to_json)
data_info <- yaml.load_file(args$depends_on)

data = read.csv(url(data_info$url))
data = data[!(names(data) %in% data_info$columns_to_drop)]

for (v in data_info$categorical_columns){
  data[[v]] = factor(data[[v]])
}

data = rename(data, qualification=highest_qualification)

numerical_outcome = ifelse(data$smoke == "Yes", 1, 0)
data[data_info$outcome_numerical] = numerical_outcome

#save data to disk
write.csv(data, file = args$produces, col.names = TRUE)