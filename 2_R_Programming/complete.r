complete <- function(directory, id= 1:332){
  ids = c()   # Empty IDs vector
  nobss = c() # Empty number of complete cases vector
  filenames = list.files(directory) # Get files
  
  for(i in id){
    filepath=paste(directory,"/" ,filenames[i], sep="") # File name
    data = read.csv(filepath, header = TRUE)            # Read the file
    completeCases = data[complete.cases(data), ]        # Subset with no NAs
    ids =  c(ids, i)                                    # Add i to vector of IDs
    nobss = c(nobss, nrow(completeCases))               # Add num of completed rows from the subset to vector
    
  }
  data.frame(id=ids, nobs=nobss) # Made and return data frame of IDs against NOBS
}