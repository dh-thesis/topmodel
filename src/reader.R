source("src/preprocess.R")

read.data <- function(fp, fp.pattern = ".txt") { # , x = 10

    print("collecting files...")
    raw_src <- DirSource(fp, pattern = fp.pattern)

    # extract file names from full paths
    fname <- sapply(strsplit(raw_src$filelist,"/"), function(x) x[[length(x)]])

    # get file name without ending
    rname <- sapply(strsplit(fname, ".",fixed = T), function(x) x[[1]])

    print("read files and create corpus...")
    corpus <- VCorpus(raw_src)

    print("preprocess corpus...")
    corpus <- prepare_corpus(corpus)

    # create document term matrix
    print("create document term matrix...")
    dtm <- DocumentTermMatrix(corpus)

    # remove empty documents
    dtm <- dtm[row_sums(dtm) > 0,]

    print("success!")
    return(dtm)

}


delete_freq_terms <- function(doc_term, x = 100) {

    # get frequency of terms
    terms.freq <- sort(col_sums(dtm), decreasing=T)

    # delete x most frequent terms
    dtm <- dtm[,setdiff(dtm$dimnames$Terms, names(terms.freq[1:x]))]

    return(dtm)

}

library(readr)

read_raw <- function(x) {
    csv_raw <- read_delim(
        x,
        ",",
        escape_double = FALSE,
        col_types = cols(
            Id = col_character(),
            Label = col_character(),
            Year = col_character(),
            Genre = col_character(),
            Lang = col_character(),
            Identifier = col_character(),
            IdentifierType = col_character(),
            Context = col_character()),
        trim_ws = TRUE
    )
    return(csv_raw)
}
