# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

transitionCells <- function(transition)
{
	transition@transitionCells
}

transitionMatrix <- function(transition)
{
	transition@transition@Matrix
}