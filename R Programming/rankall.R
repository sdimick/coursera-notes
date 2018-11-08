rankall <- function(outcome, num = "best") {
  if(num=="best"){num <- 1}
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", 
                      colClasses = "character")
  
  ## Check that state and outcome are valid
  if(!(outcome %in% c("heart attack","heart failure","pneumonia"))){
    stop("invalid outcome")
  }
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  if(outcome=="heart attack"){
    col <- 11
  } else if(outcome=="heart failure"){
    col <- 17
  } else {col <- 23}
  states <- unique(data$State)
  states <- states[order(states)]
  outcomes <<- data.frame(
    hospital = character(),
    state = character()
    )
  for(state in states){
    sortdata <- data[data$State==state,c(2,col)]
    sortdata[,2] <- suppressWarnings(as.numeric(sortdata[,2]))
    colnames(sortdata) <- c("hospital","score")
    sortdata <- sortdata[!is.na(sortdata$score),]
    sortdata <- sortdata[order(sortdata$score, sortdata$hospital),]
    if(num=="worst"){x <- nrow(sortdata)} else {x <- num}
    newrow <- data.frame(
      hospital = sortdata$hospital[x],
      state = state
    )
    outcomes <<- rbind(outcomes, newrow)
  }
  return(outcomes)
}