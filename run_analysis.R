nr=-1 #set number of lines to read, for debugging

#Read the datasets, merging train and test on-the-go since they are in the same format
X<-rbind(read.table("test/X_test.txt",nrows=nr),read.table("train/X_train.txt",nrows=nr))
y<-rbind(read.table("test/y_test.txt",nrows=nr),read.table("train/y_train.txt",nrows=nr))
subj<-rbind(read.table("test/subject_test.txt",nrows=nr),read.table("train/subject_train.txt",nrows=nr))

#Get & set names for variables and drop everything but the ones having "mean()" or "std()" in name
featurenames<-read.table("features.txt")[,2]
names(X)<-featurenames
X<-X[,which(grepl("mean\\(\\)",featurenames) | grepl("std\\(\\)",featurenames))]

#Read and set names for activities and subjects
names(y)<-"Activity"
names(subj)<-"Subject"
activities<-read.table("activity_labels.txt")[,2]
y$Activity<-factor(y$Activity,levels=seq(1,6,1),labels=activities)

#Add the Subject and Activity variables to the dataset
merged=cbind(subj,y,X)
rm(subj,y,X)

library(dplyr)
newset <- merged %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
write.table(newset,file="newset.txt")

