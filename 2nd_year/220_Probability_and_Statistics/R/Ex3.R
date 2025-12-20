library(readxl)
library(ggplot2)

source <- read_excel("C:/Users/João Roque Costa/Downloads/QualidadeARO3.xlsx", col_names = TRUE)

selection <- source[,c("Antas-Espinho", "Entrecampos")]
selection <- sapply(selection, as.numeric)
selection <- as.data.frame(selection)

df <- data.frame(
  Valores1 = c(selection$Entrecampos),
  Valores2 = c(selection$`Antas-Espinho`)
)

ggplot(df) + 
  geom_histogram(aes(x = Valores2, fill = "Antas-Espinho"), alpha = 0.5, binwidth=1) +
  geom_histogram(aes(x = Valores1, fill = "Entrecampos"), alpha = 0.5, binwidth=1)