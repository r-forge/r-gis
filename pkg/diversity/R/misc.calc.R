
#################################################
# percentile computation functions, adapted from
# SAS Procedures Guide, Version 6, 3rd ed., 625f.
# Ralf Herold, ralf herold at charite.de, 17.10.2000 18:42:04
misc.calc.percentiles <- function (x, p = c(5,10,25,50,75,95), pctldef = 5) {
  # initialization lacking error checking
  x <- na.omit (as.vector (x)) # transform input into non-empty vector
  p <- na.omit (as.vector (p)) # wanted percentiles into non-empty vector
  x <- sort    (x)             # sort it in ascending order
  n <- length  (x)             # length of non-empty vector
  
  if (pctldef == 4) n <- n + 1 # increase n by one in case pctldef == 4
  
  j <- trunc   (n * p / 100)   # j is the integer part of the product n * p
  g <- - j   + (n * p / 100)   # g is the fractional part of the product n *p
  
  # the different computational procedures follow
  
  if (pctldef == 1)            # weighted average at x\sub{np}
                               # x\sub{0} is taken to be x\sub{1}, cf. above
    perc <- (1 - g) * x [j] + g * x [j + 1]
  
  if (pctldef == 2)  {         # observation number closest to np
    i <- ifelse (g == 0.5,
		 ifelse (trunc (j / 2) == j / 2, j, j + 1),
		 trunc  (n * p / 100 + 0.5))
    perc <- x [i]}
  
  if (pctldef == 3)            # empirical distribution function
    perc <- x [ifelse (g == 0, j, j + 1)]
  
  if (pctldef == 4)            # weighted average aimed at x\sub{p*(n+1)}
                               # x\sub{n+1} is taken to be x\sub{n}, cf.above
    perc <- (1 - g) * x [j] + g * x [j + 1]
  
  if (pctldef == 5)            # empirical distribution function with averaging
    perc <- ifelse (g == 0, (x [j] + x [j + 1]) / 2,  x [j + 1])
  
  names  (perc) <- p
  return (perc)
}
#########################################################################
# for testing:
#test.x <- c (1,2,3,4,5,6,7,8,9,4,2,3,6,7,8,2,5,2)
#test.p <- c (26, 51)
#for (i in 1:5) print (misc.calc.percentiles (test.x, test.p, i))
# end.