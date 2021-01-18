'

The file "table_first_stage_est.r" creates table 2 with the first
stage estimates taking as input the regression results and p-values
from the corresponding do-file in the analysis folder "first_stage_estimates.do"
It writes the results to Latex file {PATH_OUT_TABLES}/table_first_stage_est.tex

'


args = commandArgs(trailingOnly=TRUE)

library(xtable)
library(rjson)

# Initilize final table
final_table <- data.frame((matrix(nrow = 6, ncol = 8)))

# Write table header
final_table[1] <- c("", "","","","Control variables", "\\hline")
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
    reg_results <- read.csv(file=args[i + 1], header=TRUE, row.names=1)
    reg_results <- round(reg_results, 2)
    reg_results[is.na(reg_results)] <- "-"

    # Create panel header for table
    panel_header <- data.frame(matrix(nrow=2, ncol=8))
    panel_header[2, 1] <- paste("\\multicolumn{8}{l}{\\textit{", model$TITLE, "}} \\\\ %", sep="")
    panel_header[is.na(panel_header)] <- ""

    # Fill data into table conditional on model.
    if (model$MODEL_NAME == "baseline") {
        model_table = data.frame(matrix(nrow = 5, ncol = 8))
        rows <- c(1, 2, 4, 5, 7)
        # Note: Fill row names in first column since R does not allow duplicate rownames
        model_table[1] <- rownames(reg_results)[rows]
        model_table[2:8] <- reg_results[rows, ]

    } else {
        model_table = data.frame(matrix(nrow = 4, ncol = 8))
        rows <- c(1, 3, 5, 7)
        model_table[1] <- rownames(reg_results)[rows]
        model_table[2:8] <- reg_results[rows, ]
    }

    # Append panel header to model_table
    model_table = rbind(panel_header, model_table)

    # Append model_table to final table
    final_table = rbind(final_table, model_table)

}

tex_final_table = xtable(
    final_table,
    caption="First-Stage Estimates \\\\ (Dependent variable: expropriation risk)"
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
    size ="\\scriptsize"
)
