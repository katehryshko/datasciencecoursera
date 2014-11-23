setwd(C:\11 COURSERA\R\getdata-projectfiles-UCI HAR Dataset)
traindata = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
traindata[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
traindata[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
testdata = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testdata[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testdata[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

Labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

xx = read.csv("UCI HAR Dataset/xx.txt", sep="", header=FALSE)
xx[,2] = gsub('-mean', 'Mean', xx[,2])
xx[,2] = gsub('-std', 'Std', xx[,2])
xx[,2] = gsub('[-()]', '', xx[,2])

# bind data
data = rbind(traindata, testdata)

# mean and stddev:
columns <- grep(".*Mean.*|.*Std.*", xx[,2])

xx <- xx[columns,]
c <- c(columns, 562, 563)
data <- data[,columns]
# Add the column names (xx) to data
colnames(data) <- c(xx$V2, "Activity", "Subject")


currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  data$activity <- gsub(currentActivity, currentActivityLabel, data$activity)
  currentActivity <- currentActivity + 1
}

data$activity <- as.factor(data$activity)
data$subject <- as.factor(data$subject)
tidy = aggregate(data, by=list(activity = data$activity, subject=data$subject), mean)

write.table(tidy, "tidy.txt", sep="\t")
