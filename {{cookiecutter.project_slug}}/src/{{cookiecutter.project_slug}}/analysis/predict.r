library(dplyr)
library(yaml)

data = read.csv("{{cookiecutter.project_slug}}/bld/data/data_clean_r.csv") # this will later on be a dependency for pytask

data_info = yaml.load_file("src/{{cookiecutter.project_slug}}/data_management/data_info.yaml")


data$X <- NULL # need to fix this so there is no X column

age_min = min(data$age)
age_max = max(data$age)

age_grid = seq(age_min, age_max+1)

#this code replicates de mode built-in function in python

modefunc<-function(x){which.max(tabulate(x))} #R gives us the value not the level


columns = names(data)
mode = data.frame(matrix(ncol = 6, nrow = 1))
colnames(mode) = columns
for (v in columns){
  mode[[v]] = modefunc(data[[v]])
}

new_data = data.frame(age = age_grid, 
                      smoke_numerical = mode$smoke_numerical,
                      marital_status = mode$marital_status,
                      qualification = mode$qualification
                      )