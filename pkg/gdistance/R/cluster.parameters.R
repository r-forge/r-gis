`cluster.parameters` <-
function(gendistance,clusters,accuracy)
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

