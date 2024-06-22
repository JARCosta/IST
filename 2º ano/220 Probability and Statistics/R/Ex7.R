set.seed(1605)
amostras <- 3450 
dim <- 150 
n = 31
p = 0.84
dados<- data.frame()
for(i in seq(amostras)){
  dados <- rbind(dados, c(mean(rbinom(dim,n,p))))
}
colnames(dados) <- 'Medias'
media <- mean(dados$Medias)
valorEsp <- n*p
result <- abs(valorEsp - media)
result