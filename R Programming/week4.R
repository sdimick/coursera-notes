best <- function(state, outcome) {
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", 
                      colClasses = "character")
  
  ## Check that state and outcome are valid
  if(!(state %in% data$State)) {stop("invalid state")}
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
  sortdata <- data[data$State==state,c(2,col)]
  sortdata[,2] <- suppressWarnings(as.numeric(sortdata[,2]))
  colnames(sortdata) <- c("hospital","score")
  sortdata <- sortdata[order(sortdata$score, sortdata$hospital),]
  print(sortdata$hospital[1])
}