source("src/reader.R")
source("src/modeling.R")

# set path to data files
# fp <- '../titles/data/mpis-eng-years'
# fp <- '../titles/data/cats-eng-years'
fp <- '../titles/data/mpis-eng-years-genre'

# set path for visualization output
# out <- './docs/vis/eng/mpi2012_t50'
# out <- './docs/vis/eng/mpi2015_t20_new-corpus'
# out <- './docs/vis/eng/eth_t20-2_new-corpus'
out <- './docs/vis/eng/mpi2017articles_t20_new-corpus'

# number of topics
# k <- 50
k <- 20

# pattern to filter data files
# pattern <- '.txt' # 'eng_201'
# pattern <- '2015.txt'
# pattern <- 'ou_907574_eng_' # 'eng_201'
# pattern <- '2010.txt' # 'eng_201'
pattern <- 'ARTICLE_2017.txt' # 'eng_201'
# get document term matrix (dtm)
dtm <- read.data(fp, fp.pattern = pattern)
# fit model for documents of dtm
topmod <- fit.model(dtm, k)
# create topic map
model.vis(topmod, dtm, vis.dir = out)
# stop the server
servr::daemon_stop()

csv_fp <- '../data/tables/publications.csv'
csv_raw <- read_raw(csv_fp)
csv_data <- subset(csv_raw, LANG=="eng")
csv_data <- subset(csv_data, YEAR=="2017")

mpis_idx <- unique(csv_data$OU)

title_data <- c()

for(mpi in mpis_idx) {
    mpi_titles <- subset(csv_data, OU==mpi)
    # next step creates a single document for all titles of mpi
    # comment it out if you want a document per title
    mpi_titles <- paste(mpi_titles$TITLE, collapse = " ")
    names(mpi_titles) <- mpi
    title_data <- c(title_data, as.vector(mpi_titles))
}

vs <- VectorSource(title_data)
corpus <- VCorpus(vs)
corpus <- prepare_corpus(corpus)
dtm <- DocumentTermMatrix(corpus)
dtm$dimnames$Docs <- mpis_idx
dtm <- dtm[row_sums(dtm) > 0,]

k <- 50
topmod <- fit.model(dtm, k)
out <- './docs/vis/eng/mpi2017_t50new'
model.vis(topmod, dtm, vis.dir = out)
servr::daemon_stop()

# dataset = as.matrix(dtm)
# v = sort(colSums(dataset),decreasing=TRUE)
# myNames = names(v)
# d = data.frame(word=myNames,freq=v)

# pattern <- '.txt'
# fp <- './data/mpis--eng/201_years/2012'
# raw_src <- DirSource(fp, pattern = pattern)
# txt_corpus <- VCorpus(raw_src)
# txt_corpus <- prepare_corpus(corpus)
