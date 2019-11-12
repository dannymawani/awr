#libraries
library(tidyverse) ; library(httr) ; library(jsonlite) ; library(readxl)

awrTopsites <- function(token,project,start,end){
path <- "https://api.awrcloud.com/v2/get.php?"

#request
request <- GET(url = path, 
               query = list(
                 action = "topsites_export",
                 project ="carlras",
                 token = token,
                 startDate = start,
                 stopDate = end
                 
               )
)

#validate request
request$status_code

#get response
response <- content(request, as = "text", encoding = "UTF-8")

#create df
df <- fromJSON(response, flatten = TRUE) %>% 
  data.frame()


#report url
download <- as.character(df$details)

#download
download.file(download, "download.zip")

#unzip
unzip("download.zip")
}

#api setup
token <- "yourapitoken"
start <- Sys.Date()-31
end <- Sys.Date()-1
project <- "theidofyourproject"

awrTopsites(token,project,start,end)


#load and merge files
files <- list.files(path = ".", pattern = "*.csv", full.names = T)
tbl <- sapply(files, read_csv, simplify=FALSE)
tbl <- bind_rows(tbl)

tbl <- tbl%>%
  select(
    Keyword,
    Position,
    URL
  )
