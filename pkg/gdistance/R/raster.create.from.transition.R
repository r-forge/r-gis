`raster.create.from.transition` <-
function(transition)
{
if(transition@zerorowcol == TRUE)
{raster <- new("raster",
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
	{raster <- new("raster",
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
)
raster@data[as.integer(transition@transitionmatrix@Dimnames[[1]])] <- colSums(as(transition,"dsCMatrix"))
}
return(raster)
}

