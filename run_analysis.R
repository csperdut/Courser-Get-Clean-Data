# File management
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
zipfile <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"
dirFile <- "./UCI HAR Dataset"
  
# Tidy data file:
tidyDataFile <- "./tidy-UCI-HAR-dataset.txt"
tidyDataFileAVGtxt <- "./tidy-UCI-HAR-dataset-AVG.txt"
  
# Download dataset file and uncompress
if (file.exists(zipfile) == FALSE) {
    download.file(fileURL, destfile = zipfile)
  }
if (file.exists(dirFile) == FALSE) {
    unzip(zipfile)
  }

# Merges the training and the test sets to create one data set, combining the data tables by rows
  x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
  x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
  y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
  x <- rbind(x_train, x_test)
  y <- rbind(y_train, y_test)
  s <- rbind(subject_train, subject_test)

# Extracts only the measurements on the mean and standard deviation for each measurement:
features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('features_id', 'features_name')
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$features_name) 
x <- x[, index_features] 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))
  
# Appropriately labels the data set with descriptive activity names.
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('activities_id', 'activities_name')
y[, 1] = activities[y[, 1], 2]
names(y) <- "Activity"
names(s) <- "Subject"
tidyDataSet <- cbind(s, y, x)

# From the data set in the previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject
  p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
  tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)
  
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"
write.table(tidyDataSet, tidyDataFile)
write.table(tidyDataAVGSet, tidyDataFileAVGtxt)
