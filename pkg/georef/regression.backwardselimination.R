`regression.backwardselimination` <-
function (forml, signlevel=0.05, permutations=99, method="raw") #This assumes that elements in the formula are globally available #TODO Method: forward, stepwise
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

