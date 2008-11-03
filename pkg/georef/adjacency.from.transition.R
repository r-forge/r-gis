`adjacency.from.transition` <-
function(transition)
{
transition.dsC <- as(transition,"dsCMatrix")
transition.dgT <- as(transition.dsC,"dgTMatrix")
if (transition@zerorowcol == TRUE)
{
adjacency <- cbind(transition.dgT@i+1,transition.dgT@j+1)
}
if (transition@zerorowcol == FALSE)
{
adjacency <- cbind(transition@transitionmatrix@Dimnames[[1]][transition.dgT@i+1],transition@transitionmatrix@Dimnames[[2]][transition.dgT@j+1])
}
return(adjacency)
}

