`raster.potential.single.origin.single.destination` <-
function(transition,origin.xy,goal.xy)
{
origin.cell <- raster.get.cell.from.xy(transition, origin.xy)
goal.cell <- raster.get.cell.from.xy(transition, goal.xy)
L <- Laplacian(transition)
Lr <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
n <- max(Lr@Dim)
e <- matrix(0, ncol=1, nrow=n)
rownames(e) <- rownames(transition)[1:n]
e[as.character(origin.cell),] <- 1 
e[as.character(goal.cell),] <- -1
x <- solve(Lr,e) 
x <- as.vector(x)
Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
Lplusallrows <- Lplusallrows - min(Lplusallrows)
names(Lplusallrows) <- as.character(rownames(transition@transitionmatrix))
return(Lplusallrows)
}

