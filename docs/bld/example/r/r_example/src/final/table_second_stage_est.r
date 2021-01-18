'

The file "table_second_stage_est.r" creates table 3 with the
IV estimates taking as input the regression results and confidence
intervals from the corresponding do-file "second_stage_estimates.r"
in the analysis directory. It writes the results to Latex file
{PATH_OUT_TABLES}/table_second_stage_est.tex

'

args = commandArgs(trailingOnly=TRUE)

library(xtable)
library(rjson)

# Initilize final table
final_table <- data.frame((matrix(nrow = 6, ncol = 8)))

# Write table header
final_table[1] <- c("", "","","","Control variables", "\\midrule")
final_table[2] <- c("", "","No", "controls","(1)","")
final_table[3] <- c("","","Latitude","control","(2)","")
final_table[4] <- c("","Without","Neo-","Europeans","(3)","")
final_table[5] <- c("","","Continent","indicators","(4)","")
final_table[6] <- c("Continent","indicators","and","latitude","(5)","")
final_table[7] <- c("","Percent","European","in 1975","(6)","")
final_table[8] <- c("","","Malaria","in 1994","(7)","")

# Fill final table with first stage regression results
for (i in c(1, 3)) {

    # Load model specs
    model <- fromJSON(file=args[i])

    # Load data from regression results
    reg_results <- read.csv(file=args[i+1], header=TRUE, row.names=1)

    # Create panel header for table
    panel_header <- data.frame(matrix(nrow=2, ncol=8))
    panel_header[2, 1] <- paste("\\multicolumn{8}{l}{\\textit{", model$TITLE, "}} \\\\ %", sep="")
    panel_header[is.na(panel_header)] <- ""

    # Fill data into table
    model_table <- data.frame(matrix(nrow = 5, ncol = 8))
    model_table[1] <- rownames(reg_results)
    model_table[2:8] <- reg_results

    # Append panel header to model_table
    model_table = rbind(panel_header, model_table)

    # Append model_table to final table
    final_table = rbind(final_table, model_table)

}

tex_final_table = xtable(
    final_table,
    caption= paste(
        "\\footnotesize", "Instrumental Variables Estimates And Confidence Regions}",
        "{","(\\footnotesize First-stage dependent variable: expropriation risk;",
        "second-stage dependent variable,\\\\}",
        "{\\footnotesize log GDP per capita, 1995, PPP basis",")"
    )
)

align(tex_final_table) = "llccccccc"

# Export the latex table
print(
    tex_final_table,
    sanitize.text.function = function(x){x},
    file=args[5],
    include.rownames=FALSE,
    include.colnames=FALSE,
    caption.placement="top",
    size ="\\tiny \\setlength{\\tabcolsep}{0.25em}"
)
