library(ggplot2)
library(plyr)
library(lattice)

prDat <- read.table("GSE4051_data.tsv")
str(prDat, max.level = 0)
prDes <- readRDS("GSE4051_design.rds")
str(prDes)

#2 sample tests
set.seed(987)
(theGene <- sample(1:nrow(prDat), 1)) #select one probe to study
pDat <- data.frame(prDes, gExp = unlist(prDat[theGene,]))
str(pDat)

#exploring data before analysis
#with aggregate function
aggregate(gExp ~ gType, pDat, FUN = mean)
aggregate(gExp ~ devStage, pDat, FUN = mean)
#with plyr
ddply(pDat, ~ gType, summarise, gExp = mean(gExp))

#make strip plot
#with lattice
stripplot(gType ~ gExp, pDat)
#with ggplot
 ggplot(pDat, aes(x = gExp, y = gType)) + geom_point()

#comparison test parametric
ttRes <- t.test(gExp ~ gType, pDat)
str(ttRes)
ttRes$statistic
ttRes$p.value

#try with another probe
set.seed(69)
(theGene <- sample(1:nrow(prDat), 1)) #select one probe to study
prDat[theGene,] #the affymetrix id probe
pDat <- data.frame(prDes, gExp = unlist(prDat[theGene,]))
str(pDat)
ttpDat <- t.test(gExp ~ gType, pDat)
wcpDat <- wilcox.test(gExp ~ gType, pDat)
kspDat <- with(pDat, ks.test(gType, gExp))

#aggregation
#apply functions
kDat <- readRDS("GSE4051_MINI.rds")
kMat <- as.matrix(kDat[c('crabHammer', 'eggBomb', 'poisonFang')])
str(kMat)
kMat
median(kMat[,1])
median(kMat[,"eggBomb"])
apply(kMat, 2, median) #this is much easier than conducting aggregate summary statistics on each variable individually
apply(kMat, 2, quantile, probs = 0.5)
apply(kMat, 2, quantile, probs = c(0.25, 0.5))
apply(kMat, 1, min)
colnames(kMat)[apply(kMat, 1, which.min)]

rowSums(kMat)
all.equal(rowSums(kMat), apply(kMat, 1, sum))
colMeans(kMat)

#3 different methods to achieving the same goal
jRowSums <- rowSums(prDat)
jRowSums <- apply(prDat, 1, sum)
prMat <- as.matrix(prDat)
jRowSums <- rep(NA, nrow(prDat))
for(i in 1:nrow(prDat)){
    jRowSums[i] <- sum(prDat[i,])
}
#the apply functions are much easier to read and quicker to write. furthermore, they are much easier on cpu and memory usage, thus much quicker to complete

#aggregate function
aggregate(eggBomb ~ devStage, kDat, FUN = mean)
aggregate(eggBomb ~ gType * devStage, kDat, FUN = mean)

aggregate(eggBomb ~ gType * devStage, kDat, FUN = range)

#using plyr
ddply(kDat, ~ devStage, summarize, avg = mean(eggBomb))
ddply(kDat, ~ gType * devStage, summarize, avg = mean(eggBomb))
ddply(kDat, ~ gType * devStage, summarize, min = min(eggBomb), max = max(eggBomb))

#2 sample tests with multiple genes
keepGenes <- c("1431708_a_at", "1424336_at", "1454696_at",
               "1416119_at", "1432141_x_at", "1429226_at")
miniDat <- subset(prDat, rownames(prDat) %in% keepGenes)
miniDat <- data.frame(gExp = as.vector(t(as.matrix(miniDat))),
                      gene = factor(rep(rownames(miniDat), each = ncol(miniDat)),
                                    levels = keepGenes))
miniDat <- data.frame(prDes, miniDat)
str(miniDat)
stripplot(gType ~ gExp | gene, miniDat,
          scales = list(x = list(relation = "free")),
          group = gType, auto.key = TRUE)
ggplot(miniDat, aes(x = gExp, y = gType, color = gType)) +
    facet_wrap(~ gene, scales = "free_x") +
    geom_point(alpha = 0.7) + 
    theme(panel.grid.major.x = element_blank())

someDat <- droplevels(subset(miniDat, gene == keepGenes[1]))
t.test(gExp ~ gType, someDat)

library(plyr)
d_ply(miniDat, ~ gene, function(x) t.test(gExp ~ gType, x), .print = TRUE)
#not so clear what the results are and we can't further manipulate them

ttRes <- dlply(miniDat, ~ gene, function(x) t.test(gExp ~ gType, x))
names(ttRes)
ttRes[["1454696_at"]]
#or if we know which result statistic we wanted in advance
ttRes <- ddply(miniDat, ~ gene, function(z) {
  zz <- t.test(gExp ~ gType, z)
  round(c(tStat = zz$statistic, pVal = zz$p.value), 4)
})
ttRes

#using dplyr is way better...
library(magrittr)
library(dplyr)
library(tidyr)
library(broom)

prDat <- read.table("GSE4051_data.tsv")
str(prDat, max.level = 0)
prDes <- readRDS("GSE4051_design.rds")
str(prDes)

prDat %>% head
#format to tall and select 50 random probes
set.seed(123)
someprobes <- rownames(prDat) %>% sample(50)
tprDat <- prDat %>% mutate(probes = rownames(.)) %>% filter(probes  %in% someprobes) %>% gather(sidChar, expression, 1:(ncol(.)-1)) %>% left_join(prDes, by = "sidChar")
tprDat %>% head
#t.test pvalue for each probe
tprDat %>% group_by(probes) %>% do(tidy(t.test(expression ~ gType, .)))


