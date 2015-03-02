library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)

apiKey 		<- "sVebuSJA0mtUAPXufbeT9tYRI"
apiSecret 	<- "yTv7nFSE7IU2JROF7tCYIxCfaYNNMQh8WfKGc6AFCO5SFW6Tws"
token 		<- "34754876-N5hfoMJnj8KkGihI6y3DqA9e4rtDf1SeTr6G9vcxB"
tokenSecret <- "N1w1oDQdpzOnuGQ2JjshYutpFh7li53GGs1HW9VHoEqFR"

# Direct authentication
setup_twitter_oauth(apiKey, apiSecret, token, tokenSecret )


# Use the searchTwitter function to only get tweets within 50 miles of Los Angeles
#tweets_geolocated <- searchTwitter("Obamacare OR ACA OR 'Affordable Care Act' OR #ACA", n=10, lang="en", geocode="34.049933,-118.240843,50mi", since="2014-08-20")
#tweets_geolocated.df <- twListToDF(tweets_geolocated)


#tweets_text = sapply(tweets_geolocated, function(x) x$getText())
#tweets_corpus = Corpus(VectorSource(tweets_text))

#mh370 <- searchTwitter("#PrayForMH370", since = "2014-03-08", until = "2014-03-20", n = 500)
mh370 <- searchTwitter("#PrayForMH370", n = 400)
# Clean wired characters 

mh370_text = sapply(mh370, function(x) x$getText())
mh370_text_clean <- iconv(mh370_text, to = "utf-8", sub="")
mh370_corpus = Corpus(VectorSource(mh370_text_clean))
 
tdm = TermDocumentMatrix(
  mh370_corpus,
  control = list(
    removePunctuation = TRUE,
    stopwords = c("prayformh370", "prayformh", stopwords("english")),
    removeNumbers = TRUE, tolower = TRUE)
    )
 
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing = TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word = names(word_freqs), freq = word_freqs)
 
wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))