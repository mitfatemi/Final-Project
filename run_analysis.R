


library(dplyr)
rm(list=ls())
cat("\014")
#####################################################################################
# 1. Merging training and test sets to create one data set
#####################################################################################

Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE,sep = "")
Ytrain <- read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE,sep = "")
Strain <- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep = "")

train <- cbind(Xtrain,Strain,Ytrain)


Xtest <- read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE,sep = "")
Ytest <- read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE,sep = "")
Stest <- read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep = "")


test <- cbind(Xtest,Stest,Ytest)

data <- rbind(train , test)


#####################################################################################
# 2. Extracting only the measurements on the mean and standard deviation for each measurement
#####################################################################################
features <- read.table("UCI HAR Dataset/features.txt",header=FALSE,sep="")

colnames(data) <- c(as.character(features[,2]) , "subject","activity")

ind <- grep("mean()|std()",colnames(data))
data <- data[,c(ind,562,563)]


#####################################################################################
# 3. Using descriptive activity names to name the activities in the data set
#####################################################################################
labels <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE,sep="")

temp <- as.factor(data[,"activity"])
levels(temp) <- labels[,2]
data[,"activity"] <- as.character(temp)

#####################################################################################
# 4. Appropriately labeling the data set with descriptive variable names
#####################################################################################
 #partially done in section 2
colnames(data) <- gsub("-",".",colnames(data))
colnames(data) <- gsub("\\(|\\)","",colnames(data))


#####################################################################################
# 5. Creating a tidy data set with the average of each variable for each activity and each subject
#####################################################################################
new_data <- data %>% group_by(activity,subject) %>% summarize_all(mean)
write.table(new_data,file="tidy_data.txt",row.names=FALSE)