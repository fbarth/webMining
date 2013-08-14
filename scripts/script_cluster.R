setwd("~/Documents/R/webMining/scripts")

load("../data/tabela.rda")
model <- kmeans(tabela, centers=3, nstart=100)
hClustering <- hclust(dist(tabela))
plot(hClustering)
plot(hclust(dist(tabela), method = "complete"))
plot(hclust(dist(tabela), method = "single"))
plot(hclust(dist(tabela), method = "average"))
plot(hclust(dist(tabela), method = "complete"))
model <- kmeans(tabela, centers=4)
model
table(model$cluster)
tabela[model$cluster == 1,]


set.seed(1234)
elbow <- function(dataset) {
  wss <- numeric(15)
  for (i in 2:15) wss[i] <- sum(kmeans(dataset, centers = i)$withinss)
  plot(2:15, wss, type = "b", main = "Elbow method", xlab = "Number of Clusters", 
       ylab = "Within groups sum of squares", pch = 8)
}
