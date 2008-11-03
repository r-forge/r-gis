`power.model1` <-
function(x,min.distance.accumulation)
{
parameters <- coef(nls(min.distance.accumulation ~ x^pow + 0, start = c(pow=0.9), alg = 'port', trace = FALSE))
return(parameters)
}

