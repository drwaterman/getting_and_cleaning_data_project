# Using the following link for the data source:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# This script, run_analysis.R, does the following when run from the parent directory
# of the dataset (not in this order):
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for 
#    each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

library(reshape2)  # Required for melt()

# Read in the descriptors for features and activities
features <- read.table("UCI HAR Dataset/features.txt", sep=" ", stringsAsFactors = FALSE)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

# Read and fix the labels of the test data, subset just the columns that are
# measurements of mean or standard deviation, and combine all test data to a 
# single data frame called test_data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
names(x_test) <- features[,2]
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test$subject <- subject_test
names(subject_test) <- "subject"
activity_features <- grepl("mean|std", names(x_test))
x_test <- x_test[,activity_features]
test_data <- cbind(subject_test, activity_labels[y_test[,1],2], x_test)
names(test_data)[2] <- "activity"

# Read and fix the labels of the training data, subset just the columns that are
# measurements of mean or standard deviation, and combine all training data to a 
# single data frame called train_data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
names(x_train) <- features[,2]
y_train<- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train<- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train$subject <- subject_train
names(subject_train) <- "subject"
activity_features <- grepl("mean|std", names(x_train))
x_train<- x_train[,activity_features]
train_data <- cbind(subject_train, activity_labels[y_train[,1],2], x_train)
names(train_data)[2] <- "activity"

# merge the test data and training data to a single data frame
total_data <- rbind(test_data, train_data)

# Optional cleanup of all the variables used to create total_data
rm(test_data)
rm(train_data)
rm(x_test)
rm(x_train)
rm(y_test)
rm(y_train)
rm(subject_test)
rm(subject_train)
rm(activity_features)
rm(features)
rm(activity_labels)

# Melt the data to start making it tidy.
# We will use subject and activity columns as the id variables. All other columns
# will be the measured variables.
id_labels = c("subject", "activity")
var_labels = setdiff(colnames(total_data), id_labels)
melted_data = melt(total_data, id = id_labels, measure.vars = var_labels)

# Call dcast to create a tidy data set that contains the mean of each
# (feature) column in total_data, based on every combination of subject and activity.
# Ex: Row 1 is Subject 1 Laying (79 means); 
#     Row 2 is Sub 1 Sitting (79 means); etc.
# This is the long form of tidy data (instead of wide, both acceptable)
# See http://seananderson.ca/2013/10/19/reshape.html for more info on 
#     long vs. wide tidy data
tidy_data = dcast(melted_data, subject + activity ~ variable, mean)

# Write the tidy data to tidy_data.txt. This is not intended to be a 
# human-readable text file, it should be read by read.table().
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)

# Read it back in just to verify the data
my_data <- read.table("tidy_data.txt", header=TRUE)
