addr<-"F:/coursera/Data Science-Johns Hopkins University/3-Getting and Cleaning Data/WEEK 4/peer/UCI HAR Dataset"
#Merges the training and the test sets to create one data set.

setwd(paste0(addr,"//","test"))
testsubj<-read.table("subject_test.txt")
testx<-read.table("X_test.txt")
testy<-read.table("y_test.txt")
test<-cbind(testsubj,testx,testy)

setwd(paste0(addr,"//","train"))
trainsubj<-read.table("subject_train.txt")
trainx<-read.table("X_train.txt")
trainy<-read.table("y_train.txt")
train<-cbind(trainsubj,trainx,trainy)

tot<-rbind(train,test)
setwd(addr)
namess<-read.table("features.txt")
activitylabel<-read.table("activity_labels.txt")
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set

names(tot)<-c("subject",as.character(namess$V2),"activity")
ind<-grepl("mean|std",namess$V2)
total<-tot[,ind]
#Appropriately labels the data set with descriptive variable names.
activities<-activitylabel$V2[total[,81]]
total[,81]<-activities
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
total$activity <- factor(total$activity, levels = activitylabel[,1], labels = activitylabel[,2])
total$subject <- as.factor(total$subject)
library(reshape2 )
total.melted <- melt(total, id = c("subject", "activity"))
total.mean <- dcast(total.melted, subject + activity ~ variable, mean)

write.table(total.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
