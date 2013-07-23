Criando regras de associação a partir do log de um servidor web
===============================================================

No script **tratando_web_log.Rmd** foi apresentado como transformar um log padrão de um servidor web em um conjunto de transações. 

Neste script nós vamos apresentar como identificar regras de associação a partir do conjunto de transações. Para isto, nós vamos precisar de dois pacotes (arules e arulesViz) e carregar os arquivos criados no script anterior.


```r
library(arules)
library(arulesViz)

load("../data/transacoes.rda")
load("../data/urls.rda")
```


O dataset que será analisado possui as seguintes características:


```r
transacoes
```

```
## transactions in sparse format with
##  271 transactions (rows) and
##  89 items (columns)
```


Os itens que possuem suporte igual ou superior são ilustrados no gráfico abaixo:


```r
itemFrequencyPlot(transacoes, support = 0.05)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-31.png) ![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-32.png) 


As URLs são:


```r
subset(hash, hash$key == "2")
```

```
##   value key
## 2     /   2
```

```r
subset(hash, hash$key == "9")
```

```
##                        value key
## 9 /materiais/webMiningR.html   9
```

```r
subset(hash, hash$key == "18")
```

```
##              value key
## 18 /materiais.html  18
```

```r
subset(hash, hash$key == "32")
```

```
##                                      value key
## 32 /materiais/docs/ia/buscaCompetitiva.pdf  32
```


Um gráfico útil para visualizar as transações é apresentado abaixo:


```r
image(transacoes)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 


As regras podem ser geradas utilizando o algoritmo **apriori**:


```r
rules <- apriori(transacoes, parameter = list(supp = 0.05, conf = 0.2, minlen = 2))
```

```
## 
## parameter specification:
##  confidence minval smax arem  aval originalSupport support minlen maxlen
##         0.2    0.1    1 none FALSE            TRUE    0.05      2     10
##  target   ext
##   rules FALSE
## 
## algorithmic control:
##  filter tree heap memopt load sort verbose
##     0.1 TRUE TRUE  FALSE TRUE    2    TRUE
## 
## apriori - find association rules with the apriori algorithm
## version 4.21 (2004.05.09)        (c) 1996-2004   Christian Borgelt
## set item appearances ...[0 item(s)] done [0.00s].
## set transactions ...[89 item(s), 271 transaction(s)] done [0.00s].
## sorting and recoding items ... [15 item(s)] done [0.00s].
## creating transaction tree ... done [0.00s].
## checking subsets of size 1 2 3 done [0.00s].
## writing ... [21 rule(s)] done [0.00s].
## creating S4 object  ... done [0.00s].
```

```r
inspect(rules)
```

```
##    lhs     rhs  support confidence   lift
## 1  {27} => {9}  0.05166     0.8235  3.188
## 2  {9}  => {27} 0.05166     0.2000  3.188
## 3  {25} => {9}  0.05535     0.8824  3.416
## 4  {9}  => {25} 0.05535     0.2143  3.416
## 5  {26} => {9}  0.05166     1.0000  3.871
## 6  {9}  => {26} 0.05166     0.2000  3.871
## 7  {10} => {9}  0.05535     0.8824  3.416
## 8  {9}  => {10} 0.05535     0.2143  3.416
## 9  {23} => {9}  0.06642     0.9000  3.484
## 10 {9}  => {23} 0.06642     0.2571  3.484
## 11 {19} => {9}  0.05166     0.8235  3.188
## 12 {9}  => {19} 0.05166     0.2000  3.188
## 13 {21} => {18} 0.05904     0.8421  8.777
## 14 {18} => {21} 0.05904     0.6154  8.777
## 15 {21} => {2}  0.05166     0.7368  3.994
## 16 {2}  => {21} 0.05166     0.2800  3.994
## 17 {18} => {2}  0.07011     0.7308  3.961
## 18 {2}  => {18} 0.07011     0.3800  3.961
## 19 {18,                                  
##     21} => {2}  0.05166     0.8750  4.742
## 20 {2,                                   
##     21} => {18} 0.05166     1.0000 10.423
## 21 {2,                                   
##     18} => {21} 0.05166     0.7368 10.510
```



```r
plot(rules)
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 



```r
plot(rules, method = "graph", control = list(type = "items"))
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

