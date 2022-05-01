library(dplyr)
library(yaml)

data = read.csv("{{cookiecutter.project_slug}}/bld/data/data_clean_r.csv") # this will later on be a dependency for pytask

data_info = yaml.load_file("src/{{cookiecutter.project_slug}}/data_management/data_info.yaml")

data$X <- NULL # need to fix this so there is no X column
outcome_name = data_info$outcome
outcome_name_numerical = data_info$outcome_numerical

feature_names = names(data[names(data) !=c(outcome_name, outcome_name_numerical)])
formula = as.formula(paste(outcome_name_numerical, paste(feature_names, collapse=" + "), sep=" ~ "))

model <- glm(formula,family=binomial,data=data)
summary(model) #return model

#In R, there is no pickle. For saving data to the disk, an option might be saveRDS
saveRDS(model, "model.rds")