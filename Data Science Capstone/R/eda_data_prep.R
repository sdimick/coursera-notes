# Load Libraries


# Download Data


# Open File Connections
twitterCon <- file("data/final/en_US/en_US.twitter.txt", "r")
blogsCon <- file("data/final/en_US/en_US.blogs.txt", "r")
newsCon <- file("data/final/en_US/en_US.news.txt", "r")

# Read Lines
twitterLines <- readLines(twitterCon)
blogsLines <- readLines(blogsCon)
newsLines <- readLines(newsCon)

# Close File Connections
close(twitterCon); rm('twitterCon')
close(blogsCon); rm('blogsCon')
close(newsCon); rm('newsCon')

