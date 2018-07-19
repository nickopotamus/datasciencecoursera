best <- function(state, outcome){
  
  library(dplyr)
  
  ## Read outcome data and initialise
  outcomeData <- read.csv("outcome-of-care-measures.csv",colClasses = "character")
  bestHospital <- NULL
  rate <- NULL
  
  ## Function for heart attack
  inHeartAttack <- function(s, x){
    x <- select(x, State, Hospital.Name, Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)
    filtered <- x[x$State==s & x$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack != 'Not Available' ,c("Hospital.Name","Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")]
    # Sort alphabetically by hospital name
    sortedData <- arrange(filtered, Hospital.Name)
    # Sort by mortality rate
    sortedData$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack <- as.numeric(sortedData$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)
    sortedData <- arrange(sortedData, Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)
    # Return hospital name in that state with lowest 30-day death
    bestHosp <- sortedData
  }
  
  ## Function for heart failure
  inHeartFailure <- function(s, x){
    x <- select(x, State, Hospital.Name, Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
    filtered <- x[x$State==s & x$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure != 'Not Available' ,c("Hospital.Name","Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")]
    
    ## Sort by Hospital name
    sortedData <- arrange(filtered, Hospital.Name)
    
    ## Sort by Rate
    sortedData$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure <- as.numeric(sortedData$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
    sortedData <- arrange(sortedData, Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
    
    ## Return hospital name in that state with lowest 30-day death
    bestHosp <- sortedData
    
  }
  
  ## Function for pneumonia
  inPneumonia <- function(s, x){
    x <- select(x, State, Hospital.Name, Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)
    filtered <- x[x$State==s & x$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia != 'Not Available' ,c("Hospital.Name","Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")]
    
    ## Sort by Hospital name
    sortedData <- arrange(filtered, Hospital.Name)
    
    ## Sort by Rate
    sortedData$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia <- as.numeric(sortedData$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)
    sortedData <- arrange(sortedData, Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)
    
    ## Return hospital name in that state with lowest 30-day death
    bestHosp <- sortedData
    
  }
  
  ## Main
  ## Check that outcome is valid
  if (outcome == "heart attack"){
    ## Check that state is valid
    if (length(outcomeData[outcomeData$State == state,c("State")])>0){
      bh <- inHeartAttack(state, outcomeData)
      bestHospital <- bh[1,c("Hospital.Name")]
      rate <- bh[1,2]
    } else{
      print(paste("Error in best(", state, ", ", outcome,") : invalid state", sep=""))
    }
  } else if (outcome == "heart failure"){
    ## Check that state is valid
    if (length(outcomeData[outcomeData$State == state,c("State")])>0){
      bh <- inHeartFailure(state, outcomeData)
      bestHospital <- bh[1,c("Hospital.Name")]
      rate <- bh[1,2]
      
    } else{
      print(paste("Error in best(", state, ", ", outcome,") : invalid state", sep=""))
    }
  } else if (outcome == "pneumonia"){
    ## Check that state is valid
    if (length(outcomeData[outcomeData$State == state,c("State")])>0){
      bh <- inPneumonia(state, outcomeData)
      bestHospital <- bh[1,c("Hospital.Name")]
      rate <- bh[1,2]
    } else{
      print(paste("Error in best(", state, ", ", outcome,") : invalid state", sep=""))
    }
  } else{
    print(paste("Error in best(", state, ", ", outcome,") : invalid outcome", sep=""))
  }
  
  bestHospital
}