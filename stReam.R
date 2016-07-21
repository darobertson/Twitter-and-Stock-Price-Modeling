
#if twitteR, RCurl and httr packages are not installed,
#do so with the following commands:
#     install.packages("twitterR")
#     install.packages("RCurl")

### NOTE: you must also have the base64enc package installed -install.packages('base64enc')

library(twitteR)
library(RCurl)
library(sqldf)
library(gdata)
## Here are the access tokens.  You can get these keys by creating
# a twitter account, and then a twitter app.  To create a twitter
# go to apps.twitter.com.  Then create an app.  Make sure the app is enable
# to both 'read and write' ... you will need to generate your own
# access tokens - there is a button for doing this.  If you run into any problems,
# there is a plethora of sources that will take you through the steps.

setwd("~/Desktop/honors_thesis")

# ck - consumer key
# cs- consumer secret
# at - access token
# as - access secret
ck <- 'EUDUdrGMySAhEnNASMp6VTxM9'
cs <- 'HrkDH58rtJEVVZ9USRz71RcOX9wSjn8hqSzBENznzJ4i9naW3j'
at <- '501428087-EKsatChvcc1SaWdfNK3Oke58spT42EZWaFsb18jy'
as <- 'HJ9FpmElCmiypTkgVKMsL7K3u7HMPV2ZzSwQpyUZlFpuj'


#this line will set up a connection with the Twitter API ...
#this will not work if the base64enc package is not installed,
# or the keys are not correct.
setup_twitter_oauth(ck, cs, at, as)

#if you are getting an error when you run the setup_twitter_oauth function,
# make sure the base64enc package is installed - install.packages('base64enc')


#One of the great things about the twitteR package is that it will allow you to get information
#on whats trending given a location. To look at a list of the available trend loactions,
# (if the code as compiled properly), you can type in the variable availtrends in the command
#line ...
#To get the trending topics for a locaiton, you need to use the locations woeid code. It's
#that 7 digit number in the thrid column of the data frame.
#the location variable I created is desinged to give you the woeid quite easily.
#replace the string "United States" with the name of the location you wish to stream trends from,
# and then the variable woeid will be that locations woeid.

# furthermore, the variable trends will automatically be loaded with the trending topics at that location
#availtrends <- availableTrendLocations()
#location <- subset(availtrends, availtrends[1]=="United States")
#woeid <- strtoi(location[1,3])
#trends <- getTrends(woeid)
#trends_names <- trends[1]
#top_trend <- str(trends_names[1,1])

# sadly, the twitteR package won't allow us to stream tweets in real time, but we
#will be able to collect recent tweets that resemble what is currently being blogged.
# It is important to note, that a lot more than the tweet's text is collected when
#tweets are streamed.
#replace the string '#MusicMonday' with a string you wish the tweets that you stream to
# to contain. n is the amount of recent tweets you wish, and lang makes all tweets be
# be a certain language.  There are many more parameters to the searchTwitter function,
# and it is worthwhile checking them all out.
tweets <- searchTwitter("$AAPL", n = 1000, lang = "en")
tweetst <- searchTwitter("$TWTR", n = 1000, lang = "en")

#the strip_retweets function will remove all content that isn't orginal - strip away all
# tweets are just retweeted (reposted) from another user.
clean_tweets <- twListToDF(strip_retweets(tweets))
clean_tweetst <- twListToDF(strip_retweets(tweetst))
text <- clean_tweets[,1]
textTw <- clean_tweetst[,1]
#relevant tweet data:  Here you can select the data you wish to see
# the colnames in the previous data frame are listed
# "text"          "favorited"     "favoriteCount" "replyToSN"
# [5] "created"       "truncated"     "replyToSID"    "id"
# [9] "replyToUID"    "statusSource"  "screenName"    "retweetCount"
# [13] "isRetweet"     "retweeted"     "longitude"     "latitude"
rtd <- subset(clean_tweets, select = c("text", "favorited", "favoriteCount",
                                       "replyToSN", "created", "screenName"))
rtdt <- subset(clean_tweetst, select = c("text", "favorited", "favoriteCount",
                                       "replyToSN", "created", "screenName"))
text_time <- subset(rtd, select= c("created", "text"))
text_timet <- subset(rtdt, select= c("created", "text"))
write.table(rtd, "AAPL_tweet_sent.csv", sep = "~", append = TRUE, row.names = FALSE, col.names = TRUE)
write.table(text, "APPL_tweets.csv", append = T, row.names = F, col.names = T)
write.table(textTw, "TWTR_tweets.csv", append = T, row.names = F, col.names = T)
write.table(text_time, "AAPL_tweet_time-6-28.txt", append = FALSE, row.names = FALSE, col.names = FALSE)
write.table(rtdt, "TWTR_tweet_sent.csv", sep = "~", append = TRUE, row.names = FALSE, col.names = TRUE)
write.table(text_timet, "TWTR_tweet_time-6-28.txt", append = FALSE, row.names = FALSE, col.names = FALSE)

poldata <- read.xls('polarity_main.xlsx')


plot(mydata$pos.bull., mydata$neg.bear., main = "Neg&Pos", xlab = "pos number", ylab = "neg number")



#we are now going to add the tweets to a sqlite database
#db <- dbConnect(SQLite(), dbname="Test.sqlite")
#sqldf("attach 'Test1.sqlite' as new")
#register_sqlite_backend("db")
#we are now gonna add the tweets to a database
#store_tweets_db(tweets)
