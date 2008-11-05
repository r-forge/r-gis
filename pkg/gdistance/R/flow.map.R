flow.map <-
function(origin.xy,goal.xy,transition)
{
	origin.cell <- raster.get.cell.from.xy(transition, origin.xy)
	goal.cell <- raster.get.cell.from.xy(transition, goal.xy)
	L <- Laplacian(transition)
	Lr <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
	A <- as(L,"lMatrix")
	A <- as(A,"dMatrix")
	n <- max(Lr@Dim)
	e <- matrix(0, ncol=1, nrow=n)
	rownames(e) <- rownames(transition@transitionmatrix)[1:n]
	e[as.character(origin.cell),] <- 1 
	e[as.character(goal.cell),] <- -1
	x <- solve(Lr,e) 
	x <- as.vector(x)
	Lplusallrows <- c(x-sum(x/(n+1)),(sum(x)/(n+1)))
	V <- A * Lplusallrows
	d <- t(t(A) * diag(V))
	V <- - V + d
	Current <- colSums(abs(V)*-L)/2

	if(transition@zerorowcol == TRUE)
	{
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
		yres = transition@yres,
		raster@data <- colSums(as("dsCMatrix",transition)))
	}
	if(transition@zerorowcol == FALSE)
	{
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
		yres = transition@yres,
		data = as.array(rep(NA,times=transition@ncells))
	}

	datavector <- vector(length=length(raster@data))
	datavector[as.integer(rownames(transition@transitionmatrix))] <- Current
	raster@data <- as.array(datavector)
	return(raster)
}

