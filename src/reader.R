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
