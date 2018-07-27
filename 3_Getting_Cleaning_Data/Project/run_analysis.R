## 0. Setup
# Load packages quietly
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
# Get the data from and out of the zip file
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip") # Creates UCI HAR Dataset folder
# Load activity labels + features
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names = c("index", "featureNames"))
# Extract only mean and SD features
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements) # clean names

## 1. Merges the training and the test sets to create one data set.
# Load training datasets
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("SubjectNum"))
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity"))
train <- cbind(trainSubjects, trainActivities, train)
# Load test datasets
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("SubjectNum"))
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("Activity"))
test <- cbind(testSubjects, testActivities, test)
# Merge datasets
combined <- rbind(train, test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# See setup section

## 3. Uses descriptive activity names to name the activities in the data set
# Convert classLabels to activityName
combined[["Activity"]] <- factor(combined[, Activity], levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])

## 4. Appropriately labels the data set with descriptive variable names.
combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Take the means
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)
# Export tidyData.txt
data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)