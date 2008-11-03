`gene.reformat` <-
function(data) #Reformats SSR data with alleles in different columns to a three column format.
{
if (ncol(data)>3)
{
ncol.alleles <- ncol(data)-2
reformatted <- cbind(rep(data[,1],times=ncol.alleles),rep(data[,2],times=ncol.alleles),as.vector(as.matrix(data[,3:ncol(data)])))
}
else (reformatted <- data)
colnames(reformatted) <- c("Accession", "Marker", "Allele")
return(reformatted)
}

