library(readxl)
library(ggplot2)

source <- read_excel("C:/Users/João Roque Costa/Downloads/Utentes.xlsx", col_names = TRUE)

dataframe <- data.frame(
  Idade = source$Idade,
  TAD = source$TAD
)
ggplot(dataframe, aes(x = Idade, y = TAD)) + 
  geom_point() + 
  geom_smooth(method = lm, formula = y ~ splines::bs(x, 3), se = FALSE)



