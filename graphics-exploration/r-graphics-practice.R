library(ggplot2)
#ggplot creates graphics in layers in which data is added, and then layers of geometries are added to create the final plot
apropos("^geom_") #types of geometries
apropos("^stat_") #types of stats that can be used
apropos("^scale_") #types of scales that can be used in plots

#using the photorec dataset
kDat <- readRDS("GSE4051_MINI.rds")
str(kDat)

table(kDat$devStage) #tabulate the number of observations within devstage
table(kDat$gType)
with(kDat, table(devStage, gType))

#using qplot as a quick and easy method to view plots
qplot(crabHammer, eggBomb, data = kDat)

#using ggplot
p <- ggplot(kDat, aes(x = crabHammer, y = eggBomb)) #specify the dataframe data to be used aka data layer
str(p) #returns a list of potential option layers to add to this dataset
#scatterplot
(p <- p + geom_point()) #simply adding the geom_point addds the scatterplot layer; these layers are their own functions and thus take their own arguments
#add a statistics layer to the scatterplot
(p <- p + geom_smooth())
(p <- p + theme_bw() + 
 xlab("Expression of crabHammer") + 
     ylab("Expression of eggBomb") +
         ggtitle("Scatterplot for expression levels")) #adding aesthetic layer to change titles and background color
nDat <- with(kDat,
             data.frame(sidChar, sidNum, devStage, gType, crabHammer,
                        probeset = factor(rep(c("eggBomb", "poisonFang"),
                                              each = nrow(kDat))),
                        geneExp = c(eggBomb, poisonFang))) #reshaping the kDat dataframe to now have expression and type of expression in separate columns
str(nDat)
(p <- ggplot(nDat, aes(crabHammer, geneExp, color = probeset)) +
 geom_point()) #notice the color graphics is placed in the aes layer of the data layer. The reason is because groupers like color and size using the data should be in the data layer, as arguments in the geom_ layer applies to each data point, which would not make sense in this case.
#alternatively this can be used
(p <- ggplot(nDat, aes(crabHammer, geneExp)) +
   geom_point(aes(color = probeset)))
(p <- ggplot(nDat, aes(crabHammer, geneExp, color = probeset)) +
 geom_point() + 
 stat_smooth(se = F)) #se = F turns off standard error ribbon; also note that the new layer added, the color identifiers also worked, as the aes layer applies to all new layers
#this can be overridden by adding a new aes layer within the new geom_
(p <- ggplot(nDat, aes(crabHammer, geneExp, color = probeset)) + 
   geom_point() + 
   stat_smooth(se = F, aes(group = 1)))
#we can plot different data sets on different panels but on the same plot
(p <- ggplot(nDat, aes(crabHammer, geneExp, color = gType)) +
 geom_point() + 
 facet_wrap(~probeset))
#facet_grid is used for different panels with 2 variables

#stripplots
#reshape data to essentially obtain the genes as a new variable
oDat <-
  with(kDat,
       data.frame(sidChar, sidNum, devStage, gType,
                  probeset = factor(rep(c("crabHammer", "eggBomb",
                                          "poisonFang"), each = nrow(kDat))),
                  geneExp = c(crabHammer, eggBomb, poisonFang)))
str(oDat)
(p <- ggplot(oDat, aes(geneExp, probeset)) + 
 geom_point())
(p <- ggplot(oDat, aes(geneExp, probeset)) + 
 geom_point(position = position_jitter(height = 0.1))) #add a jitter to better show overlapping points
(p <- ggplot(oDat, aes(devStage, geneExp)) +
 geom_point())
(p <- p + facet_wrap(~probeset)) #specify by the gene 
(p <- p + aes(color = gType)) #colorize by genotype
#adding stat summaries
(p <- p + stat_summary(fun.y = mean, geom = "point", shape = 4, size = 4)) #the means of each gene and by genotype; the fun.y feeds in the specified function

#density plots
(p <- ggplot(oDat, aes(geneExp)) + 
 geom_density())
(p <- ggplot(oDat, aes(geneExp)) + 
 stat_density(geom = "line", position = "identity"))
(p <- ggplot(oDat, aes(geneExp)) + 
 stat_density(geom = "line", position = "identity") + 
     geom_point(aes(y = 0.05), position = position_jitter(height = 0.05)))
(p <- ggplot(oDat, aes(geneExp)) + 
 stat_density(geom = "line", position = "identity", adjust = 0.5) + 
     geom_point(aes(y = 0.05), position = position_jitter(height = 0.05)))
(p <- p + facet_wrap(~gType)) #genotypes in different panels
(p <- ggplot(oDat, aes(geneExp, color = gType)) + 
 stat_density(geom = "line", position = "identity") + 
     geom_point(aes(y = 0.05), position = position_jitter(height = 0.05))) #genotypes by color
#putting it together for dev stage as well
(p <- ggplot(oDat, aes(geneExp, color = devStage)) + 
 stat_density(geom = "line", position = "identity") + 
     geom_point(aes(y = 0.05), position = position_jitter(height = 0.05)) +
         facet_wrap(~gType))

#boxplots
(p <- ggplot(oDat, aes(devStage, geneExp)) + 
 geom_boxplot())
(p <- p + facet_wrap(~gType))
#violinplot is a hybrid of a densityplot and histrogram
(p <- ggplot(oDat, aes(devStage, geneExp)) + 
 geom_violin())

#overmapping
#using the larger dataset
prDat <- read.table("GSE4051_data.tsv")
str(prDat, max.level = 0)
head(prDat)
prDes <- readRDS("GSE4051_design.rds")
str(prDes)

#grab 2 samples randomly to plot against
set.seed(2)
(yo <- sample(1:ncol(prDat), size = 2))
bDat <- data.frame(y = prDat[[yo[1]]], z = prDat[[yo[2]]])
str(bDat)
(p <- ggplot(bDat, aes(z, y)) +
 geom_point())
(p <- ggplot(bDat, aes(z, y)) +
 geom_point(alpha = 0.1)) #to reduce rendering time
(p <- ggplot(bDat, aes(z, y)) +
 stat_density2d())
(p <- ggplot(bDat, aes(z, y)) +
 stat_density2d(geom = "tile", contour = F, aes(fill = ..density..)) +
 scale_fill_gradient(low = "white", high = "blue"))
#using the hexbin with ggplot
install.packages("hexbin")
library(hexbin)
(p <- ggplot(bDat, aes(z, y)) +
 stat_binhex())

#using ggally and ggpairs
set.seed(3)
(yo <- sample(1:ncol(prDat), size = 4))
pairDat <- subset(prDat, select = yo)
str(pairDat)
install.packages("GGally")
library(GGally)
(p <- ggpairs(pairDat))

#heatmaps
library(RColorBrewer)
set.seed(1)
yo <- sample(1:nrow(prDat), size = 50)
str(yo)
hDat <- prDat[yo,]
colnames(hDat) <- with(prDes, paste(devStage, gType, sidChar, sep = "_"))
#transform data into tall format
prDatTall <- data.frame(sample = rep(colnames(hDat), each = nrow(hDat)),
                        probe = rownames(hDat),
                        expression = unlist(hDat))
#create a blue -> purple palette
jBuPuFun <- colorRampPalette(brewer.pal(n = 9, "BuPu"))
paletteSize <- 256
jBuPuPalette <- jBuPuFun(paletteSize)

#heatmapping
ggplot(prDatTall, aes(x = probe, y = sample, fill = expression)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) + 
    geom_tile() + 
        scale_fill_gradient2(low = jBuPuPalette[1],
                             mid = jBuPuPalette[paletteSize/2],
                             high = jBuPuPalette[paletteSize],
                             midpoint = (max(prDatTall$expression) +
                                         min(prDatTall$expression))/2,
                             name = "Expression")

#heatmap between genotypes
#using all data
#reshaping prDat into tall
prDatTall <- data.frame(sample = rep(colnames(prDat), each = nrow(prDat)),
                        probe = rownames(prDat),
                        expression = unlist(prDat),
                        devStage = rep(prDes$devStage, each = nrow(prDat)),
                        gType = rep(prDes$gType, each = nrow(prDat)))
str(prDatTall)
head(prDatTall)
#generate plot with an emphasis on genotype
oprDatTall <- prDatTall[order(prDatTall$gType),] #organize the samples by genotype
str(oprDatTall)
head(oprDatTall)
ggplot(oprDatTall, aes(x = probe, y = sample, fill = expression)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) + 
    geom_tile() + 
        scale_fill_gradient2(low = jBuPuPalette[1],
                             mid = jBuPuPalette[paletteSize/2],
                             high = jBuPuPalette[paletteSize],
                             midpoint = (max(prDatTall$expression) +
                                         min(prDatTall$expression))/2,
                             name = "Expression") 
#generate plot with an emphasis on dev stage
oprDatTall <- prDatTall[order(prDatTall$devStage),] #organize the samples by genotype
str(oprDatTall)
head(oprDatTall)
ggplot(oprDatTall, aes(x = probe, y = sample, fill = expression)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) + 
    geom_tile() + 
        scale_fill_gradient2(low = jBuPuPalette[1],
                             mid = jBuPuPalette[paletteSize/2],
                             high = jBuPuPalette[paletteSize],
                             midpoint = (max(prDatTall$expression) +
                                         min(prDatTall$expression))/2,
                             name = "Expression") 
