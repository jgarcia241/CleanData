# CleanData
Getting and Cleaning Data project

## Overview
The goal of this script is to clean data collected from the accelerometers from the Samsung Galaxy S smartphone.
To do so, we will follow the following steps:

* Merges the training and the test sets to create one data set
* Extracts only the measurements on the mean and standard deviation
* Uses descriptive activity names and and varaible names
* Generate a dataset that contains the average of each variable for each activity and each subject




## How the script works

The first thing the script does is to download the [dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) from its location. As the zip file is huge, we will ensure that we will only download the file in case the files hasn't been downlaoded yet. This was, we can execute the script more that once without the download overhead.

### Merging the dataset
We will use ```read.table``` to read each of the 8 files:

* activity_labels.txt

* features.txt

* subject_test.txt

* X_test.txt

* y_test.txt

* subject_train.txt

* X_train.txt

* y_train.txt


We then merge the files by rows using ```rbind```

### Extract mean an standard deviation

To extract the columns with names or standard deviation, we first find out what columns have in its name _mean_ or _std_, using ```grep```, and later we use those columns to select from the merged dataset only those columns:

```
#gets cols with mean or std name:
mean_std_cols<-grep("(.*)mean|(.*)std",features$V2)
X <- X[,mean_std_cols] #get filter out the rest of columns. take only those in the grep result
```



### Set descriptive names and labels de data

To properly name the columns of the dataset, we first get the names of the columns(from features files) that we have selected in the previous step, and set those as the names of the dataset.

```
#Let put the names of X with the names of the columns we are using(from features)
names(X)<-features[mean_std_cols,2]
```

We then later label the _Activity_ with the with a meanfull name, and add a new column with the activity label (from the activity labels file)

```
##For Y, lets name the currect column as activity ID
names(Y)<-c('ActivityID')
#and add a new column with the activity name
Y$ActivityName<-activity_labels[Y[,1],2]
names(subject)=c("subject")
```

Finally we will merge both sets by columns with ```cbind```.



### Create a new data set


To create the new dataset we will need the ```reshape```library, and the melt function to melt the data, to finally cast it using the mean function:

Lastly, we save the file using write.table 

```
melted<-melt(dataset1, id = c("subject","ActivityID","ActivityName"), measure.vars = setdiff(names(dataset1),c("subject","ActivityID","ActivityName")))
dataset2<-cast(melted, subject + ActivityName ~ variable, mean)
#write the file using write.table
write.table(dataset2, file = "dataset2.txt")
```
