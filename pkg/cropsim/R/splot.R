
splot <- function(x) {
	x <- as.data.frame(x)
#	attach(x)
	plot(x$day, x$sites, ylim=c(0, 100),  ylab="% of sites")
	points(x$day, x$diseased, col="gray")
	points(x$day, x$removed, col="blue")
	points(x$day, x$latent, col="red")
	points(x$day, x$infectious,  col="green")
	legend(0, 60, c("sites", "diseased", "removed", "latent", "infectious"), col=c("black", "gray", "blue", "red", "green"), pch=21)
#	detach(x)
}	
