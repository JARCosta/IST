library(readxl)
library(ggplot2)

set.seed(766)

n <- 62
teorico <- 1-pexp(8,rate=0.1)
Fn <- ecdf(rexp(n, 0.1))
estimado<- 1 - Fn(8)
diferença <- abs(estimado-teorico)