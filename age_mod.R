#Load required libraries
library(randomForest)
library(caret)
library(dplyr)
library(xlsx)

#Read in data
df = read.csv('./model_data.csv')

#Set random seed
set.seed(1234)

#Examine the data
str(df)
hist(df$age)



#Fit full model using the logarithm of age for apprioximatoin of normal distribution
#with basePay and education variables
age.rf2 = randomForest(log(age)~basePay + education,data=df,importance=TRUE)
age.rf2

#Plot variable importance and other metrics
varImpPlot(age.rf2)
summary(age.rf2)
age.rf2

#Plot the predictions vs. the actual age values
plot(exp(age.rf2$predicted), df$age)

#Load the full data set
data <- read.xlsx("./sample_payroll_data.xlsx", 1)

#Write over the age variable for the data that was not used to train the model
data$age = as.integer(exp(predict(age.rf2, data)))

#Write out the modified data frame as an xslx workbook to the source directory
write.csv(data, './sample_payroll_data2.csv', row.names = F)
