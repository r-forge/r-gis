`na.omit.dist` <-
function(object, ...)
{
dist.stack <- list(...)
n.dist <- length(dist.stack)
index <- NULL
for (i in 1:n.dist)
{
dist <- as.matrix(dist.stack[[i]])
na.by.col <- apply(dist, 1, function(x){sum(is.na(x))})
index <- c(index,which(na.by.col>=length(dist[,1])-1))
}
index <- unique(index)
return(as.dist(as.matrix(object)[-index,-index]))
}

