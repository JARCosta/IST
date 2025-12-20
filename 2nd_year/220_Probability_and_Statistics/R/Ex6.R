library(readxl)
library(ggplot2)
library(tidyr)
library(dplyr)

set.seed(1119)

df = data.frame(matrix(nrow=0, ncol = 2))
colnames(df) = c("N","Valor")

n <- c(4, 21, 56)
j <- 1
for(i in n){
  for (j in 1:740) {
    m <- mean(runif(i,6,10))
    df[nrow(df) + 1,] = c(i, m)
  }
}

par(mfrow=c(1,3))
df4 <- df %>% filter(N == 4)
Curva4 <- rnorm(740,mean(df4$Valor),sd(df4$Valor))
hist(df4$Valor,prob=TRUE, main= "", breaks = seq(min(df4$Valor), max(df4$Valor), length.out = 21))
lines(density(Curva4))

df21 <- df %>% filter(N == 21)
Curva21 <- rnorm(740,mean(df21$Valor),sd(df21$Valor))
hist(df21$Valor,prob=TRUE, main= "", breaks = seq(min(df21$Valor), max(df21$Valor), length.out = 21))
lines(density(Curva21))

df56 <- df %>% filter(N == 56)
Curva56 <- rnorm(740,mean(df56$Valor),sd(df56$Valor))
hist(df56$Valor,prob=TRUE, main= "", breaks = seq(min(df56$Valor), max(df56$Valor), length.out = 21))
lines(density(Curva56))