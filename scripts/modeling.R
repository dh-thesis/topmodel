library(slam)
library(servr)
library(topicmodels)
library(LDAvis)
library(tsne)

fit.model <- function(doc_term, k) {

    print("fit model...")
    t1 <- Sys.time()

    fitted.model <- LDA(doc_term, k, control=list(alpha=0.1))
    print("done!")

    t2 <- Sys.time()
    elapsed <- difftime(t2, t1, units="mins")
    print(paste("time elapsed:",round(elapsed,2),"min"))

    return(fitted.model)

}

model.vis <- function(fitted.model, doc_term, vis.dir="./public/vis") {
    
    print("set variables...")

    phi <- as.matrix(posterior(fitted.model)$terms)
    theta <- as.matrix(posterior(fitted.model)$topics)

    vocab <- colnames(phi)

    term_freq <- slam::col_sums(doc_term)
    
    # while calculating model based on institutes' titles -->
    # Error in stats::cmdscale(dist.mat, k = 2) :
    # NA values not allowed in 'd' 
    svd_tsne <- function(x) tsne::tsne(svd(x)$u)
    
    print("create visualization...")

    json_lda <- LDAvis::createJSON(phi = phi,
                                   theta = theta,
                                   vocab = vocab,
                                   mds.method = svd_tsne,
                                   doc.length = as.vector(table(doc_term$i)),
                                   term.frequency = term_freq)
    
    print("start server...")
    
    serVis(json_lda, out.dir = vis.dir, open.browser = TRUE, encoding="UTF-8")
    
    print("success!")

}

fit.model.vis <- function(doc_term, k, vis.dir="./public/vis"){

    fitted.model <- fit.model(doc_term, k)

    model.vis(fitted.model, doc_term, vis.dir)

}
