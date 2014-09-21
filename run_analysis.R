## run_analysis.R
## written by Chris Brasted 21/09/2014
## submission for 'Getting and Cleaning Data
## Coursera course project

## read contents of datafiles into dataframes

features <- read.table("features.txt",sep="")
activities <- read.table("activity_labels.txt",sep="")
xTest <- read.table("X_test.txt",sep="")
yTest <- read.table("y_test.txt",sep="")
subjectTest <- read.table("subject_test.txt",sep="")
xTrain <- read.table("X_train.txt",sep="")
yTrain <- read.table("y_train.txt",sep="")
subjectTrain <- read.table("subject_train.txt",sep="")

## join testing and training dataframes
## remove interim components
xData <- rbind(xTest,xTrain)
yData <- rbind(yTest,yTrain)
rm(xTest)
rm(xTrain)
rm(yTest)
rm(yTrain)
subject <- rbind(subjectTest,subjectTrain)

## clean up feature names from features.txt
## add features as column names
feat1 <- as.character(features$V2)
feat2 <- sub("BodyBody","Body",feat1)
feat3 <- gsub("([A-Z])", " \\1", feat2)
colnames(xData) <- feat3 ##[,1]

result1 <- xData[,grep("mean\\(\\)|std\\(\\)",colnames(xData))] ##,grep("std"(xData(colnames))))]
## maybe remove xData 

## add activity descriptions to numbers and descriptive variable names
library(plyr)
activNames <- join(yData,activities)
varNames1 <- c("activity code","activity")
colnames(activNames) <- varNames1
step1 <- cbind(activNames,result1)

## convert subject numbers to factors and add to dataset
colnames(subject) <- "subject"
subj1 <- subject$subject
subject <- factor(subj1)
step2 <- (cbind(subject,step1))

## remove redundant activity code column
library(data.table)
step3 <- data.table(step2)
step3 <- as.data.frame(step3[,"activity code":=NULL])

## calculate means grouped by subject and activity
library(plyr)
dataOut <- ddply(step3, c("subject","activity"), numcolwise(mean))

## it would be nice to break out the variables embedded in the
## column names, but it's beyond the capacity of the author
## library(reshape2)
## molten1 <- melt(step4)
