# getting_and_cleaning_data_project
Final project for the Coursera course "Getting and Cleaning Data" from JHU

Using the following link for the data source:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
This project contains one R script called run_analysis.R that does the following (not necessarily in this order):

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps to run this course project

1. Download the data source and put into a folder on your local drive. You'll have a ```UCI HAR Dataset``` folder.
2. Put ```run_analysis.R``` in the parent folder of ```UCI HAR Dataset```, then set it as your working directory using ```setwd()``` function in R.
3. Run ```source("run_analysis.R")```, then it will generate a new file ```tiny_data.txt``` in your working directory.
4. The script reads the data file back in to the object ```my_data``` at the end. If you wish to check that this worked properly run the R command ```View(my_data)```

## Dependencies

```run_analysis.R``` depends on ```reshape2```.
