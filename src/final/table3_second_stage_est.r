'
 
The file "table3_second_stage_est.r" creates table 3 with the 
IV estimates taking as input the regression results and confidence 
intervals from the corresponding do-file "second_stage_estimates.r" 
in the analysis directory. It writes the results to Latex file 
{PATH_OUT_TABLES}/table3_second_stage_est.tex 

'


source("src/library/R/project_paths.r")

library(xtable, lib=PATH_OUT_LIBRARY_R)

source(paste(PATH_IN_MODEL_CODE,"/","functions.r",sep=""))

##import the data list 
mat = dget(file = paste(PATH_OUT_ANALYSIS,"/","second_stage_estimation.pickle",sep=""))

panel_name = list(
                   orig_data = "orig_data",re_conj_mor = "re_conj_mor", 
                   orig_data_con = "orig_data_con", re_conj_mor_con = "re_conj_mor_con", 
                   new_data_re_conj_mor_con = "new_data_re_conj_mor_con"
                  )


mat_num = list()

##round the data and put brackets around specific values
for (i in panel_name){
                      mat_num[[i]] = mat[[i]]    
                      num = as.numeric(
                                       mat[[i]][1,]
                            )
                      mat_num[[i]][1,] = round(num,2)
}

##write anything into a latex table with row names and a header
row_names = list()

row_names[["orig_data"]] = c(
                             "Expropriation risk $(\\alpha)$ ", 
                             "Wald 95\\% conf.",
                             "region",
                             'AR \\textquotedblleft 95\\%\\textquotedblright conf.', 
                             "region",
                             ""
                           )

row_names[["re_conj_mor"]] = c(
                               "Expropriation risk $(\\alpha)$ ", 
                               "Wald 95\\% conf.",
                               "region",
                               'AR \\textquotedblleft 95\\%\\textquotedblright conf.', 
                               "region",
                               ""
                              )

row_names[["orig_data_con"]] = c(
                                 "Expropriation risk $(\\alpha)$ ", 
                                 "Wald 95\\% conf.",
                                 "region",
                                 'AR \\textquotedblleft 95\\%\\textquotedblright conf.', 
                                 "region",
                                 ""
                                )

row_names[["re_conj_mor_con"]] = c(
                                   "Expropriation risk $(\\alpha)$ ", 
                                   "Wald 95\\% conf.",
                                   "region",
                                   'AR \\textquotedblleft 95\\%\\textquotedblright conf.', 
                                   "region",
                                   ""
                                  )

row_names[["new_data_re_conj_mor_con"]] = c(
                                            "Expropriation risk $(\\alpha)$ ", 
                                            "Wald 95\\% conf.",
                                            "region",
                                            'AR \\textquotedblleft 95\\%\\textquotedblright conf.', 
                                            "region",
                                            ""
                                           )


panel_header = list()

panel_header[["orig_data"]] = c(
                                "\\multicolumn{8}{l}{\\textit{Panel A. Original data 
                                (64 countries, 36 mortality rates)}} \\\\ %"
                                ,"","","","","","",""
                              )
                                     

panel_header[["re_conj_mor"]] = c(
                                  "\\multicolumn{8}{l}{\\textit{Panel B. Removing conjectured 
                                  mortality rates(28 countries and mortality rates)}} \\\\ %"
                                  ,"","","","","","",""
                                )
                                 
 
panel_header[["orig_data_con"]] = c(
                                    "\\multicolumn{8}{l}{\\textit{Panel C. Original data, adding campaign 
                                    and laborer indicators (64 countries, 36 mortality rates)}} \\\\ %"
                                    ,"","","","","","",""
                                  )
                                  
 
panel_header[["re_conj_mor_con"]] = c(
                                      "\\multicolumn{8}{l}{\\textit{Panel D. Removing conjectured mortality 
                                      and adding campaign and laborer indicators
                                      (28 countries and mortality rates)}} \\\\ %"
                                      ,"","","","","","",""
                                    )
                                       

panel_header[["new_data_re_conj_mor_con"]] = c(
                                               "\\multicolumn{8}{l}{\\textit{Panel E. Removing conjectured rates,
                                               adding campaign and laborer indicators, and revising with 
                                               new data(34 countries and rates)}} \\\\ %",
                                               "","","","","","",""
                                             )
                                           
tex_table = list ()

for ( i in panel_name){
                       ma = matrix(
                                   c(
                                     row_names[[i]], mat_num[[i]]
                                   ), c(6,8)
                              )
                       
                       tex_table[[i]] = rbind(panel_header[[i]], ma)
}

tex_table = do.call(rbind,tex_table)

## skip the last line
tex_table = tex_table[1:34,]

tex_table_head <- list()

tex_table_head[[1]] = c("","","","Control variables", "\\hline")

tex_table_head[[2]] = c("","", "No controls","(1)","")

tex_table_head[[3]] = c("","","Latitude control","(2)","")

tex_table_head[[4]] = c("","Without","neo-Europes","(3)","")

tex_table_head[[5]] = c("","Continent","indicators","(4)","")

tex_table_head[[6]] = c("Continent","indicators \\&","latitude","(5)","")

tex_table_head[[7]] = c("Percent","European in","1975","(6)","")

tex_table_head[[8]] = c("","Malaria in","1994","(7)","")

tex_table_head = do.call(cbind,tex_table_head)

tex_table_final = rbind(tex_table_head, tex_table)

##export the latex table

tex_table_final = xtable(
                         tex_table_final, 
                         caption = paste(
                                         "\\footnotesize", "Instrumental Variables Estimates And Confidence Regions}",  
                                         "{","(\\footnotesize First-stage dependent variable: expropriation risk;", 
                                         "second-stage dependent variable,\\\\}",
                                         "{\\footnotesize log GDP per capita, 1995, PPP basis",")")              
                  )

align(tex_table_final) = "llccccccc"

##export the latex table
print(
       tex_table_final, sanitize.text.function = function(x){x}, 
       file=paste(PATH_OUT_TABLES,"/","table3_second_stage_est.tex",sep=""),
       include.rownames=FALSE, include.colnames=FALSE,
       caption.placement="top", size ="\\tiny \\setlength{\\tabcolsep}{0.25em}" 
)
