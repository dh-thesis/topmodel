library(tm)
library(stopwords)

prepare_corpus <- function(corp) {
    corp <- tm_map(corp, content_transformer(tags))
    corp <- tm_map(corp, removePunctuation)
    corp <- tm_map(corp, removeNumbers)
    corp <- tm_map(corp, content_transformer(tolower))
    corp <- tm_map(corp, function(x) removeWords(x, stopwords("english")))
    corp <- tm_map(corp, stripWhitespace)
    corp <- tm_map(corp, content_transformer(trim))
    return(corp)
}

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# returns string w/o html tags
tags <- function (x) gsub("<.*?>", "", x)

# remove punction marks
pnct <- function (x) gsub("[[:punct:]]"," ")

# remove control characters
cntrl <- function (x) gsub("[[:cntrl:]]"," ")
