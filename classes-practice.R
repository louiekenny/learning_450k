x <- 3 * 4
x
is.vector(x)
length(x)
x[2]  <- 100
x
x[5] <- 3
x
x[11]
x[0]
x <- 1:4
(y <- x^2)
z <- vector(mode = mode(x), length = length(x))
for(i in seq_along(x)) {
    z[i] <- x[i]^2
}
identical(y, z)
set.seed(1999)
rnorm(5, mean = 10^(1:5))
round(rnorm(5, sd = 10^(0:4)), 2)
