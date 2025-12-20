library(readxl)
library(ggplot2)

source <- read_excel("C:/Users/João Roque Costa/Downloads/EsperancaVida.xlsx", col_names = FALSE)
source <- source[c(6:67),c(1:103)]

graph <- c(source[c(44:51), c(1,42,53,59,76,87,93)])
graph <- sapply(graph, as.numeric)
colnames(graph) <- c("Anos","BT.H","HU.H","MT.H","BT.M","HU.M","MT.M")
dataFrame <- as.data.frame(graph)

tab <- data.frame(
  Anos = rep(c(dataFrame$Anos), 2),
  Países = rep(c("Bulgaria", "Hungria", "Malta"), each = 16),
  Gender = rep(c("Male", "Female"), each = 8),
  Valores = c(dataFrame$BT.H, dataFrame$BT.M, dataFrame$HU.H, dataFrame$HU.M,dataFrame$MT.H,dataFrame$MT.M)
)

ggplot(tab, aes(x = Anos)) +
  geom_point(aes(y = Valores, colour = Países, shape = Gender), size = 3) +
  geom_line(aes(y = Valores, colour = Países, linetype = Gender), size = 1)
