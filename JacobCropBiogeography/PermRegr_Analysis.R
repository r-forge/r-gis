#FUNCTIONS

logit <- function(x)
{
	if (0 %in% x | 1 %in% x) {l <- log(x*0.95+0.025);warning("Proportion remapped to (0.025, 0.975).")} 
	else (l <- log(x/(1-x)))
	return(l)
}

na.omit.dist <- function(object, ...)
{
	dist.stack <- list(...)
	n.dist <- length(dist.stack)
	index <- NULL
	for (i in 1:n.dist)
	{
		dist <- as.matrix(dist.stack[[i]])
		na.by.col <- apply(dist, 1, function(x){sum(is.na(x))})
		index <- c(index,which(na.by.col>=length(dist[,1])-1))
	}
	index <- unique(index)
	return(as.dist(as.matrix(object)[-index,-index]))
}

regression.backwardselimination <- function (forml, signlevel=0.05, permutations=99, method="raw") #This assumes that elements in the formula are globally available #TODO Method: forward, stepwise
{
	forml <- as.formula(forml)
	formterms <- rownames(attr(terms(forml,keep.order = TRUE), "factors"))[2:length(rownames(attr(terms(forml), "factors")))]
	dummy <- rep(1, times = (length(formterms)))
	names(dummy) <- formterms
	newstep <- TRUE
	while (newstep == TRUE)
	{
		formulatotest <- as.formula(paste(forml[[2]], " ~ ",paste(formterms[which(dummy==1)], collapse = " + ")))
		regrresult <- permregression(formulatotest, permutations, method=method)
		signterms <- regrresult$significance.terms
		cat("R2: ",regrresult$r.squared,"\n")
		cat("p value of R2: ", regrresult$significance.r,"\n")
		cat("p values of variables: ", signterms,"\n")
		i <- which(signterms==max(signterms) & signterms >= signlevel/sum(dummy))
		if (length(i)>1) {warning("Least significant variable (highest p) could not be identified. Try more permutations."); i <- i[1]}
		if (length(i)==0) {cat("All remaining variables are significant.","\n"); newstep <- FALSE}
		if (sum(dummy)<1) {cat("None of the remaining variables is significant. See if the significance levels and number of permutations are appropriate.","/n"); newstep <- FALSE}
		if (length(i)==1) {cat("Variable dropped: ", formterms[which(dummy==1)][i],"\n"); dummy[formterms[which(dummy==1)][i]] <- 0}
	}
	cat("Final model:","\n")
	print(formulatotest)
	return(regrresult)
}

permregression <- function (forml, permutations = 99, method="residual") 
{
	forml <- as.formula(forml)
	reference.summary <- summary(lm(forml)) 
	formterms <- rownames(attr(terms(forml,keep.order = TRUE), "factors"))[2:length(rownames(attr(terms(forml), "factors")))] 
	begincoeff <- 2*(length(formterms)+1)+2
	endcoeff <- 3*(length(formterms)+1)	
	statistic <- c(reference.summary$r.squared,abs(reference.summary$coefficients[begincoeff:endcoeff])) #Reference statistic
	if (method=="raw")
	{
		y <- as.dist(get(rownames(attr(terms(forml,keep.order = TRUE), "factors"))[1]))
		N <- attributes(y)$Size
	}
	if (method=="residual")
	{
		y <- reference.summary$residuals
	}
	perm <- matrix(0, nrow = permutations, ncol = (length(formterms)+1))
	permformula <- as.formula(paste("permvec ~",paste(formterms, collapse="+"))) 
	for (i in 1:permutations) 
	{
		take <- sample(N,N)
		permvec <- as.dist(as.matrix(y)[take, take])
		perm.summary <- summary(lm(permformula))
		perm[i,] <- as.vector(c(perm.summary$r.squared,abs(perm.summary$coefficients[begincoeff:endcoeff]))) #Reports the R2 and partial t's for each lm permutation
	}
	signif <- (rowSums(apply(perm,1,function(x){x>statistic}))+1)/(permutations+1)  #The "+1"s of the formula are due to Hope (1968) who added the reference value itself to the distribution to make the test slightly more "conservative" (Legendre et al. 1994). TODO use apply
	result <- list(permutations=permutations,r.squared=statistic[1],significance.r=signif[1],significance.terms=signif[2:length(signif)])
	return(result)
}

# MAIN PROGRAM

all.var <- c("gendistance", 
		"resistance.distance", 
		"divergence.time", 
		"hitting.time.centrality.diff.unw", 
		"hitting.time.centrality.diff.w", 
		"hitting.time.centrality.overlap.unw", 
		"hitting.time.centrality.overlap.w", 
		"joint.trajectory.unw", 
		"joint.trajectory.w")

for (i in 1:length(all.var))
{
	assign(all.var[i],na.omit.dist(get(all.var[i]),gendistance,
	resistance.distance,
	divergence.time,
	hitting.time.centrality.diff.unw,
	hitting.time.centrality.diff.w,
	hitting.time.centrality.overlap.unw,
	hitting.time.centrality.overlap.w,
	joint.trajectory.unw,
	joint.trajectory.w))
}

regression.backwardselimination(gendistance ~ 
				resistance.distance + 
				divergence.time + 
				I(divergence.time * (max(resistance.distance)-resistance.distance)) + 
				hitting.time.centrality.diff.unw + 
				hitting.time.centrality.diff.w + 
				hitting.time.centrality.overlap.unw + 
				hitting.time.centrality.overlap.w + 
				joint.trajectory.unw + 
				joint.trajectory.w, permutations=999)

l.gendistance <- logit(gendistance)
l.hitting.time.centrality.overlap.unw <- logit(hitting.time.centrality.overlap.unw)
l.hitting.time.centrality.overlap.w <- logit(hitting.time.centrality.overlap.w)
l.joint.trajectory.unw <- logit(joint.trajectory.unw)
l.joint.trajectory.w <- logit(joint.trajectory.w)

regression.backwardselimination(l.gendistance ~ 
				resistance.distance + 
				divergence.time + 
				I(divergence.time * (max(resistance.distance)-resistance.distance)) + 
				hitting.time.centrality.diff.unw + 
				hitting.time.centrality.diff.w + 
				l.hitting.time.centrality.overlap.unw + 
				l.hitting.time.centrality.overlap.w + 
				l.joint.trajectory.unw + 
				l.joint.trajectory.w, permutations=999)
