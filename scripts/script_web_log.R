setwd("~/Documents/R/web_mining/scripts")

access_log <- read.table("../data/20130620_access.log")

ip <- access_log[,1]
time <- as.Date(gsub(":[0-9]+","",gsub("\\[","",access_log[,4])), "%d/%B/%Y")
url <- gsub(" HTTP/1.0", "", gsub(" HTTP/1.1", "", gsub("GET ", "", access_log[,6])))
status <- access_log[,7]
ref <- access_log[,9]
agent <- access_log[,10]

dataset <- data.frame(ip,time,url,ref,status,agent)

remove(agent)
remove(ip)
remove(ref)
remove(status)
remove(time)
remove(url)
remove(access_log)

table(dataset$status)

# eliminando todos os registros not found
dataset <- subset(dataset, dataset$status != '404')

length(levels(dataset$ip))
dim(dataset)

# excluindo todas as transacoes que tem uma chamada HEAD para a URL
dataset <- dataset[!grepl("HEAD", dataset$url),]

# excluindo todas as URLs que possuem a palavra estatisticas
dataset <- dataset[!grepl("estatisticas", dataset$url),]

# excluindo qualquer acesso a imagens do formato gif e jpg
# alem de arquivos do tipo css
dataset <- dataset[!grepl("gif", dataset$url),]
dataset <- dataset[!grepl("jpg", dataset$url),]
dataset <- dataset[!grepl("css", dataset$url),]

# excluindo links com esta estrutura C= ou O=
# para eliminar acessos feitos por robos
dataset <- dataset[!grepl("C=", dataset$url),]
dataset <- dataset[!grepl("O=", dataset$url),]

# eliminar a pagina robots.txt
dataset <- dataset[!grepl("robots.txt", dataset$url),]

# eliminando todos os acessos feitos via Googlebot
dataset <- dataset[!grepl("Googlebot", dataset$agent),]
# eliminando todos os acessos feitos via bingbot
dataset <- dataset[!grepl("bingbot", dataset$agent),]
# eliminando todos os acessos feitos via wotbox.com/bot
dataset <- dataset[!grepl("wotbox", dataset$agent),]
# eliminando todos os acessos feitos via YandexBot
dataset <- dataset[!grepl("YandexBot", dataset$agent),]

length(levels(dataset$url))
pie(table(dataset$ip))
pie(table(dataset$url))

# eliminando todos os acessos feitos via Sitemaps Generator
dataset <- dataset[!grepl("Sitemaps Generator", dataset$agent),]

#
# filtragem de dados finalizada
# proximo etapa: identificar as secoes: regra: mesmo <ip, dia, agent> => mesma secao
#

cont <- 1
hash <- data.frame(paste(dataset[1,1],dataset[1,2],dataset[1,6]),cont)
names(hash) <- c("value","key")
s <- c()
s[1] <- (subset(hash, hash$value == (paste(dataset[1,1],dataset[1,2],dataset[1,6])))$key)

for (i in 2:dim(dataset)[1]){
  if(! ((paste(dataset[i,1],dataset[i,2],dataset[i,6])) %in% hash$value)){
    cont <- cont + 1
    hash <- rbind(hash, data.frame(value=(paste(dataset[i,1],dataset[i,2],dataset[i,6])), key=cont))
    s[i] <- (subset(hash, hash$value == (paste(dataset[i,1],dataset[i,2],dataset[i,6])))$key)
  }else{
    s[i] <- (subset(hash, hash$value == (paste(dataset[i,1],dataset[i,2],dataset[i,6])))$key)
  }    
}

dataset['session'] <- as.factor(s)

remove(hash)
remove(cont)
remove(i)
remove(s)

plot(table(dataset$session))

#
# convert url to short url
#

cont <- 1
hash <- data.frame(dataset[1,3],cont)
names(hash) <- c("value","key")
s <- c()
s[1] <- (subset(hash, hash$value == (dataset[1,3]))$key)

for (i in 2:dim(dataset)[1]){
  if(! (dataset[i,3] %in% hash$value)){
    cont <- cont + 1
    hash <- rbind(hash, data.frame(value=(dataset[i,3]), key=cont))
    s[i] <- (subset(hash, hash$value == (dataset[i,3]))$key)
  }else{
    s[i] <- (subset(hash, hash$value == (dataset[i,3]))$key)
  }    
}

dataset['short_url'] <- as.factor(s)

remove(cont)
remove(i)
remove(s)

plot(table(dataset$short_url))

#
# descoberta de sessao finalizada
# inicio da criacao da matriz de transacoes
#

tabela <- table(dataset$session, dataset$short_url)
class(tabela) <- "matrix"

# TODO criar uma transactions a partir da tabela
transacoes <- as(tabela, "transactions")

save(tabela, file="../data/tabela.rda")
save(transacoes, file="../data/transacoes.rda")
save(hash, file="../data/urls.rda")