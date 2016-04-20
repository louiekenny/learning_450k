library(plyr)
library(dplyr)
library(magrittr)
library(ggplot2)

getwd()
list.files()

#load the data
prDat <- read.table("GSE4051_MINI.txt", header = TRUE, row.names = 1)
#if the read.table command fails, make sure you have permission access to the file directory of your working directory  
#we use the header command to ensure the top row of the txt file turns into the column names. We use row.names = 1 to ensure that the left most column turns into the row names of the newly imported dataframe.
str(prDat)

#taken directly from the stat course
#How many rows are there? Hint: nrow(), dim().
nrow(prDat)
dim(prDat) #39 rows

#How many columns or variables are there? Hint: ncol(), length(), dim().
ncol(prDat) #6 columns
length(prDat)
dim(prDat)

#Inspect the first few observations or the last few or a random sample. Hint: head(), tail(), x[i, j] combined with sample().
head(prDat)
tail(prDat)
prDat[sample(nrow(prDat), 6),] #random selection of 6 rows

#What does row correspond to – different genes or different mice?
#row corresponds to different samples

What are the variable names? Hint: names(), dimnames().
names(prDat)
colnames(prDat)
dimnames(prDat)

#What “flavor” is each variable, i.e. numeric, character, factor? Hint: str().
#sidNum is an interger/factor like variable
#devStage and gType are both factors
#the last 3 columns are numeric as they represent the measured expression

#For sample, do a sanity check that each integer between 1 and the number of rows in the dataset occurs exactly once. Hint: a:b, seq(), seq_len(), sort(), table(), ==, all(), all.equal(), identical().
sort(prDat$sidNum) #visual investigation
seq(prDat$sidNum)
identical(unique(prDat$sidNum), prDat$sidNum) #the vector of unique values in sidNum and in the actual column of sidNum are identical
unique(prDat$sidNum) == prDat$sidNum
table(prDat$sidNum) #tabulates all the observations of each unique sidNum 
#overall, there are exactly only 1 observation of each sample identifier

For each factor variable, what are the levels? Hint: levels(), str().
str(prDat)
levels(prDat$devStage) #4 developmental stages investigated
levels(prDat$gType) #2 genotypes

#How many observations do we have for each level of devStage? For gType? Hint: summary(), table().
table(prDat$devStage)
table(prDat$gType)

#Perform a cross-tabulation of devStage and gType. Hint: table().
table(prDat$devStage, prDat$gType)

#If you had to take a wild guess, what do you think the intended experimental design was? What actually happened in real life?
#The intended experimental design was most likely used to examine the expression of three genes at 4 developmental stages, between two different genotypes of the organism.

For each quantitative variable, what are the extremes? How about average or median? Hint: min(), max(), range(), summary(), fivenum(), mean(), median(), quantile().
summary(prDat$crabHammer)
summary(prDat$eggBomb)
summary(prDat$poisonFang)

#Create a new data.frame called weeDat only containing observations for which expression of poisonFang is above 7.5.
weeDat <- subset(prDat, subset = poisonFang > 7.5)

#For how many observations poisonFang > 7.5? How do they break down by genotype and developmental stage?
nrow(weeDat)
table(weeDat$gType, weeDat$devStage)

#Print the observations with row names “Sample_16” and “Sample_38” to screen, showing only the 3 gene expression variables.
zeeDat <- subset(prDat, subset = sidNum == "16" | sidNum == "38", select = c(eggBomb, crabHammer, poisonFang))
zeeDat

#Which samples have expression of eggBomb less than the 0.10 quantile?
veeDat <- subset(prDat, subset = eggBomb <)
