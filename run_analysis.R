## Coursera Getting and Cleaning Data Course Project
# 2014-09-16
# Akselix

# Load packages. Function checks if required packages are installed and installs and loads them.
packages <- function(x){
    x<-as.character(match.call()[[2]])
    if (!require(x,character.only=TRUE)){
        install.packages(pkgs=x,repos="http://cran.r-project.org")
        require(x,character.only=TRUE)
    }
}

packages(dplyr)


# Give user instructions to use one of two functions
print("To download data, run DownloadData(). If data already exists in directory <./UCI HAR Dataset>, run MakeTidy()")


### Loading and preprocessing data ####

DownloadData <- function() {
# Create a temporary file.
temp.file <- tempfile()
# Download file as binary and save it to the temporary file.
download.file(
    url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    temp.file ,
    mode = 'wb', 
    method="curl"
)
# Unzip the files to the temporary directory.
files <- unzip(temp.file , exdir = getwd())

print("Data downloaded. Please, proceed with make.tidy()")
}


MakeTidy <- function() {

## Read in and preprocess data ####

setwd('UCI HAR Dataset/')

# Read activity labels and rename columns.
activity.labels <- read.table('UCI HAR Dataset/activity_labels.txt', col.names=c("activityId","activityName"))

# Read the feature names. Assign them to a vector that will be used naming dataframe columns. Clean feature naming convention.
features <- read.table('UCI HAR Dataset/features.txt')
feature.names <- features[,2]
feature.names <- gsub('-mean', 'Mean', feature.names)
feature.names <- gsub('-std', 'Std', feature.names)
feature.names <- gsub('[()-]', '', feature.names)
feature.names <- gsub('BodyBody', 'Body', feature.names)

# Read test data and label columns.
test.set <- read.table("./test/X_test.txt")
colnames(test.set)  <- feature.names
# Read test subject ids and label column.
test.subject.id <- read.table("./test/subject_test.txt")
colnames(test.subject.id)  <- "subjectId"
# Read activity ids of the test data and label column.
test.activity.id  <- read.table("./test/y_test.txt")
colnames(test.activity.id) <- "activityId"
# Merge test data into one data frame.
test.df <- cbind(test.subject.id, test.activity.id, test.set)

# Read training data and label columns.
train.set <- read.table("./train/X_train.txt")
colnames(train.set)  <- feature.names
# Read training subject ids and label column.
train.subject.id <- read.table("./train/subject_train.txt")
colnames(train.subject.id)  <- "subjectId"
# Read activity ids of the training data and label column.
train.activity.id  <- read.table("./train/y_train.txt")
colnames(train.activity.id) <- "activityId"
# Merge train data into one data frame.
train.df <- cbind(train.subject.id, train.activity.id, train.set)

# Combine test and training data
all.df <- rbind(test.data, train.data)


## Extract only measurements on mean and standard deviation for each measurement. 
# From features.info.txt: The set of variables that were estimated from these signals are: 
#mean(): Mean value
#std(): Standard deviation ...
# -> Column names changed to "Mean" and "Std" earlier. Selecting columns with these

# Convert to tbl_df for dplyr
all.tbl <- tbl_df(all.df)

#Select wanted rows based on column name
mean.tbl <- select(all.tbl, contains('Mean'))
std.tbl <- select(all.tbl, contains('Std'))
mean.std.tbl <- tbl_df(cbind(mean.tbl, std.tbl))


## Create a table with average of each variable for each activity and each subject.
average.tbl <- all.tbl %>%
    group_by(subjectId, activityId) %>%
    summarise_each(funs(mean))


all.dt <- data.table(all.df)

tidy.df  <- all.dt[, lapply(.SD, mean), by=list(activityId,subjectId)]

tbl_df(tidy.df)



    
    
    
    
    
    
}