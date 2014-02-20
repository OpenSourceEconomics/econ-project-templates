'

The file "table2_first_stage_est.r" creates table 2 with the first 
stage estimates taking as input the regression results and p-values 
from the corresponding do-file in the analysis folder "first_stage_estimates.do"  
It writes the results to Latex file {PATH_OUT_TABLES}/table2_first_stage_est.tex 

'


source("src/library/R/project_paths.r")

library(xtable, lib=PATH_OUT_LIBRARY_R)

source(paste(PATH_IN_MODEL_CODE,"/","functions.r",sep=""))

mat=dget(file = paste(PATH_OUT_ANALYSIS,"/","first_stage_estimation.txt",sep=""))

panel_name = list(
                   orig_data = "orig_data",re_conj_mor = "re_conj_mor", 
                   orig_data_con = "orig_data_con", re_conj_mor_con = "re_conj_mor_con", 
                   new_data_re_conj_mor_con = "new_data_re_conj_mor_con"
                  )

mat_num = list()

##round the data and put brackets around specific values
for (i in panel_name){
                      num = as.numeric(mat[[i]])
                      mat_num[[i]] = round(num,2)
}

for (i in panel_name){
                      if ( i == "re_conj_mor"){
                                               mat_num[[i]] = replace(
                                                                      mat_num[[i]], c(2,6,10,14,18,22,26), 
                                                                      c(
                                                                        bracket(mat_num[[i]][2]),bracket(mat_num[[i]][6]),
                                                                        bracket(mat_num[[i]][10]),bracket(mat_num[[i]][14]),
                                                                        bracket(mat_num[[i]][18]),bracket(mat_num[[i]][22]),
                                                                        bracket(mat_num[[i]][26])
                                                                      )
                                                              )
                                               mat_num[[i]] = replace(mat_num[[i]], c(4,12), "-")
                      } else {
                              if ( i == "orig_data"){
                                                     mat_num[[i]] = replace(
                                                                            mat_num[[i]], c(3,8,13,18,23,28,33), 
                                                                            c(
                                                                              bracket(mat_num[[i]][3]),bracket(mat_num[[i]][8]),
                                                                              bracket(mat_num[[i]][13]),bracket(mat_num[[i]][18]),
                                                                              bracket(mat_num[[i]][23]),bracket(mat_num[[i]][28]),
                                                                              bracket(mat_num[[i]][33])
                                                                              )
                                                                    )
                                                     mat_num[[i]] = replace(
                                                                            mat_num[[i]], c(2,7,12,17,22,27,32), 
                                                                            c(
                                                                              bracket_cur(mat_num[[i]][2]),
                                                                              bracket_cur(mat_num[[i]][7]),
                                                                              bracket_cur(mat_num[[i]][12]),
                                                                              bracket_cur(mat_num[[i]][17]),
                                                                              bracket_cur(mat_num[[i]][22]),
                                                                              bracket_cur(mat_num[[i]][27]),
                                                                              bracket_cur(mat_num[[i]][32])
                                                                              )
                                                                    )
                                                     mat_num[[i]] = replace(mat_num[[i]], c(5,15), "-")
                            }else{
                                  mat_num[[i]] = replace(
                                                         mat_num[[i]], c(2,7,12,17,22,27,32), 
                                                         c(
                                                           bracket(mat_num[[i]][2]),bracket(mat_num[[i]][7]),
                                                           bracket(mat_num[[i]][12]),bracket(mat_num[[i]][17]),
                                                           bracket(mat_num[[i]][22]),bracket(mat_num[[i]][27]),
                                                           bracket(mat_num[[i]][32])
                                                           )
                                                )
                                  mat_num[[i]] = replace(mat_num[[i]], c(5,15), "-")
                            }
                        }
}

##write anything into a latex table with row names and a header
row_names = list()

row_names[["orig_data"]] = c(
                             "Log mortality($\\beta$) ", 
                             "~~ \\{homoscedastic standard errors\\}",
                             "~~ (heteroscedastic-clustered SE)",
                             "p-value of log mortality", 
                             "p-value of controls"
                           )

row_names[["re_conj_mor"]] = c(
                               "Log mortality($\\beta$) ",
                               "~~ (heteroscedastic standard errors)",
                               "p-value of log mortality",
                               "p-value of controls"
                              )

row_names[["orig_data_con"]] = c(
                                 "Log mortality($\\beta$) ",
                                 "~~ (heteroscedastic-clustered SE)", 
                                 "p-value of log mortality", 
                                 "p-value of indicators", 
                                 "p-value of controls"
                                )

row_names[["re_conj_mor_con"]] = c(
                                   "Log mortality($\\beta$)", 
                                   "~~ (heteroscedastic standard errors)",
                                   "p-value of log mortality",
                                   "p-value of indicators", 
                                   "p-value of controls"
                                  )

row_names[["new_data_re_conj_mor_con"]] = c(
                                             "Log mortality($\\beta$)", 
                                             "~~ (heteroscedastic standard errors)", 
                                             "p-value of log mortality", 
                                             "p-value of indicators",
                                             "p-value of controls"
                                           )

panel_header = list()

panel_header[["orig_data"]] =  matrix(
                                      c(
                                        "\\multicolumn{8}{l}{\\textit{Panel A. Original data 
                                        (64 countries, 36 mortality rates)}} \\\\ %"
                                        ,"","","","","","",""
                                      ),
                                      c(1,8),byrow=TRUE
                                )

panel_header[["re_conj_mor"]] = matrix(
                                       c(
                                         "","","","","","","","",
                                         "\\multicolumn{8}{l}{\\textit{Panel B. Removing conjectured 
                                         mortality rates(28 countries and mortality rates)}} \\\\ %"
                                         ,"","","","","","",""
                                        ),
                                       c(2,8),byrow=TRUE
                                )
 
panel_header[["orig_data_con"]]=  matrix(
                                         c(
                                           "","","","","","","","",
                                           "\\multicolumn{8}{l}{\\textit{Panel C. Original data, adding campaign 
                                           and laborer indicators (64 countries, 36 mortality rates)}} \\\\ %"
                                           ,"","","","","","",""
                                         ),
                                         c(2,8),byrow=TRUE
                                  )
 
panel_header[["re_conj_mor_con"]] =  matrix(
                                            c(
                                              "","","","","","","","",
                                              "\\multicolumn{8}{l}{\\textit{Panel D. Removing conjectured mortality 
                                              and adding campaign and laborer indicators}} \\\\ %"
                                              ,"","","","","","","","(28 countries and mortality rates)"
                                              ,"","","","","","",""
                                            ),
                                            c(3,8),byrow=TRUE
                                      )

panel_header[["new_data_re_conj_mor_con"]] =  matrix(
                                                     c(
                                                       "","","","","","","","",
                                                       "\\multicolumn{8}{l}{\\textit{Panel E. Removing conjectured rates,
                                                       adding campaign and laborer indicators, and revising with 
                                                       new data}} \\\\ %",
                                                       "","","","","","","","(34 countries and rates)",
                                                       "","","","","","",""
                                                      ),
                                                     c(3,8), byrow=TRUE
                                              ) 

tex_table = list ()

for ( i in panel_name){
                       if ( i == "re_conj_mor"){
                                                ma = matrix(
                                                             c(row_names[[i]], mat_num[[i]]), c(4,8)
                                                     )
                       }else{
                             ma = matrix(
                                         c(row_names[[i]], mat_num[[i]]), c(5,8)
                                  )
                       }
                       tex_table[[i]] = rbind(panel_header[[i]], ma)
}

tex_table = do.call(rbind,tex_table)

tex_table_head <- list()

tex_table_head[[1]] = c("", "","","","Control variables", "\\hline")

tex_table_head[[2]] = c("", "","No", "controls","(1)","")

tex_table_head[[3]] = c("","","Latitude","control","(2)","")

tex_table_head[[4]] = c("","Without","Neo-","Europes","(3)","")

tex_table_head[[5]] = c("","","Continent","indicators","(4)","")

tex_table_head[[6]] = c("Continent","indicators","and","latitude","(5)","")

tex_table_head[[7]] = c("","Percent","European","in 1975","(6)","")

tex_table_head[[8]] = c("","","Malaria","in 1994","(7)","")

tex_table_head = do.call(cbind,tex_table_head)

tex_table_final = rbind(tex_table_head, tex_table)

tex_table_final[11,2] = sprintf("%.3f",
					   as.numeric(
							  mat[["orig_data"]][,"reg_no"][4]
					   )
				  )
tex_table_final[18,6] = sprintf("%.3f",
					   as.numeric(
							  mat[["re_conj_mor"]][,"reg_conti_lat"][4]
					   )
				  )
tex_table_final[32,2] = sprintf("%.3f",
					   as.numeric(
							  mat[["re_conj_mor_con"]][,"reg_no"][4]
					   )
				  )
tex_table_final[40,2] = sprintf("%.4f",
					   as.numeric(
							  mat[["new_data_re_conj_mor_con"]][,"reg_no"][4]
					   )
				  )

tex_table_final = xtable(
                         tex_table_final, 
                         caption="First-Stage Estimates \\\\ 
				(Dependent variable: expropiation risk)"              
                  )


align(tex_table_final) = "llccccccc"

##export the latex table
print(
       tex_table_final, sanitize.text.function = function(x){x}, 
       file=paste(PATH_OUT_TABLES,"/","table2_first_stage_est.tex",sep=""),
       include.rownames=FALSE, include.colnames=FALSE,
       caption.placement="top", size ="\\footnotesize" 
)
