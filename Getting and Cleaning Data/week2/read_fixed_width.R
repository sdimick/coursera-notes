# fixed width file reading

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for",
              "~/Git/Coursera/Get_and_Clean_Data/week2/fixed_width.for",
              method = "curl")
fwf.df <- read.fwf("~/Git/Coursera/Get_and_Clean_Data/week2/fixed_width.for",
                   widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4),
                   skip = 4)
sum(fwf.df$V4)
