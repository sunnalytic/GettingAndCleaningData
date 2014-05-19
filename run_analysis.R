## Load, label and merge test data set
X_te <- read.table("UCI HAR Dataset/test/X_test.txt")
X_tr <- read.table("UCI HAR Dataset/train/X_train.txt")
X <- rbind(X_te, X_tr)
 ### Label X data sets with the 'features' names
names(X) <- features$V2

## Load, label and merge train data set
Y_te <- read.table("UCI HAR Dataset/test/Y_test.txt")
Y_tr <- read.table("UCI HAR Dataset/train/Y_train.txt")
act_lb <- read.table("UCI HAR Dataset/activity_labels.txt")
act_lb_names <- as.vector(act_lb$V2)
 ### Use descriptive activity names to replace the activities index with labeling activity names
for (i in 1:6){
        Y_te$V1[which(Y_te==i)] <- act_lb_names[i]
        Y_tr$V1[which(Y_tr==i)] <- act_lb_names[i]
}
Y <- rbind(Y_te, Y_tr)

# Merge all data into one tidy data set
subj_te <- read.table("UCI HAR Dataset/test/subject_test.txt")
subj_tr <- read.table("UCI HAR Dataset/train/subject_train.txt")
Subject <- rbind(subj_tr, subj_te)
tidy_data <- cbind(X,Y,Subject)
 ### label activity and subject data sets with a descriptive names
names(tidy_data)[562] <- "activity"
names(tidy_data)[563] <- "subject"
 ### Make syntactically valid names out of every column names
colnames(tidy_data) <- make.names(colnames(tidy_data), unique = TRUE)

## Extract mean and standard deviation measurement from tidy data
meanCol <- grep("[Mm][Ee][Aa][Nn]", colnames(tidy_data))
stdCol <- grep("[Ss][Tt][Dd]", colnames(tidy_data))
data_summary <- tidy_data[,c(meanCol, stdCol, 562, 563)]

## Creates another data set with the average of each variable for each activity and each subject.
avg_data <- aggregate(. ~ subject+activity, data = data_summary, mean)

# Writes text documents of the data sets
write.table(tidy_data, file="tidy_data.txt", row.names=FALSE)
write.table(data_summary, file="data_summary.txt", row.names=FALSE)
write.table(avg_data, file="avg_data.txt", row.names=FALSE)
