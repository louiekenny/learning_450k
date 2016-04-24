x <- 3 * 4
x
is.vector(x)
length(x)
x[2] <- 100
x
x[5] <- 3
x
x[11]
x[0]
#R is built to work with vectors. Therefore, you should take advantage of this attribute, instead of the more intuitive method of using for loops to conduct single continuous operations.
#example
x <- 1:4
y <- x^2
y
#or
x <- 1:4
z <- vector(mode = mode(x), length = length(x))
for(i in seq_along(x)) {
    z[i] <- x[i]^2
}
identical(y,z)
#whereas the vectorizing built in function of R is to write vectors, the second method with z puts the output of the interseted equation one by one into the newly made vector.

#atomic vectors are the standard R objects, i.e. all of the same class, e.g. all factors, or all numerics. If multiple types are present, then the lowest common denominator apporach is used (usually character).
(x <- c("cabbage", pi, TRUE, 4.3))
str(x)
length(x)
mode(x)
class(x)
n <- 8
set.seed(1) #used to generated replicatable results when using random generating functions
(w <- round(rnorm(n), 2))
str(w)
(x <- 1:n)
length(x)
(y <- LETTERS[1:n])
is.logical(y)
(z <- runif(n) > 0.3)
as.numeric(z)

#indexing vectors
w
names(w) <- letters[seq_along(w)]
w < 0
which(w < 0)
w[w < 0]
seq(from = 1, to = length(w), by = 2) #sequence pattern
w[seq(from = 1, to = length(w), by = 2)] #indexing w by the sequence pattern 
w[-c(2, 5)] #not the 2nd and 5th 
w[c('c', 'a', 'f')] #indexing by the column names

#lists
(a <- list("cabbage", pi, TRUE, 4.3))
str(a)
length(a)
mode(a)
class(a)
names(a) <- c("veg", "dessert", "myAim", "number")
names(a)
a
a <- list(veg = "cabbage", dessert = pi, myAim = TRUE, number = 4.3) #faster way
names(a)
(a <- list(veg = c("cabbage", "eggplant"), 
           tNum = c(pi, exp(1), sqrt(2)),
           myAim = TRUE,
           joeNum = 2:6))
str(a)
length(a)
class(a)
mode(a)
#indexing lists
a[[2]] 
a$myAim
str(a$myAim)
a[["tNum"]]
str(a[["tNum"]])
iWantThis <- "joeNum"
a[[iWantThis]] #indexed to what iWantThis points to, which is joeNum
a[[c("joeNum", "veg")]] #cannot index more than one using double square brackets
names(a)
a[c("tNum", "veg")] #use single square bracket
str(a[c("tNum", "veg")])
a["veg"]
str(a["veg"])
length(a["veg"])
length(a["veg"][[1]])

#creating dataframe explicitly
n <- 8
set.seed(1)
(jDat <- data.frame(w = round(rnorm(n), 2),
                    x = 1:n,
                    y = I(LETTERS[1:n]),
                    z = runif(n) > 0.3,
                    v = rep(LETTERS[9:12], each = 2)))
str(jDat)
mode(jDat)
class(jDat)
is.list(jDat)
jDat[[5]]
jDat[c("x", "z")]
identical(subset(jDat, select = c(x, z)), jDat[c("x", "z")])

#converting lists to data.frames
#the trick is to ensure all variables have the same length
(qDat <- list(w = round(rnorm(n), 2),
             x = 1:(n-1), #this vector is shorter
             y = I(LETTERS[1:n])))
as.data.frame(qDat) #does not work because of unequal variable lenghts
#semi-fix by adding NAs to match the length
qDat$x[8] <- NA
as.data.frame(qDat) 
#alternatively
qDat$x  <-  1:n #fix the shorter variable x
(qDat  <-  as.data.frame(qDat))

#matrices are atomic vectors meaning all variables are the same class unlike listsand data frames
jMat <- outer(as.character(1:4), as.character(1:4),
              function(x, y) {
                           paste0('x', x, y)
             })
jMat
str(jMat)
class(jMat)
mode(jMat)
dim(jMat)
nrow(jMat)
ncol(jMat)
rownames(jMat)
rownames(jMat) <- paste0("row", seq_len(nrow(jMat)))
colnames(jMat) <- paste0("col", seq_len(ncol(jMat)))
dimnames(jMat)
jMat
#indexing matrices
jMat[2, 3]
jMat[2,]
is.vector(jMat[2,])
jMat[,3, drop = FALSE]
jMat[,3, drop = TRUE] #the output will be an atomic vector
dim(jMat[,3, drop = FALSE])
jMat[c("row1", "row4"), c("col2", "col3")]
jMat[-c(2,3), c(TRUE, TRUE, FALSE, FALSE)]
jMat[7] #at the end of the day, matrices in R are column stacked vectors; they can be indexed just like a vecotr
jMat
jMat[1, grepl("[24]", colnames(jMat))]
jMat["row1", 2:3] <- c("HEY!", "THIS IS NUTS!")
jMat
#creating matrices
matrix(1:5, nrow = 5)
matrix("yo!", nrow = 3, ncol = 6)
matrix(c("yo!", "foo?"), nrow = 3, ncol = 6)
matrix(1:15, nrow = 5, byrow = TRUE)
matrix(1:15 , nrow = 5,
    dimnames = list(paste0("row", 1:5),
                    paste0("col", 1:3)))
vec1 <- 5:1
vec2 <- 2^(1:5)
cbind(vec1, vec2)
rbind(vec1, vec2)
vecDat <- data.frame(vec1 = 5:1,
                     vec2 = 2^(1:5))
str(vecDat)

vecMat <- as.matrix(vecDat)
str(vecMat)
multiDat <- data.frame(vec1 = 5:1,
                       vec2 = paste0("hi", 1:5))
str(multiDat)
(multimax <- as.matrix(multiDat))
str(multimax)

#review
jDat
jDat$z
iWantThis <- "z"
jDat[[iWantThis]]
str(jDat[[iWantThis]])
jDat["y"]
str(jDat["y"])
iWantThis <- c("w", "v")
jDat[iWantThis]
str(jDat[c("w", "v")])
str(subset(jDat, select = c(w, v)))
jDat[,"v"]
str(jDat[,"v"])
jDat[,"v", drop = FALSE]
str(jDat[, "v", drop = FALSE])
jDat[c(2, 4, 7), c(1, 4)]
jDat[jDat$z,]
subset(jDat, subset = z)
