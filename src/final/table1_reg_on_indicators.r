'
 
The file "table1_reg_on_indicators.r" creates table 1 with the regression
estimates and correlations of the main indicators (mortality, 
expropriation risk and GDP) from the corresponding r-file in 
the analysis directory "regression_on_indicators.r" 

'


source("src/library/R/project_paths.r")

library(xtable, lib=PATH_OUT_LIBRARY_R)

## import vector
mat = dget(
	     paste(PATH_OUT_ANALYSIS,"/","regression_on_indicators.txt",sep="")
      )

## change format and make matrix
mat = sprintf("%.2f",as.numeric(mat))

mat = matrix(mat,c(10,3))

for(i in 1:3){
              mat[3,i] = paste( "(", mat[3,i], ")", sep="")
              mat[5,i] = paste( "(", mat[5,i], ")", sep="")
              mat[1,i] = ""
              mat[7,i] = ""
              mat[8,i] = ""
}

## add header and row names, make latex table
header = matrix( 
                c(
                  "","Log mortality ", "Expropriation risk", "Log GDP",
                  "Dependent variable","(1)", "(2)", "(3)", 
                  "\\hline","","","",
                  "","","",""
                 ), c(4,4), byrow=TRUE
         ) 


row_names = c(
              "Original sample (64 countries)",
              "~~ Campaign indicator", 
              "",
              "~~ Laborer indicator",     
              "",
              "~~ $R^{2}$",
              "", 
              "Correlation with log mortality", 
              "~~ Full", 
              "~~ Partial, controlling for indicators"
            )

tex_table = cbind(row_names, mat)

tex_table_final = rbind(header, tex_table)

tex_table_final = xtable(tex_table_final, caption="Relationship of Main Variables Campaign And Laborer Indicators")


align(tex_table_final) = "llccc"

## export the latex table
print(
       tex_table_final, sanitize.text.function = function(x){x}, 
       file=paste(PATH_OUT_TABLES, "/", "table1_reg_on_indicators.tex", sep=""),
       include.rownames=FALSE, include.colnames=FALSE, caption.placement="top" 
)

