library(ggplot2)

set.seed(958)
data <- data.frame(matrix(nrow=0, ncol = 3))
colnames(data) <- c("N","contam", "n_contam")

temp <- qnorm((1-0.999)/2 + 0.999, mean = 0, sd = 1)

n <- seq(100,2500, by = 100)
for(i in n){
  temp_contam <- c()
  temp_n_contam <- c()
  for(j in 1:1200){
    vals <- rexp(i, 2.4)
    amplitude <- 2*temp/(sqrt(i)*mean(vals))
    temp_contam <- c(temp_contam, amplitude)
    
    if(floor(runif(1, 1, 100)) <= 20){
      vals <- rexp(i, 0.02)
      amplitude <- 2*temp/(sqrt(i)*mean(vals))
      temp_n_contam <- c(temp_n_contam, amplitude)
    }
  }
  data[nrow(data) + 1,] = c(i, mean(temp_contam), mean(temp_n_contam))
}

ggplot(data, aes(x = N)) +
  geom_line(aes(y=n_contam, colour = "Não Contaminado"), size = 1) +
  geom_line(aes(y=contam, colour = "Contaminado"), size = 1) +
  labs(colour = "Pureza", y = "Média de Amplitude", x = "dimensão da amostra")
