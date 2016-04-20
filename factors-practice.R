library(gapminder)
library(plyr)
library(dplyr)
library(ggplot2)

#modelling life expectancy as a function of year
#create a new function for the model
le_lin_fit <- function(dat, offset = 1952) {
    the_fit <- lm(lifeExp ~ I(year - offset), dat)
    setNames(data.frame(t(coef(the_fit))), c("intercept", "slope"))
} #this function will only work if the dataset inputted has the specified variables (aka for the gapminder dataset)

gapminder %>% filter(country == "Canada") %>% 
    le_lin_fit()

#conducting this function onto every country in an elegant way
#using dplyr
gcoefs  <-  gapminder %>%
    group_by(country, continent) %>%
    do(le_lin_fit(.)) %>% 
    ungroup()
gcoefs
#using plyr
gcoefs2 <- ddply(gapminder, ~ country + continent, le_lin_fit)
gcoefs2

#learning the factors of the newly created data frame
str(gcoefs, give.attr = FALSE)
levels(gcoefs$country)
head(gcoefs$country)

#the order of factors matter
ggplot(gcoefs, aes(x = slope, y = country)) + geom_point() #data puke; aka not useful to look at
ggplot(gcoefs, aes(x = slope, y = reorder(country, slope))) + geom_point() #easier to understand the data
#ordering numeric class vs. ordering factors
post_arrange <- gcoefs %>% arrange(slope)
post_reorder <- gcoefs %>% 
    mutate(country = reorder(country, slope))
post_both <- gcoefs %>% mutate(country = reorder(country, slope)) %>% 
    arrange(country)
ggplot(post_arrange, aes(x = slope, y = country)) + geom_point() #the dataframe was arranged by slope, but the reordering of numeric data does not allow for graphing functions to understand
ggplot(post_reorder, aes(x = slope, y = country)) + geom_point() #the reordering of factors did not make a difference in the visualization of the dataframe, but the graphing functions understood the change in factor order
post_reorder$country %>% levels #show the change in the factor order by slope
ggplot(post_both, aes(x = slope, y = country)) + geom_point() #ordered the dataframe and graphing thus allowing for both visualization methods to show meaningful display of slope ~ country

#dropping unused factors
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
hDat <- gapminder %>% filter(country %in% h_countries)
hDat %>% str
#notice how the country factor still displays all the old factors that are now not present due to the previous filtering step
#this may affect downstream analysis as these factors are still recognized
table(hDat$country)
levels(hDat$country)
nlevels(hDat$country)
#to remove these factors
iDat <- hDat %>% droplevels()
iDat %>% str
table(iDat$country)
levels(iDat$country)
nlevels(iDat$country)

#reordering factor levels revisted
i_le_max <- iDat %>%  
    group_by(country) %>% 
        summarize(max_le = max(lifeExp))
i_le_max
ggplot(i_le_max, aes(x = country, y = max_le, group = 1)) + 
    geom_path() + geom_point()
ggplot(iDat, aes(x = year, y = lifeExp, group = country)) + 
    geom_line(aes(color = country))
jDat <- iDat %>% 
    mutate(country = reorder(country, lifeExp, max))
data.frame(before = levels(iDat$country), after = levels(jDat$country))
j_le_max <- jDat %>%  
    group_by(country) %>% 
        summarize(max_le = max(lifeExp))
j_le_max
ggplot(j_le_max, aes(x = country, y = max_le, group = 1)) + 
    geom_path() + geom_point()
ggplot(jDat, aes(x = year, y = lifeExp)) + 
    geom_line(aes(color = country)) + 
        guides(color = guide_legend(reverse = TRUE))
#reordering continent
head(gcoefs)
ggplot(gcoefs, aes(x = continent, y = intercept)) + 
    geom_jitter(width = 0.25) 
newgcoefs <- gcoefs %>% mutate(continent = reorder(continent, intercept, mean))
ggplot(newgcoefs, aes(x = continent, y = intercept)) + 
    geom_jitter(width = 0.25) 

#recoding factor values
k_countries <- c("Australia", "Korea, Dem. Rep.", "Korea, Rep.")
kDat <- gapminder %>% 
    filter(country %in% k_countries, year > 2000) %>%
        droplevels()
kDat
levels(kDat$country)
kDat  <-  kDat %>% 
    mutate(new_country = revalue(country, c("Australia" = "Oz",
                                            "Korea, Dem. Rep." = "North Korea",
                                            "Korea, Rep." = "South Korea")))
data.frame(levels(kDat$country), levels(kDat$new_country))

#combinind tables and growing factors together
#best approach is to use rbind
usa <- gapminder %>% 
    filter(country == "United States", year > 2000) %>% 
        droplevels()
mex <- gapminder %>% 
    filter(country == "Mexico", year > 2000) %>% 
        droplevels()
str(usa) #only a single level for country
str(mex)
usa_mex <- rbind(usa, mex) #combining the two dataframes into one
str(usa_mex) #now 2 factors in the dataframe

#avoid using the concatenate function c() to combine factors
(nono <- c(usa$country, mex$country)) #not the output we want
#you may want to use this roundabout way
(maybe <- factor(c(levels(usa$country)[usa$country], levels(mex$country)[mex$country]))

#if you are combining factors of different levels, first convert to character, combine, and then reconvert to factors
gapminder$continent <- as.character(gapminder$continent)
str(gapminder)
head(gapminder)
gapminder$continent <- factor(gapminder$continent)
str(gapminder)
head(gapminder)
