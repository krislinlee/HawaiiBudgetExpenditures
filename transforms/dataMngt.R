### An idea was suggested at Unconferenz 2016 to develop a visualization prototype to show how the approved budget 
### of the State of Hawaii gets used by matching budget and expenditure data sets

### A team from Code for Hawaii identified budget related data from data.hawaii.gov and 
### two separate and independent data sets (approved budget and expendure) were downloaded.

### The data appeared to be organized and itemized in different formats across datasets, but both included
### department names (under different column names)
### The expenditure data appear to have more detailed breakdowns of expenditures 
### compared to the approved budget data.  In addition, the years of available data varied.

### For this prototype, we plan to develop a sankey diagram to show the flow of approved budget into each expenditure
### category by department.  A data visualization can be done in various ways, however, to 
### simplify the project for prototype purposes, and to show what can be achieved, we decided to summarize data 
### at department level only

### Data source:
# Expenditure data : https://data.hawaii.gov/dataset/Expenditures/mkz8-mgjp
# Approved budget data: https://data.hawaii.gov/dataset/Hawaii-Operating-Budget/p8xe-w4xh



########## Initial cleaning of data was done in Excel  #############

###   "Dept of", and "Department of" were eliminated for consistency across datasets
###    Records with negative amount were removed from the dataset



###########          This R script is used to          ##############

### 1. subset data for FY2015
### 2. clean out white spaces for department names
### 3. correct department name
### 4. merge budget and expenditure datasets into one dataset called MergedData


library(reshape)
library(plyr)
library(stringr)

setwd("~/Documents/cfh/HawaiiBudgetExpenditures")

## importing csc data files
exp <- read.csv("data/Expenditures.csv")
op <- read.csv("data/budget.csv")

## trimming white space
exp$Department <- str_trim(exp$Department, side=c("both"))
op$Department <- str_trim(op$Department, side=c("both"))

## Data correction
exp[exp$Department=="BUSINESS, ECONOMIC DEVELOPMENT, AND TOURISM", "Department" ] = "BUSINESS, ECONOMIC DEVELOPMENT AND TOURISM"

exp$NumericAmount <- as.numeric(sub("\\$","", as.character(exp$Amount)))

## subset data for 2015 and sum the total expenditure amount by department and category (Expenditure data)
dep_cat_exp15 <- ddply(exp[exp$Fiscal_Year==2015, ], .(Department, Expense_Category), summarize, Expediture_DepCat15 = sum(NumericAmount))

## subset data for 2015 and sum the total approved budget amount by department (Budget)
dep_cat_op15 <- ddply(op[op$Fiscal.Year==2015,], .(Department), summarize, Budget_Dep15 = sum(approvedAmount))

## Merging data by Department
mergedData <- join(dep_cat_exp15, dep_cat_op15, by=c('Department') , type="left")
names(mergedData) <- c("Department", "Expense_Category", "TotalExpense", "TotalBudget")

## write to csv file
write.csv(mergedData, "data/MergedData2015.csv") 

##
# 2016
##

## subset data for 2016 and sum the total expenditure amount by department and category (Expenditure data)
dep_cat_exp16 <- ddply(exp[exp$Fiscal_Year==2016, ], .(Department, Expense_Category), summarize, Expediture_DepCat15 = sum(NumericAmount))

## subset data for 2016 and sum the total approved budget amount by department (Budget)
dep_cat_op16 <- ddply(op[op$Fiscal.Year==2016,], .(Department), summarize, Budget_Dep15 = sum(approvedAmount))

## Merging data by Department
mergedData <- join(dep_cat_exp16, dep_cat_op16, by=c('Department') , type="left")
names(mergedData) <- c("Department", "Expense_Category", "TotalExpense", "TotalBudget")

## write to csv file
write.csv(mergedData, "data/MergedData2016.csv") 


 
