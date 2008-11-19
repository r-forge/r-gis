na.omit.dist <- function(dataframe)
{
    n.dist <- length(dataframe)
	n.cases <- length(dataframe[[1]])
	n <- round(optimize(function(n) ( abs(n^2 -n - 2*n.cases)), interval = c(0, n.cases*3))[[1]])
	i <- rep(1:n,times=n)
	j <- rep(1:n,each=n)
	ij <- cbind(i,j)
	ij <- subset(ij,ij[,1]>ij[,2])
    index <- NULL
    for (i in 1:n.dist) 
	{
        dist.vector <- dataframe[[i]]
		dist.matrix <- matrix(ncol=n,nrow=n)
		dist.matrix[ij] <- dist.vector
		dist.matrix <- as.matrix(as.dist(dist.matrix))
        na.by.col <- apply(dist.matrix, 1, function(x) {sum(is.na(x))})
        index <- c(index, which(na.by.col >= n - 1))
    }
    index <- unique(index)
	var.names <- paste("v_",colnames(dataframe))
	for (i in 1:n.dist)
	{
		dist.vector <- dataframe[[i]]
		dist.matrix <- matrix(ncol=n,nrow=n)
		dist.matrix[ij] <- dist.vector
		dist.matrix <- as.matrix(as.dist(dist.matrix))
		assign(var.names[i],as.dist(dist.matrix[-index, -index]))
	}
	result <- as.data.frame(matrix(unlist(mget(var.names,envir=environment(),inherits=TRUE)),ncol=n.dist))
	colnames(result) <- colnames(dataframe)
	return(result)
}