# Author: Yann Chemin
# IRRI
# License GPL3
# Version 1, October 2008


rs.lswi<-function(nirchan, swirchan)
 #LSWI: Land Surface Water Index
{
	result<- (nirchan - swirchan) / (nirchan + swirchan)
	result[is.nan(result)] <- NA
	return(result)
}


