library(readxl)
library(ggplot2)

table <- read_excel("C:/Users/João Roque Costa/Downloads/ResiduosPerCapita (1).xlsx", col_names = c("Países","quatro","desoito"), range = cell_cols(1:3))

#library(readxl)
#url <- "https://fenix.tecnico.ulisboa.pt/downloadFile/845043405571251/ResiduosPerCapita.xlsx"
#destfile <- "ResiduosPerCapita.xlsx"
#download.file(url, destfile)
#ResiduosPerCapita <- read_excel(destfile)
#View(ResiduosPerCapita)


#colnames(table)<-table[6,]
#colnames(table) <- c("Países","quatro","desoito")
table <- table[-c(1:6), ]
table <- table[-c(32:56), ]

selection <- table[c(7,9,15),]

#qplot(selection$Anos, selection$2018)
#ggplot(data.frame(selection$Anos, selection$2018), aes(selection$Anos,selection$2018)) + geom_point()

selection$quatro <- as.numeric(selection$quatro)
selection$desoito <- as.numeric(selection$desoito)
#selection

tab <- data.frame(
  Anos = rep(c("2004", "2018"), each = 3),
  Países = rep(selection$Países, 2),
  Valores = c(selection$desoito,selection$quatro)
)

#res <- ggplot(tab, aes(x = Países, y = Valores)) + geom_col(aes(fill = Anos), width = 0.7)
ggplot(tab, aes(x = Países, y = Valores, fill = Anos, label = Valores)) +
  geom_col(position = "dodge", width = 0.5)
# +geom_text(aes(x = Países, y = Valores, label = label), vjust = 1)
