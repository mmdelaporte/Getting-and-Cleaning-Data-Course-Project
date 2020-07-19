## Getting and Cleaning the Data
## Course Project

# 0. Prepare data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "raw_dataset.zip")
unzip("raw_dataset.zip")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", sep = "")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", sep = "")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", sep = "")

activity_labels <-read.table("UCI HAR Dataset/activity_labels.txt", sep = "")
features <-read.table("UCI HAR Dataset/features.txt", sep = "")

# 1. Merge training and test sets
x_data <- rbind(x_test, x_train)
y_data <- rbind(y_test, y_train)
sub_data <- rbind(sub_test, sub_train)

# 2. Extract measurements on mean and standard deviation
selectcolumns <- grep("-(mean|std).*", features[,2])
selectcolnames <- features[selectcolumns, 2]
selectcolnames <- gsub("-mean", "Mean", selectcolnames)
selectcolnames <- gsub("-std", "Std", selectcolnames)
selectcolnames <- gsub("[-()]", "", selectcolnames)

x_data <- x_data[selectcolumns]
dataset <- cbind(sub_data, y_data, x_data)

# 4. Label data with variable names
colnames(dataset) <- c("subject", "activity", selectcolnames) 

dataset$activity <- factor(dataset$activity, levels = activity_labels[,1], labels = activity_labels[,2])
dataset$subject <- as.factor(dataset$subject)

# 5. Create a tidy set with averages
library(reshape2)

dataset_melt <- melt(dataset, id = c("subject", "activity"))
dataset_tidy <- dcast(dataset_melt, subject + activity ~ variable, mean)

write.table(dataset_tidy, "./dataset_tidy.txt", row.names = FALSE, quote = FALSE)