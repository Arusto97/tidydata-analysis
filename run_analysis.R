# Step 1: Download and unzip the dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "dataset.zip")
unzip("dataset.zip")

# Step 2: Load the data
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityId", "activityLabel"))

# Training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features[, 2])
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activityId")

# Test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features[, 2])
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activityId")

# Step 3: Merge the datasets
subject <- rbind(subject_train, subject_test)
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)

# Combine all data into one dataset
data <- cbind(subject, y, x)

# Step 4: Extract mean and standard deviation measurements
mean_std_columns <- grep("-(mean|std)\\(\\)", features[, 2])
data <- data[, c(1, 2, mean_std_columns + 2)]

# Step 5: Use descriptive activity names
data$activityId <- activities[data$activityId, 2]

# Step 6: Label the data with descriptive variable names
names(data)[-c(1, 2)] <- features[mean_std_columns, 2]
names(data) <- gsub("^t", "Time", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))

# Step 7: Create a tidy dataset
library(dplyr)
tidy_data <- data %>%
  group_by(subject, activityId) %>%
  summarize_all(mean)

# Write the tidy dataset to a file
write.table(tidy_data, "tidy_data.txt", row.name = FALSE)
