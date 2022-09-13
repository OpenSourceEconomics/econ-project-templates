fit_logit_model = function(data, data_info, model_type) {
    outcome_name = data_info[["outcome"]]    
    outcome_name_numerical = data_info[["outcome_numerical"]]
    feature_names = setdiff(colnames(data), c(outcome_name, outcome_name_numerical))
    
    if (model_type == "linear") {
        formula = paste(outcome_name_numerical, "~", paste(feature_names, collapse="+"))
        formula = as.formula(formula)
    } else {
        message = "Only 'linear' model_type is supported right now."
        stop(message)
    }
    
    model = glm(formula, family="binomial", data=data, model=FALSE, y=FALSE)
    return(model)
}


load_model = function(path) {
    model = load(path)
    return(model)
}
