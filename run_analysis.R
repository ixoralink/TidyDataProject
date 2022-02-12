# Coursera Getting and Cleaning Data 
# Final Programming Assignment

#    --------------------------
#      INITIALIZATION & INPUT
#    --------------------------


# Set working directory
getwd()
setwd('C:\\Users\\Seshadri Family\\Desktop\\coursera\\03_Cleaningdata\\03_finalproject')
list.files()

# Specify url indicated for project
project_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Give a new identifiable name for the zip file
zipfilenamenew <- "finalproject.zip"


# Check if data set folder already exists 
# If folder does not exist, download zip file from url 
# and unzip contents into same folder
# Remove downloaded zip file after file extraction

if (!file.exists("UCI HAR Dataset")) { 
  download.file(project_url, zipfilenamenew)
  unzip(zipfilenamenew) 
  file.remove(zipfilenamenew)
} else { print("File already extracted")}

list.files()


#    -------------
#      READ FILES
#    -------------


##***   READ OUTER FILES   ****
library(dplyr)       # to use %>%
library(data.table)  # to use fread which is faster

# Read Activity Labels file and give names to the columns
activity = fread("UCI HAR Dataset\\activity_labels.txt")
colnames(activity) <- c("activity_number","activity_description")  # rename columns
activity

# Read features file and give names to the columns
featurelist <- fread("UCI HAR Dataset\\features.txt")
colnames(featurelist) <- c("feature_number","feature")
# Quick View results
#head(featurelist)
#tail(featurelist)
#featurelist[,2]


##***   READ FILES in UCI HAR Dataset FOLDER    *****

# Read files from 'test' subfolder
x_test <- fread("UCI HAR Dataset\\test\\X_test.txt")
#head(x_test,n=1)
dim(x_test)                       # check dimensions of table in file
colnames(x_test) <- unlist(featurelist[ ,2])  # name the columns


y_test <- fread("UCI HAR Dataset\\test\\y_test.txt")
names(y_test) <- "activity_number"
colnames(y_test)

subject_test <- fread("UCI HAR Dataset\\test\\subject_test.txt")
head(subject_test)
names(subject_test) <- "subject"
colnames(subject_test)

# Read files from 'train' subfolder
x_train <- fread("UCI HAR Dataset\\train\\X_train.txt")
head(x_train, n=1)
dim(x_train)                       # check dimensions of table in file
names(x_train) <- unlist(featurelist[ ,2]) # name the columns 


y_train <- fread("UCI HAR Dataset\\train\\y_train.txt")
head(y_train)
names(y_train) <- "activity_number"


subject_train <- fread("UCI HAR Dataset\\train\\subject_train.txt")
names(subject_train) <- "subject"



#    -------------------------------------
#     1. MERGE TRAINING & TEST DATA SETS 
#    -------------------------------------

# Combine X, y, subject ('test'and 'train') data tables

x_tt <- rbind(x_test, x_train)
dim(x_tt)

y_tt <- rbind(y_test, y_train)
head(y_tt)
dim(y_tt)

subject_tt <- rbind(subject_test, subject_train)
dim(subject_tt)

merged_data <- cbind(subject_tt, y_tt, x_tt)


#    ---------------------------------------
#     3. ASSIGN DESCRIPTIVE ACTIVITY NAMES 
#    ---------------------------------------

# Take number and descriptions from the activities file 
# and replace the activity_number column in the new file 
# with the descriptions corresponding to the activity numbers
# 
#str(merged_data$activity_number)
#str(activity$activity_description)

#merged_data$activity_number
merged_data$activity_number <- activity[merged_data$activity_number, 2]
#head(merged_data$activity_number,n=50)

# to reverse activity description back to activity number
#  merged_data$activity_number <- match((merged_data$activity_number),(activity$activity_description))
#  merged_data$activity_number

#    ----------------------------------------
#     4. ASSIGN DESCRIPTIVE VARIABLE NAMES
#    ----------------------------------------

names(merged_data)

names(merged_data) <- gsub("freq()", "Frequency", names(merged_data),ignore.case = TRUE)
names(merged_data) <- gsub("^t", "time", names(merged_data))
names(merged_data) <- gsub("^f", "frequency", names(merged_data))
names(merged_data) <- gsub("Acc", "Accelerometer", names(merged_data),ignore.case = TRUE)
names(merged_data) <- gsub("Gyro", "Gyroscope", names(merged_data),ignore.case = TRUE)
names(merged_data) <- gsub("Mag", "Magnitude", names(merged_data),ignore.case = TRUE)
names(merged_data) <- gsub("BodyBody", "Body", names(merged_data),ignore.case = TRUE)

#    -------------------------------------
#     2. EXTRACT MEAN & STD DEVIATION 
#    -------------------------------------

#  Use 'select' function to find 'mean' and 'std' labels within the data table

merged_data_meanstd <- merged_data %>% select(subject,activity_number,contains('mean'),contains('std'))

head(merged_data_meanstd,n=1)
colnames(merged_data_meanstd)

#    -------------------------------------------------------
#     5. INDEPENDENT DATA SET with AVERAGE of EACH VARIABLE
#    --------------------------------------------------------

if (file.exists("final_data_summary.txt")) { 
  file.remove("final_data_summary.txt")
}else print("No final file exists; continuing program")


data_summary <- merged_data_meanstd %>%
  group_by(subject, activity_number) %>%
  summarise(across(everything(), list(mean)))

## Writing the tidy set into a file
fwrite(data_summary, file = "./final_data_summary.txt")

