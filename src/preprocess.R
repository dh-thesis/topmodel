library(tm)
library(stopwords)

prepare_corpus <- function(corp) {
    corp <- tm_map(corp, content_transformer(tags))
    corp <- tm_map(corp, content_transformer(tolower))
    corp <- tm_map(corp, function(x) removeWords(x, c(stopwords("english"), "")))
    corp <- tm_map(corp, content_transformer(pnct))
    # corp <- tm_map(corp, removePunctuation)
    corp <- tm_map(corp, content_transformer(cntrl))
    # corp <- tm_map(corp, content_transformer(grph))
    corp <- tm_map(corp, content_transformer(dgts))
    # corp <- tm_map(corp, removeNumbers)
    corp <- tm_map(corp, content_transformer(alph))
    corp <- tm_map(corp, stripWhitespace)
    corp <- tm_map(corp, content_transformer(trim))
    return(corp)
}

# remove html tags
tags <- function (x) gsub("<.*?>", "", x)

# remove punction marks
pnct <- function (x) gsub("[[:punct:]]"," ", x)

# remove control characters (between 0x00 and 0x1F as well as 0x7F (DEL))
cntrl <- function (x) gsub("[[:cntrl:]]"," ", x)

# remove non-graphical characters (between 0x20 and 0x7E)
grph <- function (x) gsub("[^[:graph:]]"," ", x)

# remove all digits
dgts <- function(x) gsub("[[:digit:]]"," ",x)

# remove all non-alphabetic characters (except whitespaces)
alph <- function(x) gsub("[^ [:alpha:]]"," ",x)

# remove leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
