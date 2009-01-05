# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

adjacency <- function(raster, fromCells, toCells, directions, outerMeridianConnect)
{
	nCols <- ncols(raster)
	nCells <- ncells(raster)
	
	left <- seq(nCols+1,(nCells-2*nCols+1),by=nCols) 
	right <- seq(2*nCols,nCells-nCols,by=nCols)
	upper <- 2:(nCols-1)
	lower <- seq((nCells-nCols+2),(nCells-1),by=1)
	upperleft <- 1
	upperright <- nCols
	lowerleft <- nCells-nCols+1
	lowerright <- nCells

	fromCells.core <- setdiff(fromCells,(c(left,right,upper,lower,upperleft,upperright,lowerleft,lowerright)))
	fromCells.upper <- intersect(fromCells,upper)
	fromCells.lower <- intersect(fromCells,lower)
	fromCells.left <- as.integer(intersect(fromCells,left))
	fromCells.right <- as.integer(intersect(fromCells,right))
	fromCell.upperleft <- as.integer(intersect(fromCells,upperleft))
	fromCell.upperright <- as.integer(intersect(fromCells,upperright))
	fromCell.lowerleft <- as.integer(intersect(fromCells,lowerleft))
	fromCell.lowerright <- as.integer(intersect(fromCells,lowerright))

	rook <- c(1,-1,nCols,-nCols)

	coreFromToRook <- .cs(fromCells.core,rook)
	upperFromToRook <- .cs(fromCells.upper,rook[1:3])
	lowerFromToRook <- .cs(fromCells.lower,rook[c(1,2,4)])
	leftFromToRook <- .cs(fromCells.left,rook[c(1,3,4)])
	rightFromToRook <- .cs(fromCells.right,rook[2:4])
	upperleftFromToRook <- .cs(fromCell.upperleft,rook[c(1,3)])
	upperrightFromToRook <- .cs(fromCell.upperright,rook[2:3])
	lowerleftFromToRook <- .cs(fromCell.lowerleft,rook[c(1,4)])
	lowerrightFromToRook <- .cs(fromCell.lowerright,rook[c(2,4)])
	fromto1 <- rbind(coreFromToRook,upperFromToRook,lowerFromToRook,leftFromToRook,rightFromToRook,upperleftFromToRook,upperrightFromToRook,lowerleftFromToRook,lowerrightFromToRook)
	
	if (outerMeridianConnect) 
	{
		meridianFromLeft <- rbind(
			cbind(fromCells.left,as.integer(fromCells.left+nCols-1)),
			cbind(fromCell.upperleft,as.integer(fromCell.upperleft+nCols-1)),
			cbind(fromCell.lowerleft,as.integer(fromCell.lowerleft+nCols-1))
			)
		meridianFromRight <- rbind(
			cbind(fromCells.right,as.integer(fromCells.right-nCols+1)),
			cbind(fromCell.upperright,as.integer(fromCell.upperright-nCols+1)),
			cbind(fromCell.lowerright,as.integer(fromCell.lowerright-nCols+1))
			)
		fromto1 <- rbind(fromto1,meridianFromLeft,meridianFromRight)
	}
	else{}
	fromto <- subset(fromto1,fromto1[,2] %in% toCells)

	if(directions > 4)
	{
		bishop <- as.integer(c(-nCols-1, -nCols+1, nCols-1,+nCols+1))
		
		coreFromToBishop <- .cs(fromCells.core,bishop)
		upperFromToBishop <- .cs(fromCells.upper,bishop[3:4])
		lowerFromToBishop <- .cs(fromCells.lower,bishop[1:2])
		leftFromToBishop <- .cs(fromCells.left,bishop[c(2,4)])
		rightFromToBishop <- .cs(fromCells.right,bishop[c(1,3)])
		upperleftFromToBishop <- .cs(fromCell.upperleft,bishop[4])
		upperrightFromToBishop <- .cs(fromCell.upperright,bishop[3])
		lowerleftFromToBishop <- .cs(fromCell.lowerleft,bishop[2])
		lowerrightFromToBishop <- .cs(fromCell.lowerright,bishop[1])

		fromto2 <- rbind(coreFromToBishop,upperFromToBishop,lowerFromToBishop,leftFromToBishop,rightFromToBishop,upperleftFromToBishop,upperrightFromToBishop,lowerleftFromToBishop,lowerrightFromToBishop)
		
		if (outerMeridianConnect) 
		{
			meridianFromLeft <- rbind(
				.cs(fromCells.left,c(2*nCols-1,-1)),
				cbind(fromCell.upperleft,as.integer(fromCell.upperleft+2*nCols-1)),
				cbind(fromCell.lowerleft,as.integer(fromCell.lowerleft-1))
				) 
			meridianFromRight <- rbind(
				cbind(rep(fromCells.right,times=2),as.integer(c(fromCells.right-2*nCols+1,fromCells.right+1))),
				cbind(fromCell.upperright,as.integer(fromCell.upperright+1)),
				cbind(fromCell.lowerright,as.integer(fromCell.lowerright-2*nCols+1))
				)
			fromto2 <- rbind(fromto2,meridianFromLeft,meridianFromRight)
		}
		else{}
		fromto2 <- subset(fromto2,fromto2[,2] %in% toCells)
		fromto <- rbind(fromto,fromto2)
	}
	else{}
	if(directions > 8)
	{
		#the following dont change: upperleft upperright lowerleft lowerright

		leftOuter <- seq(2*nCols+1,nCells-3*nCols+1,by=nCols) 
		rightOuter <- seq(3*nCols,nCells-2*nCols,by=nCols)
		upperOuter <- seq(3,nCols-2,by=1)
		lowerOuter <- seq(nCells-nCols+3,nCells-2,by=1)

		upperleftUnder <- nCols+1
		upperrightLeft <- nCols-1
		lowerleftUp <- nCells-2*nCols+1
		lowerrightUp <- nCells-nCols		
		upperleftRight <- 2
		upperrightUnder <- 2*nCols
		lowerleftRight <- nCells-nCols+2
		lowerrightLeft <- nCells-1

		leftInner <- seq(2*nCols+2,(nCells-3*nCols+2),by=nCols) 
		rightInner <- seq(3*nCols-1,nCells-2*nCols-1,by=nCols)
		upperInner <- seq(nCols+3,2*nCols-2,by=1)
		lowerInner <- seq(nCells-2*nCols+3,nCells-nCols-2,by=1)

		upperleftInner <- nCols+2
		upperrightInner <- 2*nCols-1
		lowerleftInner <- nCells-2*nCols+2
		lowerrightInner <- nCells-nCols-1

		fromCells.coreInner <- setdiff(fromCells,(c(leftOuter,rightOuter,upperOuter,lowerOuter,upperleft,upperright,lowerleft,lowerright, upperleftUnder, upperrightLeft, lowerleftUp, lowerrightUp, upperleftRight, upperrightUnder, lowerleftRight, lowerrightLeft, leftInner, rightInner, upperInner, lowerInner, upperleftInner, upperrightInner, lowerleftInner, lowerrightInner))) 
		
		fromCells.upperInner <- intersect(fromCells,upperInner)
		fromCells.lowerInner <- intersect(fromCells,lowerInner)
		fromCells.leftInner <- as.integer(intersect(fromCells,leftInner))
		fromCells.rightInner <- as.integer(intersect(fromCells,rightInner))

		fromCell.upperleftInner <- as.integer(intersect(fromCells,upperleftInner))
		fromCell.upperrightInner <- as.integer(intersect(fromCells,upperrightInner))
		fromCell.lowerleftInner <- as.integer(intersect(fromCells,lowerleftInner))
		fromCell.lowerrightInner <- as.integer(intersect(fromCells,lowerrightInner))	

		fromCells.leftOuter <- as.integer(intersect(fromCells,leftOuter))
		fromCells.rightOuter <- as.integer(intersect(fromCells,rightOuter))
		fromCells.upperOuter <- as.integer(intersect(fromCells,upperOuter))
		fromCells.lowerOuter <- as.integer(intersect(fromCells,lowerOuter))

		fromCell.upperleftUnder <- as.integer(intersect(fromCells,upperleftUnder))
		fromCell.upperrightLeft <- as.integer(intersect(fromCells,upperrightLeft))
		fromCell.lowerleftUp <- as.integer(intersect(fromCells,lowerleftUp))
		fromCell.lowerrightUp <- as.integer(intersect(fromCells,lowerrightUp))
		fromCell.upperleftRight <- as.integer(intersect(fromCells,upperleftRight))
		fromCell.upperrightUnder <- as.integer(intersect(fromCells,upperrightUnder))
		fromCell.lowerleftRight <- as.integer(intersect(fromCells,lowerleftRight))
		fromCell.lowerrightLeft <- as.integer(intersect(fromCells,lowerrightLeft))

		knight <- c(-2*nCols-1, -2*nCols+1, -nCols-2, -nCols+2, nCols-2, nCols+2, 2*nCols-1, 2*nCols+1)	
		
		coreInnerFromToKnight <- .cs(fromCells.coreInner, knight) 
		
		upperInnerFromToKnight <- .cs(fromCells.upperInner, knight[3:8])
		lowerInnerFromToKnight <- .cs(fromCells.lowerInner, knight[1:6])
		leftInnerFromToKnight <- .cs(fromCells.leftInner, knight[c(1,2,4,6:8)])
		rightInnerFromToKnight <- .cs(fromCells.rightInner, knight[c(1:3,5,7,8)])

		upperleftInnerFromToKnight <- .cs(fromCell.upperleftInner, knight[c(4,6:8)])
		upperrightInnerFromToKnight <- .cs(fromCell.upperrightInner, knight[c(3,5,7,8)])
		lowerleftInnerFromToKnight <- .cs(fromCell.lowerleftInner, knight[c(1,2,4,6)])
		lowerrightInnerFromToKnight <- .cs(fromCell.lowerrightInner, knight[c(1:3,5)])
		
		leftOuterFromToKnight <- .cs(fromCells.leftOuter, knight[c(2,4,6,8)])
		rightOuterFromToKnight <- .cs(fromCells.rightOuter, knight[c(1,3,5,7)])
		upperOuterFromToKnight <- .cs(fromCells.upperOuter, knight[5:8])
		lowerOuterFromToKnight <- .cs(fromCells.lowerOuter, knight[1:4])

		upperleftUnderFromToKnight <- .cs(fromCell.upperleftUnder, knight[c(4,6,8)])
		upperrightLeftFromToKnight <- .cs(fromCell.upperrightLeft, knight[c(5,7,8)])
		lowerleftUpFromToKnight <- .cs(fromCell.lowerleftUp, knight[c(2,4,6)])
		lowerrightUpFromToKnight <- .cs(fromCell.lowerright, knight[c(1,3,5)])
		upperleftRightFromToKnight <- .cs(fromCell.upperleftRight, knight[6:8])
		upperrightUnderFromToKnight <- .cs(fromCell.upperrightUnder, knight[c(3,5,7)])
		lowerleftRightFromToKnight <- .cs(fromCell.lowerleftRight, knight[c(1,2,4)])
		lowerrightLeftFromToKnight <- .cs(fromCell.lowerrightLeft, knight[1:3])

		upperleftFromToKnight <- .cs(fromCell.upperleft, knight[c(6,8)])
		upperrightFromToKnight <- .cs(fromCell.upperright, knight[c(5,7)])
		lowerleftFromToKnight <- .cs(fromCell.lowerleft, knight[c(2,4)])
		lowerrightFromToKnight <- .cs(fromCell.lowerright, knight[c(1,3)])
		
		fromto3 <- rbind(coreInnerFromToKnight, upperInnerFromToKnight, lowerInnerFromToKnight, leftInnerFromToKnight, rightInnerFromToKnight, upperleftInnerFromToKnight, upperrightInnerFromToKnight, lowerleftInnerFromToKnight, lowerrightInnerFromToKnight, leftOuterFromToKnight, rightOuterFromToKnight, upperOuterFromToKnight,	lowerOuterFromToKnight, upperleftUnderFromToKnight, upperrightLeftFromToKnight,	lowerleftUpFromToKnight, lowerrightUpFromToKnight, upperleftRightFromToKnight, upperrightUnderFromToKnight, lowerleftRightFromToKnight, lowerrightLeftFromToKnight, upperleftFromToKnight, upperrightFromToKnight, lowerleftFromToKnight, lowerrightFromToKnight)
		fromto3 <- subset(fromto3,fromto3[,2] %in% toCells)
		
		if (outerMeridianConnect) 
		{
			knightLeft <- c(-nCols-1, -2, +2*nCols-2, 3*nCols-1)
			knightRight <- c(-3*nCols+1, -2*nCols+2, +2, nCols+1)

			leftInnerFromToKnight <- .cs(fromCells.leftInner, knightLeft[c(2,3)])
			rightInnerFromToKnight <- .cs(fromCells.rightInner, knightRight[c(2,3)])

			upperleftInnerFromToKnight <- .cs(fromCell.upperleftInner, knightLeft[c(2,3)])
			upperrightInnerFromToKnight <- .cs(fromCell.upperrightInner, knightRight[c(2,3)])
			lowerleftInnerFromToKnight <- .cs(fromCell.lowerleftInner, knightLeft[c(2,3)])
			lowerrightInnerFromToKnight <- .cs(fromCell.lowerrightInner, knightRight[c(2,3)])
		
			leftOuterFromToKnight <- .cs(fromCells.leftOuter, knightLeft)
			rightOuterFromToKnight <- .cs(fromCells.rightOuter, knightRight)

			upperleftUnderFromToKnight <- .cs(fromCell.upperleftUnder, knightLeft[2:4])
			upperrightLeftFromToKnight <- .cs(fromCell.upperrightLeft, knightRight[3])
			lowerleftUpFromToKnight <- .cs(fromCell.lowerleftUp, knightLeft[1:3])
			lowerrightUpFromToKnight <- .cs(fromCell.lowerrightUp, knightRight[1:3])
			upperleftRightFromToKnight <- .cs(fromCell.upperleftRight, knightLeft[c(3)])
			upperrightUnderFromToKnight <- .cs(fromCell.upperrightUnder, knightRight[2:4])
			lowerleftRightFromToKnight <- .cs(fromCell.lowerleftRight, knightLeft[2])
			lowerrightLeftFromToKnight <- .cs(fromCell.lowerrightLeft, knightRight[2])

			upperleftFromToKnight <- .cs(fromCell.upperleft, knightLeft[c(3,4)])
			upperrightFromToKnight <- .cs(fromCell.upperright, knightRight[c(3,4)])
			lowerleftFromToKnight <- .cs(fromCell.lowerleft, knightLeft[c(1,2)])
			lowerrightFromToKnight <- .cs(fromCell.lowerright, knightRight[c(1,2)])
			
			fromto3 <- rbind(fromto3, leftInnerFromToKnight, rightInnerFromToKnight, upperleftInnerFromToKnight, upperrightInnerFromToKnight, lowerleftInnerFromToKnight, lowerrightInnerFromToKnight, leftOuterFromToKnight, rightOuterFromToKnight, upperleftUnderFromToKnight, upperrightLeftFromToKnight, lowerleftUpFromToKnight, lowerrightUpFromToKnight, upperleftRightFromToKnight, upperrightUnderFromToKnight, lowerleftRightFromToKnight, lowerrightLeftFromToKnight, upperleftFromToKnight, upperrightFromToKnight, lowerleftFromToKnight, lowerrightFromToKnight)
		}
		else{}
		
		fromto3 <- subset(fromto3,fromto3[,2] %in% toCells)	
		fromto <- rbind(fromto,fromto3)
	}
	else{}
	colnames(fromto) <- c("from","to")
	return(fromto)
}