library(data.table)

best <- function(state, outcome) {
  out_dt <- data.table::fread('outcome-of-care-measures.csv') # Read outcome data as DT
  outcome <- tolower(outcome)                                 # All lower case for future processing
  chosen_state <- toupper(state)                              # Rename variable state so no conflict w/ col name
  
  # Check that state and outcome are valid and informative error if not
  if (!chosen_state %in% unique(out_dt[["State"]])) stop('invalid state')
  if (!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop('invalid outcome')
  
  # Rename columns by stripping mortality text... now just "heart attack", "heart failure", "pneumonia"
  setnames(out_dt, tolower(sapply(colnames(out_dt), gsub, pattern = "^Hospital 30-Day Death \\(Mortality\\) Rates from ", replacement = "" )))
  
  #Filter by state
  out_dt <- out_dt[state == chosen_state]
  
  # Find column indices relevant to that outcome (1 - hospital name, 2 - state, 3 - outcome)
  col_indices <- grep(paste0("hospital name|state|^",outcome), colnames(out_dt))
  
  # Filtering out unnessecary columns of data 
  out_dt <- out_dt[, .SD ,.SDcols = col_indices]
  
  # Removing Missing Values for numerical datatype (outcome column)
  out_dt[, outcome] <- out_dt[,  as.numeric(get(outcome))]
  out_dt <- out_dt[complete.cases(out_dt),]
  
  # Order Column to Top 
  out_dt <- out_dt[order(get(outcome), `hospital name`)]
  
  return(out_dt[, "hospital name"][1])
  
}