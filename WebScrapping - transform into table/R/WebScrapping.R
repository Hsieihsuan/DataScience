#Defino o diretorio de trabalho
setwd("Z:/DataScience/WebScrapping - transform into table/R")

#Inicio com os imports
library(rvest)
library(stringr)
library(dplyr)
library(lubridate)
library(readr)

#Busco a página e defino na variavel "webpage"
webpage <- read_html("https://www.nytimes.com/interactive/2017/06/23/opinion/trumps-lies.html")
webpage

#Com a variavel "webpage", dou split nas informações
results <- webpage %>% 
              html_nodes(".short-desc")

records <- vector("list", length = length(results))


for (i in seq_along(results)) {
    date <- mdy(str_c(results[i] %>% 
                    html_nodes("strong") %>% 
                    html_text(trim = TRUE), ', 2017'))

    
    lie <- str_sub(xml_contents(results[i])[2] %>% html_text(trim = TRUE), 2, -2)
    
    explanation <- str_sub(results[i] %>% 
                             html_nodes(".short-truth") %>% 
                             html_text(trim = TRUE), 2, -2)
    
    url <- results[i] %>% html_nodes("a") %>% html_attr("href")
    
    records[[i]] <- data_frame(date = date, lie = lie, explanation = explanation, url = url)   
    
}

df <- bind_rows(records)

#Com o dataframe posso gerar o arquivo csv
write_csv(df, "mentiras_trump.csv")

#Tambem posso mostrar em tela o resultado do dataframe
df