--------------------------------------------------------------------------------

# __Getting and Cleaning Data__

--------------------------------------------------------------------------------

## Week 1

### Tidy Data

* Qualifiers for tidy data
  1. Raw Data
  2. Tidy Data
  3. Code Book (describes each variable in the tidy data, including units!)
  4. Exact recipe for getting from 1 -> 2,3
* Tidy data should have one row for each observation
* Code Book
  * Usually markdown or some other text file
  * Section called "Study Design" about how the data was captured
  * Section called "Code Book" that gives variable description and units
* Instruction List (part of the code book?)
  * Ideally a computer script, inputs and parameters
  * If can't script a step, detailed instructions including software versions on how to process data

### Downloading Files (with R!)

* Handy commands
  * file.exists()
  * dir.create()
  * download.file(*url*, *destfile*, *method*) -mac: method = "curl" for https
  * list.file()
  * keep a variable for the data you downloaded

### Reading Excel Files

* library(xlsx)
* df <- read.xlsx("path/file", sheetIndex=1, header=TRUE)
* can select regions of sheet with colIndex and rowIndex
* XLConnect package may be better for writing and manipulating Excel files

### Reading XML

* XML = extensible markup language
* Have tags, elements, and attributes like HTML
```r
library(XML)
fileURL <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileURL, useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
rootNode[[1]] #first element
rootNode[[1]][[1]] #first element of first element
```
* Parse Document:
  * `xmlSApply(rootNode, xmlValue) #works recursively so that will give you all the values from the whole document in a long string`
  * To access specific parts you need to learn XPath
  * `xpathSApply(rootNode, "//name", xmlValue) #gives you all names`
  * `xpathSApply(rootNode, "//price", xmlValue) #give you all prices`
* Ravens Scores parsing example
```r
fileURL <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileURL, userInternal=TRUE)
scores <- xpathSApply(doc, "//li[@class='score']", xmlValue)
teams <- xpathSApply(doc, "//li[@class='team-name']", xmlValue)
```

### Reading JSON

* JSON = JavaScript Object Notation
* Has data types
  * Numbers
  * Strings (double quoted)
  * Boolean
  * Array (ordered, comma separated, enclosed in [])
  * Object (unordered, comma separated collection of key:value pairs, enclosed in {})
* Accessing JSON formatted data
```r
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
jsonData$owner$login
```
* Turn data frames into JSON: `myjson <- toJSON(iris, pretty=TRUE)`
* Make df from JSON: iris2 <- `fromJSON(myjson)`
* reference: www.json.org

### The data.table Package

* Often faster and more efficient than data frames (written in C)
* `data.table()` works just like `data.frame()` to make tables
* `tables()` give you all data.tables in memory
* Subsetting works *mostly* like data.frames
  * Can subset with one index and will give you rows
  * Does not subset columns only like data.frames
  * Applies function to columns
  * `DT[,list(mean(columnX),sum(columnY))]` gives you mean and sum of those columns
* Create new column "w": `DT[,w:=z^2]`
* If you want to create a copy of a data.table you must do so with `copy()`
* Multistep transformation: `DT[,m:={tmp <- (x+z); log2(tmp+5)}]`
* Aggregated Variable: `DT[,b:= mean(x+w),by=a]`
* `DT[, .N, by=x]` gives you the counts of each element of "x"
* `setKey(DT, x)` sets a key for column "x", helps speed up joins aggregates
* Faster to read in data to data.tables than data.frames with `fread(file)`  

--------------------------------------------------------------------------------

## Week 2

### MySQL

* Have to download MySQL before `install.packages("RMySQL")`
* Find out what databases on are a server
  * `db.con <- dbConnect(MySQL(),user="genome",host="genome-mysql.cse.ucsc.edu")`
  * `dbGetQuery(db.con,"show databases;")`
* Find out tables in db: `dbListTables(con)`
* Find out columns in table: `dbListFields(con, "tablename")`
* `dbGetQuery(con, statement)` OR `query <- dbSendQuery(con, statement); fetch(query); dbClearResult(query)`
* `dbDisconnect(con)`

### HDF5

* HDF stands for *Heirarchical Data Format*
* **Groups** containing zero or more data sets and metadata
  * have a *group header* with group name and list of attributes
  * have a *group symbol table* with a list of objects in group
* **Datasets** multidimensional array of data elements with metadata
  * have *header* with name, datatype, dataspace, and storage layout
  * have *data array* with the data
* R commands! *download* `rhdf5` *package from bioconductor*
```r
library(rhdf5)
h5createFile("example.h5")
h5createGroup("example.h5","foo")
h5createGroup("example.h5","foo/foobaa") #group within group
h5ls("example.h5") #show metadata
A = matrix(1:10, nr=5, nc=2)
h5write(A, "example.h5", "foo/A")
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5") # See how metadata changes
# can also read in a data.frame
readA = h5read("example.h5","foo/A")
# can write to specific chunks of data
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
# can also read specific chunks
```
* HDF5 can be used to optimize reading and writing to disk
* More info from hdfgroup

### Data From the Web

* **Webscraping**: programmatically extracting data from the HTML code of websites.
* Examples:
```r
con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con)
htmlCode # gives us one huge line

library(XML)
url <- ("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@id='col-citeby']", xmlValue)

library(httr)
html2 <- GET(url)
content2 <- content(html2,as="text")
parsedHtml <- htmlParse(condent2,asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)
# using the httr package is cool because you can authenticate yourselft for
# websites by passing your username and password
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd",authenticate("user","passwd"))
pg2 #prints response of the GET
names(pg2) #what's all in the object
# You can use handles to authenticate once for an entire site
# aka the cookies will stick with the handle
google <- handle("http://google.com")
pg1 <- GET(handle=google,path="/")
pg2 <- GET(handle=google,path="search")
```

### Reading Data from APIs

* Use GET commands from the `httr` package and URLs to the API
* dev.twitter.com/apps
  * Set up "application" to get OAuth credentials
  ```r
library(httr)
myapp <- oauth_app("twitter",key="yourkey",secret="yoursecret")
sig <- sign_oauth1.0(myapp,token="yourtoken",token_secret="yourtokensecret")
homeTL <- GET("http://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 <- content(homeTL)
library(jsonlite)
json2 <- fromJSON(toJSON(json1)) #restructure as data.from with jsonlite
json[1,1:4]
  ```
* `httr` works well with Facebook, Google, Twitter, Github, etc.
* Most modern APIs use oauth for authentication

### Other Sources

* `?connections` for help reading files
* `foreign` package good for reading files from other software
* Other DB packages:
  * rpostgres
  * rmongodb
  * RODBC
  * RJDBC
* You can directly read images too
  * jpeg
  * readbitmap
  * png
  * EBImage (bioconductor)
* GIS data
  * rdgal
  * rgeos
  * raster
* Reading Music
  * tuneR
  * seewave

*Need a package for something? Just google it...*

--------------------------------------------------------------------------------

## Week 3

### Subsetting and Sorting

* Subsetting: data[rows, columns]
* Conditions - AND `&` OR `|`
* `sort(data$var1)`
* `data[order(data$var1),]`
* `data[order(data$var1,data$var2),]`
* Sort with  `plyr`:
```r
library(plyr)
arrange(data,var1)
arrange(data,desc(var1))
```
* `cbind()` and `rbind()`

### Summarizing Data

* `head(df, n=6)` - n is the number of rows to show
* `tail(df, n=6)`
* `summary(data)` gives stats on each variable
* `str(data)` give structure of the data
* `quantile(data$var, na.rm=TRUE)`
* `quantile(data$var, probs=c(0.5,0.9))`
* `table(data$var,useNA="ifany")` shows counts for each value in variable
* Can do a two dimensional table with counts: `table(data$var1,data$var2)`
* Count of missing values `sum(is.na(data$var))`
* logical functions for checking things `any()` and `all()`
* check every column for NAs `colSums(is.na(data))`
* `table(data$var %in% c("a", "b"))`
  * `%in%` returns TRUE/FALSE (boolean)
* Cross Tabs
  * `xtabs(Freq ~ var1 + var2, data=DF)`
  * Can do more variables and then clean up your output with `ftable()`
* `object.size(data)` returns bytes
  * can do other units `print(object.size(data), units="Mb")`

### Creating New Variables

* Sequences:
  * `s1 <- seq(1, 10, by=2)`
  * `s2 <- seq(1, 10, length=2)`
  * `x <- c(1,3,8,25,100); s3 <- seq(along = x)`
* Create some groupings for a variables with `cut()`
  * `data$groups <- cut(data$var, breaks=quantile(data$var))`
  * can also use `cut2` from package `Hmisc`
* turn a variable into a factor with `factor()`
  * can determine order of levels with `levels=c(..order..)`
* `as.numeric()`
* `mutate()` example:
```r
library(Hmisc)
library(plyr)
data2 <- mutate(data,groups=cut2(var,g=4))
table(data2)
```
* common functions:
  * `abs()`
  * `sqrt()`
  * `ceiling()` round up
  * `floor()` round down
  * `round(x, digits=n)`
  * `signif(x, digits=n)` significant digits
  * `cos()`
  * `sin()`
  * `log()`
  * `log2()`
  * `log10()`
  * `exp()`

### Reshaping Data

* The GOAL is tidy data - we'll focus on the first two here
  1. Each variable forms a column
  2. Each observation is a row
  3. Each table/file store data about one kind of observation
```r
library(reshape2)
head(mtcars)
mtcars$carname <- rownames(mtcars)
#make the data set tall and skinny
carMelt <- melt(mtcars, id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
tail(carMelt,n=3)
#cast it into a bunch of different shapes (summarizing the data)
cylData <- dcast(carMelt, cyl ~ variable)
cylData
cylData <- dcast(carMelt, cyl ~ variable, mean)
cylData

#averaging values
head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray,sum)

#split, apply, combine
spIns <- split(InsectSprays$count,InsectSprays$spray)
spIns
sprCount <- lapply(spIns,sum)
sprCount
unlist(sprCount) #back to vector from list from lapply or...
sapply(spIns,sum)

#ooooor use plyr
library(plyr)
ddply(InsectSprays,.(spray),summarize,sum=sum(count))
#and you can put the total sum on each row that the value appears
spraySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum))
dim(spraySums)
```
* also checkout `acast()`, `arrange()`, `mutate()`

### dplyr

* First functions to know, first argument always data frame and returns data frame
  * `select()`
  * `filter()`
  * `arrange()`
  * `rename()` - rename variables
  * `mutate()`
  * `summarize()`
* pipe them all together! `%>%`
* Can use dplyr functions with `data.tables` and `SQL` from `DBI`

### Merging Data

* `?merge`
* `merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE)`
  * by.x is the field to join on in first df
  * by.y is the field to join on in second df
  * all=TRUE is basically a full outer join
* default is to join on all common column names
* can use `join()` from `plyr` but will only join on common column names
  * but very easy to join more than two dfs with common ids using `join_all()`

--------------------------------------------------------------------------------

## Week 4

### Editing Text Variables

__Useful functions__
```r
tolower()
toupper()
strsplit(dataset,"\\.") # Splits on period "."
sub() # Substitute first character
gsub() # Substitutes all matches
grep(searchstring, vector_to_search) # returns vector of places it finds it
grepl(searchstring, vector_to_search) # returns boolean vector
# use value=TRUE with grep to actually return values
nchar() #number of characters in string
substr()
paste()
paste0()
```

__stringr package__
```r
str_trim()
```

What if you wanted to split on periods and drop everything after the period?
```r
splitNames <- strsplit(dataset,"\\.")
firstElement <- function(x){x[1]}
sapply(splitNames,firstElement)
```

__Tips__
* In variable names
  * values us all lowercase whenever possible
  * More descriptive > abbreviated
  * Avoid underscores, white spaces, or dots
* In variable values
  * should usually be made into factor variables
  * should be descriptive (TRUE/FALSE vs 1/0, Male/Female vs M/F)

### Regular Expressions

* Liters: exact character match
* Metacharacters: starts with, between, this or that, etc.
* `^i think` line starts with "i think" -- ^
* `morning$` line ends with "morning" -- $
* `[Bu][Uu][Ss][Hh]` any combination of upper and lowercase "bush" -- []
* `^[Ii] am` line starts with "I am" or "i am"
* `[a-z]` any letter "a" to "z"
* `[a-zA-Z]` any letter lower or upper case
* `^[0-9][a-zA-Z]` any line that starts with a number and second character is letter
* `[^?.]` anything that's NOT a question mark or period
* `[^?.]$` any line that does NOT end in a question mark or period
* `.` single character wild card
* `|` or
* `^[Gg]ood|[Bb]ad` starts with upper|lower good, or anywhere upper|lower bad
* can use parenthesis!!
* `^([Gg]ood|[Bb]ad)` now good or bad has to start the line
* `?` makes the leading expression optional
* `[Gg]eorge( [Ww]\.)? [Bb]ush` George Bush/George w. bush/etc
* `\` escape metacharater meaning
* `*` any character in front of it repeated any number of times (includeing 0)
* `+` any number of times, but at least once
* `[0-9]+ (.*)[0-9]+` any set of numbers with a space, any characters than any set of numbers
* `{}` use curly brackets to say number of times you want something to show up
* `[Bb]ush( +[^ ]+ +){1,5}` Bush and then one to five spaces > not spaces > spaces
* `{m,n}` at least m matches but not more than n
* `{m}` exactly m matches
* `{m,}` at least m matches
* `()` can also be used to remember the matched phrase and then called with `\1` for first matched phrase or `\2` for the second phrase, etc
* Regex can be used with with grep, grepl, sub, and gsub

### Working with Dates

* `data()` gives you string that looks like date
* `sys.Date()` give you a class data object
* `format(dateObj,"%a %b %d")` > "Sun Jan 12"
* for `format()`
  * %d = day as number (0-31)
  * %a = abbreviated weekday
  * %A = unabbreviated weekday
  * %m = month (00-12)
  * %a = abbreviated month
  * %a = unabbreviated month
  * %y = two digit year
  * %Y = four digit year
* `as.Date(string, "formating")`
* Converting to Julian
  * `weekdays(date)`
  * `julian(date)` convert to integer since origin
* `lubridate` package
  * don't have to format!!
  * `ymd("20171022")` will convert to date!!
  * different syntax than base of course i.e. wday() instead of weekdays()

### Data Resources

* united nations: data.un.org
* US: data.gov
* gapminder (human health)
* survey data: asdfree.com
* infochimps marketplace - some free some paid
* Kaggle often as interesting data sets for competitions
* Some famous data scientists have put together free data sets
* APIs!
  * twitter with twitteR package
  * figshare
  * PLoS
  * rOpenSci
  * Facebook with RFacebook
  * Google maps with RGoogleMaps
