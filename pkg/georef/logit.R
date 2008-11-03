`logit` <-
function(x)
{
if (0 %in% x | 1 %in% x) {l <- log(x*0.95+0.025);warning("Proportion remapped to (0.025, 0.975).")} 
else (l <- log(x/(1-x)))
return(l)
}

