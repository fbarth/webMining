library(arules)
library(arulesViz)

load("../data/transacoes.rda")
load("../data/urls.rda")

transacoes
itemFrequencyPlot(transacoes, support= 0.05)

subset(hash, hash$key == "2")
subset(hash, hash$key == "9")
subset(hash, hash$key == "18")
subset(hash, hash$key == "32")

image(transacoes)
#rules <- apriori(transacoes, parameter= list(supp=0.05, conf= 0.6))
rules <- apriori(transacoes, parameter= list(supp=0.05, conf= 0.2))
inspect(rules)

plot(rules)
plot(rules, method = "graph", control = list(type = "items"))

subset(hash, hash$key == "2")
subset(hash, hash$key == "21")
subset(hash, hash$key == "18")
