library(arules)
library(arulesViz)
setwd("~/Documents/R/webMining/scripts")
load("../data/transacoes_201308.rda")
load("../data/urls_201308.rda")

transacoes
itemFrequencyPlot(transacoes, support= 0.05)

subset(hash, hash$key == "3" | 
         hash$key == "6" | 
         hash$key == "9" | 
         hash$key == "10" | 
         hash$key == "11" | 
         hash$key== "15" | 
         hash$key == "21" | 
         hash$key == "22" | 
         hash$key == "28")

image(transacoes)

# The default value in APparameter for minlen is 1. 
# This means that rules with only one item (i.e., an empty antecedent/LHS) like
# {} => {beer}
# will be created. These rules mean that no matter what other items are involved 
# the item in the RHS will appear with the probability given by the rule's 
# confidence (which equals the support). 
# If you want to avoid these rules then use the argument parameter=list(minlen=2).
#rules <- apriori(transacoes, parameter= list(supp=0.05, conf= 0.2))
rules <- apriori(transacoes, parameter= list(supp=0.05, conf= 0.2, minlen=2))
inspect(rules)

plot(rules)
plot(rules, method = "graph", control = list(type = "items"))

subset(hash, hash$key == "2")
subset(hash, hash$key == "21")
subset(hash, hash$key == "18")
