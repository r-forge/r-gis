#PACKAGES

require(RODBC)
require(Matrix)

#FUNCTIONS

gene.reformat <- function(data) #Reformats SSR data with alleles in different columns to a three column format.
{
	if (ncol(data)>3)
	{
		ncol.alleles <- ncol(data)-2
		reformatted <- cbind(rep(data[,1],times=ncol.alleles),rep(data[,2],times=ncol.alleles),as.vector(as.matrix(data[,3:ncol(data)])))
	}
	else (reformatted <- data)
	colnames(reformatted) <- c("Accession", "Marker", "Allele")
	return(reformatted)
}

gene.distance.spa <- function(data,null.alleles="missing")
{
	data <- na.omit(data)
	if(null.alleles=="missing"){data <- subset(data,data[,3]!=0)}
	if(null.alleles=="unlike"){data[,3][data[,3]==0] <- seq(from=max(data[,3])+1,to=max(data[,3])+length(data[,3][genedata[,3]==0]))}
	if(null.alleles=="alike"){}
	accession.index <- unique(data[,1])
	marker.fragment <- paste(data[,2],data[,3],sep="-")
	marker.fragment.index <- unique(marker.fragment)
	i <- match(marker.fragment,marker.fragment.index)-1
	j <- match(data[,1],accession.index)-1
	x <- rep(1,times=length(data[,1]))
	Dim1 <- length(marker.fragment.index)
	Dim2 <- length(accession.index)
	data.matrix <- new("dgTMatrix", i = as.integer(i), j = as.integer(j), x = as.numeric(x), Dim = as.integer(c(Dim1,Dim2)))
	data.matrix <- as(data.matrix,"dgCMatrix")
	marker.index <- unlist(strsplit(marker.fragment.index,"-"))[seq(from=1,to=length(marker.fragment.index)*2,by=2)]
	distance.matrix <- matrix(0,ncol=length(accession.index),nrow=length(accession.index))
	sum.total <- apply(data.matrix,2,function(x){tapply(x,marker.index,sum)})
	data.matrix.logical <- Matrix(as.integer(as.logical(data.matrix)),ncol=ncol(data.matrix))
	n.accessions <- length(accession.index)
	onepercent <- n.accessions/100
	count <- 0
	cat("Progress Bar", "\n")
	cat("---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|","\n")	
	for (i in 1:(n.accessions-1))
	{
		from <- data.matrix.logical[,i:n.accessions] * data.matrix[,i] 
		to <- data.matrix[,i:n.accessions] * data.matrix.logical[,i] #as.numeric(as.logical(data.matrix[,i])) 
		sum.from <- apply(from,2,function(x){tapply(x,marker.index,sum)})
		sum.to <- apply(to,2,function(x){tapply(x,marker.index,sum)})
		sum.total.selection <- sum.total[,i:n.accessions]
		distance.matrix[i,i:n.accessions] <- apply(pmin(sum.from/(sum.total.selection+0.0000001),sum.to/(sum.total.selection+0.0000001)),2,mean) #TODO subset
		count <- count+1
		if(count>=onepercent) {cat("|"); count<-count-onepercent}
	}
	distance.matrix[n.accessions,n.accessions] <- mean(as.logical(tapply(data.matrix.logical[,n.accessions],marker.index,sum)))
	cat("|","\n")
	distance.matrix <- t(distance.matrix * sqrt(1/diag(distance.matrix))) * sqrt(1/diag(distance.matrix))
	distance.matrix <- 1-distance.matrix
	rownames(distance.matrix) <- as.character(accession.index)
	colnames(distance.matrix) <- as.character(accession.index)
	return(as.dist(distance.matrix))
}

#MAIN PROGRAM

# Load the genetic data and reformat them to have three columns only: UniqueID, marker, allele

connect = odbcConnectExcel("e:\\documents2\\GermplasmData\\DoebleyLab\\Domestication_paper_data.xls")
query = "SELECT UniqueID, Marker, Allele1, Allele2 FROM [data$] WHERE (((UniqueID) Is Not Null));" 
genedataraw = sqlQuery(connect, query)
odbcClose(connect)
genedata <- subset(genedataraw, genedataraw[,1] %in% c(32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,230,231,232,233,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264))
genedata <- gene.reformat(genedata)

# Deal with missing values

genedata <- na.omit(genedata)

# Calculate genetic distances

#gendistance <- distance(genedata)
gendistance <- gene.distance.spa(genedata)
gen.acc <- accumulation.curve(gendistance)