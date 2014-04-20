library(jpeg)
library(png)
library(ggplot2)
library(jsonlite)
library(e1071)
out <- fromJSON("out.json")
getImageFeatures <- function(link){
  cc <- try(download.file(link, destfile="/tmp/jpegtmp.img"), silent=TRUE)
  if(class(cc)!='try-error'){
    if(grepl('\\.jpeg|\\.bin|\\.jpg', link))
      jj <- readJPEG("/tmp/jpegtmp.img")
    if(grepl('\\.png', link))
      jj <- readPNG("/tmp/jpegtmp.img")
    # convert to grayscale
    # http://www.johndcook.com/blog/2009/08/24/algorithms-convert-color-grayscale/
    # lightness method
    if(is.array(jj))
      jj <- apply(jj, 1:2, function(x) (min(x)+max(x))/2)
    list(x=c(jj), link)
  }
}

lx <- lapply(unique(out$imglink), getImageFeatures)
save(lx, file='lx.Rdata')
not.null <- !sapply(lx,  function(item) is.null(item[['x']]))
which.min(colSums(x))
x <- matrix(0, ncol=sum(not.null), nrow=length(lx[[1]][['x']]))
x <- do.call(cbind, lapply(lx[not.null], "[[", "x"))
fit <- svm(x=t(x), type='one-classification', cost=0.001)
fit
View(data.frame(sapply(lx[not.null], function(l) l[[2]]),
                predict(fit)))

predict(fit)
