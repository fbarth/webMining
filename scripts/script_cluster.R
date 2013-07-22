#
# TODO precisa ser revisado
#

load("../data/tabela.rda")
model <- kmeans(tabela, centers=2)
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
