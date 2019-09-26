source("src/reader.R") 

library(ldatuning)


# fp <- '../titles/data/mpis-eng-years-genre'
# pattern <- 'ou_907574_eng_ARTICLE'

fp <- '../titles/data/mpis-eng-years'
pattern <- 'ou_907574_eng'

dtm <- read.data(fp, fp.pattern = pattern)

tunes <- FindTopicsNumber(
    dtm,
    topics = c(2,5,10,15,20,25,30,40,50,100,150,200), # ,50,100,150,200),
    metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010","Deveaud2014"),
    method = "Gibbs",
    # control = list(seed = 23),
    verbose = TRUE
)



FindTopicsNumber_plot(tunes)
