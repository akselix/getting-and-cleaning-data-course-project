## Coursera Getting and Cleaning Data Course Project
## Practice tidy data sets
# 2014-09-19
# Akselix

# Load packages. Function installs and/or loads required packages if needed.
packages <- function(x){
    x<-as.character(match.call()[[2]])
    if (!require(x,character.only=TRUE)){
        install.packages(pkgs=x,repos="http://cran.r-project.org")
        require(x,character.only=TRUE)
    }
}

packages(dplyr)
packages(plyr)
packages(data.table)

## Download data if directory "UCI HAR Dataset" doesn't exist in current working directory. ####

# Set variables for the file check.
localdir  <- getwd()
test.path <- "UCI HAR Dataset/activity_labels.txt"

# IF directory doesn't exist, download to tmp and unzip to working directory.
if((file_test(op = '-f', x = paste(localdir, '/', test.path,sep=''))) == TRUE) {
        print("Seems that data exists. Continuing with tidying! This will take a little time.")
    } else {
        print("Downloading the dataset, this will take some time. I'll inform you when it's done.")
        # Create a temporary file.
        temp.file <- tempfile()
        # Download file as binary and save it to the temporary file.
        download.file(
        url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
        temp.file ,
        mode = 'wb', 
        method="curl"
        )
        # Unzip the files to the working directory directory.
        files <- unzip(temp.file , exdir = getwd())
        print("Data downloaded and extracted. Continuing with tidying!")
}


## Read in and preprocess data. ####

# Set working directory to where the raw data is.
setwd("./UCI HAR Dataset")

# Read the feature names. Assign them to a vector that will be used naming dataframe columns. Clean feature naming convention.
features <- read.table('./features.txt')
feature.names <- features[,2]
feature.names <- gsub('-mean', 'Mean', feature.names)
feature.names <- gsub('-std', 'Std', feature.names)
feature.names <- gsub('[()-]', '', feature.names)
feature.names <- gsub('BodyBody', 'Body', feature.names)

# Read test subject ids and label column.
test.subject.id <- read.table("./test/subject_test.txt")
colnames(test.subject.id)  <- "subjectId"
# Read activity ids of the test data and label column.
test.activity.id  <- read.table("./test/y_test.txt")
colnames(test.activity.id) <- "activity"
# Read test data and label columns.
test.set <- read.table("./test/X_test.txt")
colnames(test.set)  <- feature.names
# Merge test data into one data frame.
test.df <- cbind(test.activity.id, test.subject.id, test.set)

# Read activity ids of the training data and label column.
train.activity.id  <- read.table("./train/y_train.txt")
colnames(train.activity.id) <- "activity"
# Read training subject ids and label column.
train.subject.id <- read.table("./train/subject_train.txt")
colnames(train.subject.id)  <- "subjectId"
# Read training data and label columns.
train.set <- read.table("./train/X_train.txt")
colnames(train.set)  <- feature.names
# Merge train data into one data frame.
train.df <- cbind(train.activity.id, train.subject.id, train.set)

# Combine test and training data.
all.df <- rbind(test.df, train.df)

# Read activity labels and rename columns.
activity.labels <- read.table('./activity_labels.txt', col.names=c("activity","activityName"))
# Convert activityName to lower case.
activity.labels <- mutate(activity.labels, activityName = as.factor(tolower(levels(activityName))))
# Convert activity column to factor labeled by corresponding activity.labels.
all.df$activity <- factor(all.df$activity, levels = activity.labels$activity, labels = activity.labels$activityName)
# Convert to tbl_df for dplyr.
all.tbl <- tbl_df(all.df)
# Arrange tbl.
all.tbl <- arrange(all.tbl, activity, subjectId)



## Extract only measurements on mean and standard deviation for each measurement. ####
# From features.info.txt: The set of variables that were estimated from these signals are: 
#mean(): Mean value
#std(): Standard deviation ...
# -> Column names changed to "Mean" and "Std" earlier. Selecting columns with these.

# Select wanted rows based on column name.
mean.tbl <- select(all.tbl, activity, subjectId, contains('Mean'))
std.tbl <- select(all.tbl, activity, subjectId, contains('Std'))
mean.std.df <- cbind(mean.tbl, std.tbl)


## Create a data table with average of each variable for each activity and each subject. ####                
average.dt <- data.table(mean.std.df)
average.dt <- average.dt[, lapply(.SD, mean), by = list(activity,subjectId)]


## Write datasets to disk. ####
write.table(mean.std.df, file = 'tidy_uci_mean_and_std.txt', row.name = F)
write.table(average.dt, file = 'tidy_uci_variable_averages.txt', row.name = F)
write.table(all.df, file = 'tidy_uci_combined_raw.txt', row.name = F)

print("Tidy datasets are now saved to ./UCI HAR Dataset/ -directory. All the new files have tidy_ -prefix")