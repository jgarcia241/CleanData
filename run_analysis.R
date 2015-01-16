
# If the file is not there, we will download and extract from the zip file.  the File it's huge so just download it if we need it
if (!file.exists('dataset.zip')) {
  # Download file
  download.file(url='https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ', destfile='dataset.zip', method='curl')
  # Unzip file
  unzip('dataset.zip')
}



## read the files

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

#Let's merge the data, using rbind

X<-rbind(X_test,X_train)
Y<-rbind(y_test,y_train)
subject <- rbind(subject_test, subject_train)

#gets cols with mean or std name:
mean_std_cols<-grep("(.*)mean|(.*)std",features$V2)
X <- X[,mean_std_cols] #get filter out the rest of columns. take only those in the grep result

#Let put the names of X with the names of the columns we are using(from features)
names(X)<-features[mean_std_cols,2]

##For Y, lets name the currect column as activity ID
names(Y)<-c('ActivityID')
#and add a new column with the activity name
Y$ActivityName<-activity_labels[Y[,1],2]
names(subject)=c("subject")

#bind the 2 datasets, by cols#bind data
dataset1 <- cbind(subject, Y, X)


##Let's generate the second dataset, witll use the reshape lib
require("reshape")

melted<-melt(dataset1, id = c("subject","ActivityID","ActivityName"), measure.vars = setdiff(names(dataset1),c("subject","ActivityID","ActivityName")))
dataset2<-cast(melted, subject + ActivityName ~ variable, mean)
#write the file using write.table
write.table(dataset2, file = "dataset2.txt")
