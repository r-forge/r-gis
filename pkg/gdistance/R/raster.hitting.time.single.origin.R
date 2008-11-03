`raster.hitting.time.single.origin` <-
function(transition,origin.xy)
{
cat("Progress Bar", "\n")
cat("---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|","\n")
L <- Laplacian(transition)
Lr <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
n <- max(Lr@Dim)
djj <- diag(L)
ldj <- rep(0, times=(n+1)) #destination (d) to all cells (j)
ldd <- rep(0, times=(n+1)) #destination to destination
loj <- 0 #origin (o) to all cells
lod <- rep(0, times=(n+1)) #origin to destination
origin.cell <- raster.get.cell.from.xy(transition, origin.xy)
originindex <- match(origin.cell, rownames(transition@transitionmatrix))
count <- 0
onepercent <- n/100
if (length(originindex)<1 | length(originindex)>1) {cat("Ambiguous or non-existing origin.","\n"); stop}
for (i in 1:n)
{
ei <- matrix((-1/(n+1)), ncol=1, nrow=n)
ei[i] <- 1-(1/(n+1)) 
xi <- solve(Lr,ei) 
xi <- as.vector(xi)
Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
ldj[i] <- sum(Lplusallrows*djj)
ldd[i] <- Lplusallrows[i]*sum(djj)
count <- count+1
if(count>=onepercent) {cat("|"); count<-count-onepercent}
}
cat("|","\n")
e <- matrix((-1/(n+1)), ncol=1, nrow=n)
e[originindex,] <- 1-(1/(n+1)) 
x <- solve(Lr,e) 
x <- as.vector(x)
Lplusallrows <- c(x-sum(x/(n+1)),(sum(x)/(n+1)))
loj <- sum(Lplusallrows*djj)
lod <- Lplusallrows*sum(djj)
AFPT <- (loj - lod - ldj + ldd)
AFPT[n+1] <- AFPT[which(L[,n+1]<0)[1]]
raster <- new("raster",
projection = transition@projection,
ncols = transition@ncols,
nrows = transition@nrows,
ncells = transition@ncells,
xmin = transition@xmin,
xmax = transition@xmax,
ymin = transition@ymin,
ymax = transition@ymax,
xres = transition@xres,
yres = transition@yres)
datavector <- vector(length=raster@ncells)
datavector[as.integer(rownames(transition@transitionmatrix))] <- AFPT
raster@data <- as.array(datavector)
return(raster)
}

