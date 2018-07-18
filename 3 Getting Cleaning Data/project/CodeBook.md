## Getting and Cleaning Data Course Project

### Description
Code Book describing variables and data in [tidyData.txt](https://github.com/nickopotamus/datasciencecoursera/blob/master/3%20Getting%20Cleaning%20Data/project/tidyData.txt)
This constitutes a contribution to the course project for the Johns Hopkins Getting and Cleaning Data course on Coursera.

### Source Data
* Data and description purpotedly available at [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) although this link appears to be dead
* Data used in the project can be downloaded from [Cloudfront](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Initial dataset information
- Subjects: 30 volunteers aged 19-48 years. 
- Activities: Each subject performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) - Data collection: Via Samsung Galaxy S II smartphone worn on the waist
- Data collected: 3-axial linear acceleration and 3-axial angular velocity, sampled at a constant rate of 50Hz, via embedded accelerometer and gyroscope.
- Data sets: Randomly partitioned into training data (70%)and test data (30%).

### Attribute information in tidyData.txt
For each record in the dataset
- An identifier of the subject who carried out the experiment
- Activity label
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration mean and standard deviation
- Triaxial Angular velocity from the gyroscope mean and standard deviation 