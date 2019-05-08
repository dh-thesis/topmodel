source("src/reader.R")
source("src/modeling.R")

# set path to data files
fp <- '../pubdata/data/titles/mpis--eng'
out <- './docs/vis/eng/mpi_t100'
k <- 100

# get document term matrix (dtm)
dtm <- read.data(fp)

# fit model for documents of dtm
topmod <- fit.model(dtm, k)

# create topic map
model.vis(topmod, dtm, vis.dir = out)

# stop the server
servr::daemon_stop()
