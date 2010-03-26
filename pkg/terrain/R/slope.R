# Author: Robert J. Hijmans, r.hijmans@gmail.com
# Date : February 2010
# Version 0.9
# Licence GPL v3



if (!isGeneric("slope")) {
	setGeneric("slope", function(x, ...)
		standardGeneric("slope"))
}	


setMethod('slope', signature(x='RasterLayer'), 

function(x, filename="", type='slope', ...) {


funX <- function(x) { x * c(-1,-2,-1,0,0,0,1,2,1) }
funY <- function(x) { x * c(-1,0,1,-2,0,2,-1,0,1) }

# Xfilter=matrix(c(-1,-2,-1,0,0,0,1,2,1), nrow=3)
# Yfilter=matrix(c(-1,0,1,-2,0,2,-1,0,1), nrow=3)

#dzx = focalFilter(r, EWfilter)
#dzy = focalFilter(r, NSfilter)

#xdim = 90000
#ydim = 90000

#slope = sqrt( (dzy/ydim)^2 + (dzx/xdim)^2 )
#degslope = slope * 90
#aspect = atan( (dzy/ydim) / (dzx/xdim) )  / (pi / 180))

	
	ngb <- c(3,3)
	type = tolower(type)
	if (! type %in% c('both', 'slope', 'aspect')) stop("type must be 'both', 'slope', or 'aspect'")
	
	out <- raster(x)
	nrows = ngb[1]
	
	add1 = matrix(0, ncol=1, nrow=3)
	add2 = matrix(0, ncol=1, nrow=3)

	nrs = matrix(ncol=ncol(out), nrow=ngb[1])
	nrs[] = 1:length(nrs)
	nrs = cbind(add1, nrs, add2)
	  
	idx = matrix(ncol=ncol(out), nrow=prod(ngb))
	cc = 1:ngb[2]
	for (c in 1:ncol(out)) {
		idx[,c] = nrs[,cc] 
		cc = cc + 1
	}
	id = as.vector(idx)
	id = cbind(rep(1:ncol(out), each=nrow(idx)), id)
	id = subset(id, id[,2]>0)
	
	filename <- trim(filename)
	inmem = TRUE
	if (!canProcessInMemory(out, 3) && filename == '') {
		filename <- rasterTmpFile()
		inmem = FALSE
								
	}
	if (inmem) {
		v = matrix(nrow=ncol(out), ncol=nrow(out))		
	} else {
		out <- writeStart(out, filename=filename, ...)
	}

	fun = function(x) length(unique(x)) != 1

	pb <- pbCreate(nrow(out), type=.progress(...))
	ngbdata = matrix(nrow=ngb[1], ncol=ncol(x))
	rr = 0
	for (r in 1:row1) {
		rr = rr + 1
		d = getValues(x, rr)
		if (! classes) {
			d[!is.na(d)] <- 1
		} else {
			d = round(d)
		}
		ngbdata[rr,] <- d
	}
	for (r in 1:nrow(out)) {	
		rr = rr + 1
		if (rr <= ngb[1]) {
			d = getValues(x, rr)
			if (! classes) {
				d[!is.na(d)] <- 1
			} else {
				d = round(d)
			}
			ngbdata[rr,] <- d
			ids = matrix(as.vector(idx), nrow=ngb[1])
			ids = ids[1:rr, ]
			ids = matrix(as.vector(ids), ncol=ncol(out))
			ids = cbind(rep(1:ncol(out), each=nrow(ids)), as.vector(ids))
			ids = subset(ids, ids[,2]>0)
			vv = tapply(as.vector(ngbdata)[ids[,2]], ids[,1], fun)
			if (type == 'inner') {
				vv[is.na(ngbdata[1,])] = 0
			} else if (type == 'outer') {
				vv[! is.na(ngbdata[1,])] = 0
			}
			if (asNA) {		
				if (asZero) {
					vv[vv==0 & is.na(ngbdata[1,])] = NA 	
				} else {
					vv[vv==0] = NA 					
				}
			}
			
			
		} else if (r <= (nrow(out)-row1)) {
			ngbdata[1:(ngb[1]-1), ] <- ngbdata[2:(ngb[1]), ]
			d = getValues(x, rr)
			if (! classes) {
				d[!is.na(d)] <- 1
			} else {
				d = round(d)
			}
			ngbdata[ngb[1],] <- d
			vv = tapply(as.vector(ngbdata)[id[,2]], id[,1], fun)
			if (type == 'inner') {
				vv[is.na(ngbdata[2,])] = 0
			} else if (type == 'outer') {
				vv[! is.na(ngbdata[2,])] = 0
			}
			if (asNA) {		
				if (asZero) {
					vv[vv==0 & is.na(ngbdata[2,])] = NA 	
				} else {
					vv[vv==0] = NA 					
				}
			}
			
		} else {
			ngbdata[1:(ngb[1]-1), ] <- ngbdata[2:(ngb[1]), ]
			ngbdata[nrows,] = NA
			nrows=nrows-1
			ids = matrix(as.vector(idx), nrow=ngb[1])
			ids = ids[1:nrows, ]
			ids = matrix(as.vector(ids), ncol=ncol(out))
			ids = cbind(rep(1:ncol(out), each=nrow(ids)), as.vector(ids))
			ids = subset(ids, ids[,2]>0)
			vv = tapply(as.vector(ngbdata)[ids[,2]], ids[,1], fun)
			if (type == 'inner') {
				vv[is.na(ngbdata[1,])] = 0
			} else if (type == 'outer') {
				vv[! is.na(ngbdata[1,])] = 0		
			} 
			if (asNA) {		
				if (asZero) {
					vv[vv==0 & is.na(ngbdata[1,])] = NA 	
				} else {
					vv[vv==0] = NA 					
				}
			}			
		}
		
		if (inmem) {
			v[,r] <- vv
		} else {
			writeValues(out, vv, r)
		}
		pbStep(pb, r)
	}

	pbClose(pb)

	if (inmem) { 
		out <- setValues(out, as.vector(v)) 
		if (filename != "") {
			out <- writeRaster(out, filename, ...)
		}
	} else {
		out <- writeStop(out)
	}
	return(out)
}

)	

