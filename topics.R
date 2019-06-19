source("src/reader.R")
source("src/modeling.R")

# set path to data files
# fp <- '../pubdata/data/corpus/titles/cat--deu'
# fp <- '../pubdata/data/corpus/titles/mpis--eng--years'
fp <- './data/mpis--eng/201_years/2017'

# set path for visualization output
out <- './docs/vis/eng/mpi2017_t20'

# number of topics
k <- 20

# pattern to filter data files
pattern <- '.txt' # 'eng_201'

# get document term matrix (dtm)
dtm <- read.data(fp, fp.pattern = pattern)

# fit model for documents of dtm
topmod <- fit.model(dtm, k)

# create topic map
model.vis(topmod, dtm, vis.dir = out)

# stop the server
servr::daemon_stop()
