`power.model2` <-
function(x,min.distance.accumulation)
{
d <- as.data.frame(cbind(min.distance.accumulation,x))
d <- subset(d,d[,1] != 0)
lin.model <- lm(log(min.distance.accumulation) ~ x + 1, data=d)
parameters <- coefficients(lin.model)
return(parameters)
}

