`cluster.parameters.difference` <-
function(gendistance,cluster.distance,k,significance.perm,accuracy.perm)
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

