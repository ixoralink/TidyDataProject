---
title: "codebook"
author: "AI"
date: "12 February 2022"
output: 
  html_document:
    keep_md: TRUE
---

### FINAL PROJECT - TIDY DATA

This program makes use of a run_analysis.R script that downloads and extracts the raw data and cleans, labels and combines it to produce the results required for further analysis


#### STEP 1 - Set working directory and download files  

* Check and set current working directory
* Download the dataset from the given URL and unzip files
* Dataset downloaded and unzipped into 'UCI HAR Dataset' folder                   
  
#### STEP 2 - Extract each data set and assign appropriate column names  

* Read the outer files in the UCI Har Dataset folder
* Main files are the Activity Descriptions and the Features List  

Total of 6 Activities used for the study:


         1              WALKING  
         2     WALKING_UPSTAIRS  
         3   WALKING_DOWNSTAIRS  
         4              SITTING  
         5             STANDING  
         6               LAYING  
 


Features list contains labels for the measurements that come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These signals were used to estimate variables of the feature vector for each pattern: '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.        


#### STEP 3 - Read files from the 'test' and 'train' subfolders  

70% of 30 volunteers was selected for generating the training data and 30% the test data  

* Read test data files x_test, y_test and subject_test  
* Read train data files x_train, y_train and subject_train  
* Give names to all the columns in all the files appropriately


x and y test files  - 2947 observations of 561 variables   
x and y train files - 7352 observations of 561 variables   


#### STEP 4 - MERGE the Training and Test Data Sets  

Make sure the columns and rows are corresponding and use the cbind and rbind functions to create a comprehensive database of the test and training subjects with all the observations and data labels  

Merged data table will contain 10299 observations of 563 variables  


#### STEP 5 - Assign Descriptive Activity Names  

Use the descriptive activity names from the activity file to name the activities in the merged data set. The activities are numbered and will need to be matched and replaced with the corresponding text from the activity file.   

#### STEP 6 - Assign Descriptive Variable Names  

The variables currently use short references and need to be expanded to be more descriptive and identifiable for those who will use the information for further analysis. Some changes are as follows:

      "freq()"  ->  "Frequency"
      "^t"      ->  "time"
      "^f"      ->  "frequency"
      "Acc"     ->  "Accelerometer"
      "Gyro"    ->  "Gyroscope"
      "Mag"     ->  "Magnitude"
      "BodyBody"->  "Body"      
      
      
#### STEP 7 - EXTRACT Columns with MEAN and STD  

Extracts the measurements only for the mean and standard deviation for the entire merged and modified data set.   

Output data table is:  merged_data_meanstd of dimensions 10299 x 88


#### STEP 8 - CREATE FINAL SUMMARY  


From the merged data set, create an independent tidy data set with the average of each variable for each activity and each subject. Output the final file to a text file in the same folder. 


Final file is named: final_data_summary (180 observations x 88 variables)
