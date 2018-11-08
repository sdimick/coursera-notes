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

# ------------------------------------------------------------------------------
# QUIZ QUESTIONS
# ------------------------------------------------------------------------------

# How many lines in twitter doc?
length(twitterLines)

# Longest line in all the text lines?
print(paste0('twitter: ', max(sapply(twitterLines, nchar))))
print(paste0('blogs: ', max(sapply(blogsLines, nchar))))
print(paste0('news: ', max(sapply(newsLines, nchar))))

# Twitter: Lines with "love" / Lines with "hate"
sum(grepl("love", twitterLines)) / sum(grepl("hate", twitterLines))

# What does the one tweet that mentions "biostats" say?
twitterLines[grep("biostats", twitterLines)]

# How many tweets have the exact characters "A computer once beat me at chess,
# but it was no match for me at kickboxing"?
subSentence <- "A computer once beat me at chess, but it was no match for me at kickboxing"
sum(grepl(subSentence, twitterLines))
exactSentence <- "^A computer once beat me at chess, but it was no match for me at kickboxing$"
sum(grepl(exactSentence, twitterLines))

# ------------------------------------------------------------------------------
# Week One Data Prep Tasks
# ------------------------------------------------------------------------------

# text2vec example: https://cran.r-project.org/web/packages/text2vec/vignettes/text-vectorization.html

library(text2vec)
library(tidyverse)

# 1. Tokenize the Data sets
library(text2vec)
tok.twitter <- itoken(
	twitterLines,
	preprocessor = tolower,
	tokenizer = word_tokenizer,
	ids = 1:length(twitterLines),
	progressbar = FALSE
)
tok.blogs <- itoken(
	blogsLines,
	preprocessor = tolower,
	tokenizer = word_tokenizer,
	ids = 1:length(blogsLines),
	progressbar = FALSE
)
tok.news <- itoken(
	newsLines,
	preprocessor = tolower,
	tokenizer = word_tokenizer,
	ids = 1:length(newsLines),
	progressbar = FALSE
)

# 2. Remove Profanity
# Source: https://github.com/whomwah/language-timothy/blob/master/profanity-list.txt
profanities <- readLines("data/profanity.txt") %>% 
	trimws(.) %>% 
	gsub(':.*$', '', .)

# Vocabularies with profanity removed
vocab.twitter <- create_vocabulary(tok.twitter, stopwords = profanities)
vocab.blogs <- create_vocabulary(tok.blogs, stopwords = profanities)
vocab.news <- create_vocabulary(tok.news, stopwords = profanities)

# 2-grams
vocab.twitter.2 <- create_vocabulary(
	tok.twitter,
	stopwords = profanities,
	ngram = c(ngram_min = 2, ngram_max = 2))
vocab.blogs.2 <- create_vocabulary(
	tok.blogs,
	stopwords = profanities,
	ngram = c(ngram_min = 2, ngram_max = 2))
vocab.news.2 <- create_vocabulary(
	tok.news,
	stopwords = profanities,
	ngram = c(ngram_min = 2, ngram_max = 2))

# 3-grams
vocab.twitter.3 <- create_vocabulary(
	tok.twitter,
	stopwords = profanities,
	ngram = c(ngram_min = 3, ngram_max = 3))
vocab.blogs.3 <- create_vocabulary(
	tok.blogs,
	stopwords = profanities,
	ngram = c(ngram_min = 3, ngram_max = 3))
vocab.news.3 <- create_vocabulary(
	tok.news,
	stopwords = profanities,
	ngram = c(ngram_min = 3, ngram_max = 3))


# # Clear Environment
# rm(list = ls())

