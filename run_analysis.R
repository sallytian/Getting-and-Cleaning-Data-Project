## Get features names
feature <- read.table("./UCI HAR Dataset/features.txt")
colnames(feature) <- c("No", "Names")

## Extracts mean and std related features
index <- grep("mean|std", feature$Names)

## Get test and train data with desired features
testAll <- read.table("./UCI HAR Dataset/test/X_test.txt")
test <- testAll[ , index]
trainAll <- read.table("./UCI HAR Dataset/train/X_train.txt")
train <- trainAll[ , index]

## Merge test and train data with desired features into one dataset
all <- rbind(test, train)

## Add descriptive column names
colnames(all) <- feature[index, 2]

## Read test and train labels&subjects
testlabel <- read.table("./UCI HAR Dataset/test/y_test.txt")
trainlabel <- read.table("./UCI HAR Dataset/train/y_train.txt")
label <- rbind(testlabel, trainlabel)
colnames(label) <- "label"
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject <- rbind(testsubject, trainsubject)
colnames(subject) <- "subject"

## Map activities labels
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity) <- c("label", "activity")
label$activity <- factor(label$label, levels = activity$label, 
                         labels = activity$activity)

## Merge label and subject info into dataset
all <- cbind(label, subject, all)

## Create a dataset with average of each variable for each activity and each subject
col <- as.character(feature[index, 2])
tidy <- aggregate(all[ ,col], by = list(all$subject, all$activity), FUN = mean)
colnames(tidy)[1] <- "subject"
colnames(tidy)[2] <- "activity"
write.table(tidy, file = "tidy.txt", row.names = FALSE)
