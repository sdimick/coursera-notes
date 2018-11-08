pollutantmean <- function (directory, pollutant, id = 1:332) {
  data <- numeric()
  for(i in id){
    path <- if(i < 10){
      paste0(directory, "/00", i, ".csv")
    } else if(i < 100){
      paste0(directory, "/0", i, ".csv")
    } else {
      paste0(directory, "/", i, ".csv")
    }
    df <- read.csv(path)
    data <- c(data, df[,pollutant])
  }
  return(mean(data, na.rm = TRUE))
}

complete <- function (directory, id = 1:332) {
  total <- data.frame(
    id = numeric(),
    nobs = numeric()
  )
  for(i in id){
    path <- if(i < 10){
      paste0(directory, "/00", i, ".csv")
    } else if(i < 100){
      paste0(directory, "/0", i, ".csv")
    } else {
      paste0(directory, "/", i, ".csv")
    }
    df <- read.csv(path)
    monitor <- data.frame(
      id = i,
      nobs = sum(complete.cases(df))
    )
    total <- rbind(total, monitor)
  }
  return(total)
}

corr <- function (directory, threshold = 0) {
  corrs <- numeric()
  files <- list.files(directory)
  for(i in files){
    df <- read.csv(paste0(directory,"/",i))
    cases <- complete.cases(df)
    if (sum(cases) > threshold) {
      corrs <- c(corrs, cor(df[cases,]$nitrate, df[cases,]$sulfate))
    }
  }
  return(corrs)
}
