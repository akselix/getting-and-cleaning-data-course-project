#### README.md
### Coursera Getting and Cleaning Data Course Project  
  
Repository for Coursera Getting and Cleaning Data (getdata-007) Course Project. Goal of the project was to practise data cleaning and tidying. More detailed explanations can be found from CodeBook.md in this repository.  

#### Repository files:
- README.md
- CodeBook.md
- run_analysis.R  

#### Instructions
1. To run the script, please copy analysis.R has to your current R working directory and run.
source('./run_analysis.R')  

2. Script will check if there is a subdirectory “UCI HAR Dataset” with file activity_labels.txt in your current working directory
	* If these conditions are not met, the data will be downloaded and unarchived to the working directory and then tidied
	* If data is already in working directory, script will proceed to data tidying without download  

3. After data tidying process is finished three files are written to “UCI HAR Dataset” -directory.
	1. tidy_uci_combined_raw.txt
	2. tidy_uci_mean_and_std.txt
	3. tidy_uci_variable_averages.txt
