#determine the working directory in which files will be read from unless otherwise specified
getwd()
#clear workspace (already clean)
rm(list=ls())
#load the gapminder package
library(gapminder)
#the gapminder dataset is a dataframe object in which we can learn basic data manipulation functions

#view gapminder's dataset structure with a glance
str(gapminder)
#view the first bit and last bit of the dataframe to obtain a sense of the dataframe's structure
head(gapminder)
tail(gapminder)
#find the column names of the dataframe
names(gapminder)
colnames(gapminder)
#find the number of columns
ncol(gapminder)
length(gapminder)
#find the number of rows
nrow(gapminder)
#print out all the row and column names; not advised if super long
dimnames(gapminder)

#statistical overview of the dataframe
summary(gapminder)
#basic plots to obtain a general understanding of the data
#plot function allows for graphing two variables, following by naming the dataset (gapminder in this case)
plot(lifeExp ~ year, gapminder)
plot(lifeExp ~ gdpPercap, gapminder)
plot(lifeExp ~ log(gdpPercap), gapminder)

#working within a dataframe
#view only a single column of the dataframe (three ways)
head(gapminder$lifeExp) #lifeExp is a numeric class object
summary(gapminder[,"lifeExp"])
hist(gapminder[,4]) 
summary(gapminder$year) #year is an interger class object, how there are so few that it could also be a factor
table(gapminder$year) #the table function summarizes the number of observations for each variable
class(gapminder$continent) #country and continent are true factor classes
summary(gapminder$continent)
#determine the available different factors within continent
levels(gapminder$continent)
nlevels(gapminder$continent)
#however, factors are still recognized and stored as numbers by R despite being friendly to view to our eyes
str(gapminder$continent)
table(gapminder$continent) #similar output to summary
barplot(table(gapminder$continent)) #useful in finding which factors are over/under represented

#load the ggplot2 package to use more intracate plotting abilities
library(ggplot2)
p <- ggplot(subset(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp)) #this peice of code allows the function to read the data and intilizes the plot; however, we haven't decided how to use that data yet
p  <- p + scale_x_log10() #log the x axis
p + geom_point() #takes the base and adds in the scatterplot modifier which will produce a scatterplot
p + geom_point(aes(color = continent)) #colors the points by continent
p + geom_point(alpha = (1/3), size = 3) + 
    geom_smooth(lwd = 3, se = FALSE)
p + geom_point(alpha = (1/3), size = 3) + 
    facet_wrap(~continent) + 
        geom_smooth(lwd = 1.5, se = FALSE)

#subsetting a dataframe can be useful for investigation or inspection, etc.
subset(gapminder, subset = country == "Uruguay") #only looks at the Uruguay data
#traditional R commands can also achieve a similar effect
gapminder[1621:1632,] #this is not recommended as the numbers 1621 and 1632 needs to be known apriori and can be vulnerable to change
#a better way using traditional commands; however, the subset function is more intuitive to look at 
gapminder[gapminder$country == "Uruguay",]
#subsetting columns
subset(gapminder, subset = country == "Mexico", 
       select = c(country, year, lifeExp))
#many functions which allow the "data = *" option will also allow for subsetting
p <- ggplot(subset(gapminder, country == "Colombia"),
            aes(x = year, y = lifeExp))
p + geom_point() + geom_smooth(lwd = 1, se = FALSE, method = "lm")
(minYear <- min(gapminder$year)) #placing brackets around a variable assigning will also print the output
myFit <- lm(lifeExp ~ I(year - minYear), gapminder, subset = country == "Colombia")
summary(myFit)
