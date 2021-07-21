#Week4
#data cleaning 
#getting the train set
rm(list=ls())
getwd()
setwd("/Users/gillette/Dropbox/Coursera materials/Data cleaning/UCI HAR Dataset/train")
list.files()
filelisttrain = list.files(pattern = "*.txt")
filelisttrain
datalistrain = lapply(filelisttrain, FUN=read.table)
head(datalistrain[2])
tidydata<-data.frame(datalistrain[2])
tidydata

#Adding the descriptive numbers to the dataset
data1<-data.frame(datalistrain[1])
data2<-data.frame(datalistrain[3])
train<-c("train")
data<-cbind(train,data1,data2)
colnames(data)<-c("type","subject", "Activity labels")
tidydata<-cbind(data, tidydata)
tidydata

#Getting the test set
getwd()
setwd("/Users/gillette/Dropbox/Coursera materials/Data cleaning/UCI HAR Dataset/test")
test = list.files(pattern = "*.txt")
test
test = lapply(test, FUN=read.table)
head(test[2])
tidydata2<-data.frame(test[2])
data1<-data.frame(test[1])
data2<-data.frame(test[3])
testname<-c("test")
data<-cbind(testname,data1,data2)
colnames(data)<-c("type","subject", "Activity labels")
tidydata2<-cbind(data, tidydata2)

merged<-rbind(tidydata, tidydata2)
merged

#1. merging and assigning activity labels
setwd("/Users/gillette/Dropbox/Coursera materials/Data cleaning/UCI HAR Dataset")
a<-read.table("activity_labels.txt")
colnames(a)<-c("Activity labels", "description")
a
colnames(merged)
merged
merged_assign<-merge(merged[,1:3], a, by="Activity labels") # 3. assigning acitivities 
merged_assign
merged$`Activity labels`<-merged_assign$description

#2. extracting measurements on the mean and the std.
#Assigning colnames
getwd()
list.files()
features<-read.table("features.txt")
features$V2
names<-c("type", "subject", "activity", features$V2)
colnames(merged)<-names
means<-grep('mean', names(merged))#Mean values
means<-merged[,means]
stds<-grep('std', names(merged))#STD values
stds<-merged[,stds]
merged[,1:3]
data<-cbind(merged[,1:3], means, stds)#merged data
data

#4. Making labels for the data
library(tidyverse)
data[,1:3]
label<-tidyr::unite(data[,1:3], label, sep = "_")
newdata<-cbind(label,data[,4:length(colnames(data))])
newdata

#5. making new data.
newdata<-data.frame(newdata)
finaldata<-aggregate(newdata[, 2:length(colnames(newdata))], 
                     list(newdata$label), mean)

write.table(finaldata, file = "data.txt", sep = "\t", row.names = T, col.names = T)
list.files()
#Assignment compete