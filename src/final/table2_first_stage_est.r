# The file "table2_first_stage_est.r" creates table 2 with the first 
# stage estimates taking as input the regression results and p-values 
# from the corresponding do-file in the analysis folder "first_stage_estimates.do"  
# It writes the results to Latex file {PATH_OUT_TABLES}/table2_first_stage_est.tex 



source("src/library/R/project_paths.r")

library(rjson, lib=PATH_OUT_LIBRARY_R)
library(xtable, lib=PATH_OUT_LIBRARY_R)

source(paste(PATH_IN_MODEL_CODE, "functions.r", sep="/"))

models = unlist(strsplit(commandArgs(trailingOnly = TRUE), split=" "))

# Initilize table
table <- data.frame((matrix(nrow = 1, ncol = 7)))

# Tools to allow for white space in the table between different panels
count <- 1
empty_str <- ""

for (m in models) {
    
    # Load data from regression output
    this_file = paste(PATH_OUT_ANALYSIS, paste("first_stage_estimation_", m, ".txt", sep = ""), sep="/")
    reg_data <- read.table(
        file = this_file,
        header = TRUE
    )
    reg_data[is.na(reg_data)] <- "-"

    # Load model specs
    model_json <- paste(m, "json", sep=".")
    model <- fromJSON(file=paste(PATH_IN_MODEL_SPECS, model_json, sep="/"))
    
    # Create panel header for table
    panel_header <- data.frame(matrix(nrow=1, ncol=7))
    row.names(panel_header) <- paste("\\multicolumn{8}{l}{\\textit{", model$TITLE, "}} \\\\ %", sep="")
    panel_header[is.na(panel_header)] <- ""

    # Append empty row to table
    empty_row <- data.frame(matrix(nrow=1, ncol=7))
    for (i in 1:count) {empty_str = paste(empty_str, " ", sep="")} # R does not allow duplicate row names
    count = count + 1
    row.names(empty_row) <- empty_str
    empty_row[is.na(empty_row)] <- ""
    table = rbind(table, empty_row)

    # Append panel header to table
    table = rbind(table, panel_header)

    # Append data to table
    table = rbind(table, reg_data)
}

print(table)

# tex_table = list ()

# for ( i in panel_name){
#                        if ( i == "re_conj_mor"){
#                                                 ma = matrix(
#                                                              c(row_names[[i]], mat_num[[i]]), c(4,8)
#                                                      )
#                        }else{
#                              ma = matrix(
#                                          c(row_names[[i]], mat_num[[i]]), c(5,8)
#                                   )
#                        }
#                        tex_table[[i]] = rbind(panel_header[[i]], ma)
# }

# tex_table = do.call(rbind,tex_table)

# tex_table_head <- list()

# tex_table_head[[1]] = c("", "","","","Control variables", "\\hline")

# tex_table_head[[2]] = c("", "","No", "controls","(1)","")

# tex_table_head[[3]] = c("","","Latitude","control","(2)","")

# tex_table_head[[4]] = c("","Without","Neo-","Europes","(3)","")

# tex_table_head[[5]] = c("","","Continent","indicators","(4)","")

# tex_table_head[[6]] = c("Continent","indicators","and","latitude","(5)","")

# tex_table_head[[7]] = c("","Percent","European","in 1975","(6)","")

# tex_table_head[[8]] = c("","","Malaria","in 1994","(7)","")

# tex_table_head = do.call(cbind,tex_table_head)

# tex_table_final = rbind(tex_table_head, tex_table)

# tex_table_final[11,2] = sprintf("%.3f",
# 					   as.numeric(
# 							  mat[["orig_data"]][,"reg_no"][4]
# 					   )
# 				  )
# tex_table_final[18,6] = sprintf("%.3f",
# 					   as.numeric(
# 							  mat[["re_conj_mor"]][,"reg_conti_lat"][4]
# 					   )
# 				  )
# tex_table_final[32,2] = sprintf("%.3f",
# 					   as.numeric(
# 							  mat[["re_conj_mor_con"]][,"reg_no"][4]
# 					   )
# 				  )
# tex_table_final[40,2] = sprintf("%.4f",
# 					   as.numeric(
# 							  mat[["new_data_re_conj_mor_con"]][,"reg_no"][4]
# 					   )
# 				  )

# tex_table_final = xtable(
#                          tex_table_final, 
#                          caption="First-Stage Estimates \\\\ 
# 				(Dependent variable: expropiation risk)"              
#                   )


# align(tex_table_final) = "llccccccc"

# ##export the latex table
# print(
#        tex_table_final, sanitize.text.function = function(x){x}, 
#        file=paste(PATH_OUT_TABLES,"/","table2_first_stage_est.tex",sep=""),
#        include.rownames=FALSE, include.colnames=FALSE,
#        caption.placement="top", size ="\\footnotesize" 
# )
