pollutantmean <- function(directory, pollutant, id=1:332){
  filenames = list.files(directory)                     # list all file names
  pollutants = c()                                      # placeholder for polutants
  for(i in id){
    filepath=paste(directory,"/" ,filenames[i], sep="") # filename
    data = read.csv(filepath, header = TRUE)            # read file
    pollutants = c(pollutants, data[,pollutant])        # extract polutants
  }
  mean(pollutants, na.rm=TRUE)                          # return mean removing NA values
}