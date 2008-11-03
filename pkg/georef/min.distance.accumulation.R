`min.distance.accumulation` <-
function(gendistance,nsimulations)
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

