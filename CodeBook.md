#### CodeBook.md
### Coursera Getting and Cleaning Data Course Project  

#### Synopsis of assignment
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.  

#### Original Raw Dataset

The original data comes from smartphone accelelerometer and gyroscope 3-axial raw signals recorded while subjects are performing assigned activities. For detailed description, please see features_info.txt file in the raw dataset.  
* [source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
* [description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)  

The downloadable file is in zip format. When unarchived, it produces a directory named "UCI HAR Dataset" with tens of files inside.

#### Tidy Dataset Produced by run_analysis.R script

The script combines data from different files to form one dataset. This is then further processed adhering to [tidy data principles](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CCEQFjAA&url=http%3A%2F%2Fvita.had.co.nz%2Fpapers%2Ftidy-data.pdf&ei=DrIdVIqLJ6n9ywPy-oHgBQ&usg=AFQjCNFUAQr-w_87XpPhfEDoDYQw5-G5zg&sig2=JY2UyqcSORfZahqfVvDeuQ&bvm=bv.75775273,d.bGQ) by Wickham.


##### Naming conventions
Original dataset had unclear variable names. Without specific domain knowledge, it is hard to translate them to something more understandable. The following actions were taken to make them variables clearer:  

* Variable names were modified in the follonwing way:
	1.	Replaced -mean with Mean
	2.	Replaced -std with Std
	3.	Removed parenthesis -()
	4.	Replaced BodyBody with Body
* Variable names (columns) generally use camelCase
* Commas in some variable names are preserved (ie. angleZ,gravityMean)