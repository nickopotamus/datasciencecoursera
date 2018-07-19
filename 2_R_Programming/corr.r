source("complete.R")
corr <- function(directory, threshold = 0){
  completes = complete(directory, 1:332) # Run completes on all
  completes_above_threshold = subset(completes, nobs > threshold ) # Find those above threshold
  
  correlations <- vector() # Empty vector
  filenames = list.files(directory) # List of filenames
  for(i in completes_above_threshold$id){
    filepath=paste(directory,"/" ,filenames[i], sep="")
    data = read.csv(filepath, header = TRUE)
    completeCases = data[complete.cases(data),]
    count = nrow(completeCases) ## Calculate and store the number of completed cases
    if( count >= threshold ) { ## Calculate and store the count of complete cases if threshold
      correlations = c(correlations, cor(completeCases$nitrate, completeCases$sulfate) )
    }
  }
  correlations # Return result
}