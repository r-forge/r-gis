Laplacian <- function(transition) 
{
transition.dsC <- as(transition,"dsCMatrix")
Laplacian.dsC <- Diagonal(x = colSums(transition.dsC)) - transition.dsC
return(Laplacian.dsC)
}

