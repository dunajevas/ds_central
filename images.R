getImageFeatures <- function(link){
  cc <- try(download.file(link, destfile="/tmp/jpegtmp.img"), silent=TRUE)
  if(class(cc)!='try-error'){
    if(grepl('\\.jpeg', link))
      jj <- readJPEG("/tmp/jpegtmp.img")
    if(grepl('\\.png', link))
      jj <- readPNG("/tmp/jpegtmp.img")
    list(x=c(jj), link)
  }
}
links <- unique(out$imglink)

lx <- lapply(links, getImageFeatures)
View(subset(out, imglink=='http://api.ning.com:80/files/UIcaShGmttF-CuRR4gptssh8PymhhbHM5udWmrSRBm2GXNRT8wvmUWMfPDA6ZHj6ROj2-kDcscXHdavyEb69BcC6xTUuy7*K/866209901.jpeg?width=64&height=64&crop=1%3A1'))
not.null <- !sapply(lx,  function(item) is.null(item[['x']]))
x <- matrix(0, ncol=sum(not.null), nrow=length(lx[[1]][['x']]))
sapply(lx, function(x) (length(x[['x']])))
x <- do.call(cbind, lapply(lx[not.null], "[[", "x"))


