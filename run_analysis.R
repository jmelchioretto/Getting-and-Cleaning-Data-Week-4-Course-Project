library(dplyr)
library(data.table)

# read test
x_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

# read train
x_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

# read activity labels
activity_labels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

# read data description
features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")

# name the columns

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityid"
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityid"
colnames(subject_test) <- "subjectid"
colnames(subject_train) <- "subjectid"
colnames(activity_labels) <- c("activityid", "activitytype")


# merge the training and the test sets to create one data set.
merge_test <- cbind(y_test, subject_test, x_test)
merge_train <- cbind(y_train, subject_train, x_train)
dataset <- rbind(merge_train, merge_test)

# Extracts only the measurements on the mean and standard deviation for each measurement.
columnnames <- colnames(dataset)
dataset_mean_std <- grep("mean\\(\\)|std\\(\\)", columnnames, value = TRUE)
dataset_mean_std_id <- c("activityid", "subjectid", dataset_mean_std)
selectdata <- dataset[ , dataset_mean_std_id]

# Appropriately labels the data set with descriptive variable names
# already done at the beginning

# From the data set, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_dataset <- dataset %>% group_by(activityid, subjectid) %>% summarize_each(funs(mean))
write.table(tidy_dataset, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
