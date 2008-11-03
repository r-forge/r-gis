#FUNCTIONS

min.distance.accumulation <- function(gendistance,nsimulations)
{
	gendistance <- as.matrix(gendistance)
	nsamples <- length(gendistance[,1])
	index <- cbind(rep(1:nsamples, times=nsamples),rep(1:nsamples, each=nsamples))
	index1 <- subset(index,index[,1]<=index[,2])
	index2 <- subset(index,index[,1]>index[,2])
	min.distance.accumulation <- matrix(nrow=nsimulations,ncol=nsamples)
	for (i in 1:nsimulations)
	{
		order <- sample(nsamples)
		gendistance.reordered <- gendistance[order,order]
		gendistance.reordered[index1] <- max(gendistance)+1
		gendistance.reordered[1,1] <- 0
		min.distance <- apply(gendistance.reordered,1,min)
		min.distance.accumulation.matrix <- matrix(min.distance,nrow=length(min.distance),ncol=length(min.distance))
		min.distance.accumulation.matrix[index2] <- 0
		min.distance.accumulation[i,] <- colSums(min.distance.accumulation.matrix)
	}
	return(colSums(min.distance.accumulation)/nsimulations)
}

power.model1 <- function(x,min.distance.accumulation)
{
	parameters <- coef(nls(min.distance.accumulation ~ x^pow + 0, start = c(pow=0.9), alg = 'port', trace = FALSE))
	return(parameters)
}

power.model2 <- function(x,min.distance.accumulation)
{
	d <- as.data.frame(cbind(min.distance.accumulation,x))
	d <- subset(d,d[,1] != 0)
	lin.model <- lm(log(min.distance.accumulation) ~ x + 1, data=d)
	parameters <- coefficients(lin.model)
	return(parameters)
}

cluster.parameters <- function(gendistance,clusters,accuracy)
{
	parameters.per.cluster <- vector(length=max(clusters))
	for (cluster in 1:max(clusters))
	{
		selection <- names(clusters[clusters==cluster])
		if(length(selection)>3)
		{
			gendistance.selection <- as.matrix(gendistance)[selection,selection]
			mda <- min.distance.accumulation(gendistance.selection,accuracy)
			x <- (0:(length(mda)-1))*mean(as.dist(gendistance.selection))
			parameters.per.cluster[cluster] <- power.model1(x,mda)
		}		
	}
	return(parameters.per.cluster)
}

cluster.parameters.difference <- function(gendistance,cluster.distance,k,significance.perm,accuracy.perm)
{
	cluster.tree <- hclust(cluster.distance, method = "ward")
	clusters <- cutree(cluster.tree,k=k)
	cp.reference <- cluster.parameters(gendistance,clusters,accuracy.perm)
	cp.permutation <- matrix(nrow=significance.perm,ncol=max(clusters))
	for (i in 1:significance.perm)
	{
		clusters.permuted <- sample(clusters)
		names(clusters.permuted) <- names(clusters)
		cp.permutation[i,] <- cluster.parameters(gendistance,clusters.permuted,accuracy.perm)
	}
	signif <- (rowSums(apply(cp.permutation,1,function(x){x<cp.reference}))+1)/(significance.perm+1)
	size <- tabulate(clusters)
	return(cbind(signif,size,cp.reference))
}