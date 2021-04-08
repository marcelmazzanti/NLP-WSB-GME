
#' Title: WallStreetBets Analysis
#' Purpose: Could Hedge Funds predict the big short squeeze caused by WallStreetBets?
#' Author: Marcello Mazzanti
#' email: mmazzanti2020@student.hult.edu
#' Date: 10th March 2021


#################
# ORGANIZE SCRIPT

# options
options(stringsAsFactors = FALSE)
Sys.setlocale('LC_ALL','C')


# loading libraries
library(tidyr)
library(dplyr)
library(tidytext)
library(textdata)
library(quantmod)
library(tm)
library(qdap)
library(lexicon)
library(corpus)
library(ggplot2)
library(plotly)
library(echarts4r)
library(scales)
library(grid)



# custom Functions
tryTolower <- function(x){
  # return NA when there is an error
  y = NA
  # tryCatch error
  try_error = tryCatch(tolower(x), error = function(e) e)
  # if not an error
  if (!inherits(try_error, 'error'))
    y = tolower(x)
  return(y)
}

cleanCorpus<-function(corpus, customStopwords){
  corpus <- tm_map(corpus, content_transformer(qdapRegex::rm_url)) 
  corpus <- tm_map(corpus, content_transformer(tryTolower))
  corpus <- tm_map(corpus, removeWords, customStopwords)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, stripWhitespace)
  #corpus <- tm_map(corpus, stemDocument) 
  return(corpus)
}




#################
# OBTAINING VALUES AND PLOTTING STOCKS

# setting period of interest
start = as.Date('2021-01-10') 
end = as.Date('2021-02-02')

# getting stocks indexes of interest
getSymbols('GME', src='yahoo', from = start, to = end)

getSymbols('^GSPC', src='yahoo', from = start, to = end)



# data frame for GME data
gme_df <- data.frame(Date=index(GME), coredata(GME))



# candlestick graph for GME
gme_candle <- gme_df %>% 
  plot_ly(x = ~Date, type='candlestick',
          open = ~GME.Open, close = ~GME.Close,
          high = ~GME.High, low = ~GME.Low) 

gme_candle <- gme_candle %>% 
  layout(xaxis = list(rangeslider = list(visible = F)),
         yaxis = list(title = 'Share Price'))

# display plot
gme_candle



# data frame to compare GME with S&P500 index
stocks <- data.frame(GME = GME[, 'GME.Close'], GSPC = GSPC[, 'GSPC.Close'])

# making Date as column instead of index
stocks <- cbind(Date = rownames(stocks), stocks)

rownames(stocks) <- 1:nrow(stocks)

# renaming cols
names(stocks) = c('Date', 'GME', 'SP500')

# making Date col as date for plot
stocks$Date <- as.Date(stocks$Date)

# transforming cols into NOT cumulative percentage change for comparability 
stocks$GME <- stocks$GME / sum(stocks$GME) *100

stocks$SP500 <- stocks$SP500 / sum(stocks$SP500) *100

# pivoting data frame for plot
pvt_stocks <- stocks %>% 
  pivot_longer(cols = c('GME', 'SP500'), names_to = 'Stock', values_to='Price')



# plot stocks to compare
cmpr_line <- pvt_stocks %>%
  ggplot(., aes(x= Date, y = Price, color= Stock)) + 
  geom_point(size = 1.5)+ 
  geom_line(size = 1.2)+
  geom_vline(xintercept = as.numeric(as.Date("2021-01-25")), linetype=2, color = '#cccccc' )+
  theme_minimal()+
  labs(x='Date', y='Price Change')+
  theme(legend.title = element_text(size = 12, face="bold"),
        legend.text = element_text(size = 12))


# change color of the graph manually for different stocks and display plot
cmpr_line + scale_color_manual(values=c('brown2', '#8c8c8c'))





#################
#ORGANIZE DATASET

# set working directory
setwd("~/Desktop/WSB_Case")

# load data
text <- read.csv("WSB_GME_data.csv")

# renaming columns for functions
names(text)[1] <- 'doc_id'

# renaming column for functions
text <- rename(text, text = comment)

# avoid encoding errors
text$text <- iconv(text$text, from = 'latin1', to='UTF-8')

# make date columns into date
text$comm_date <- as.Date(text$comm_date)

text$post_date <- as.Date(text$post_date)

# subset for period of interest
text <- subset(text, comm_date >= as.Date('2021-01-10'))



# defining stop words
stops <- c(stopwords('SMART'), 'gme', 'fucking', 'people', 'make', 'money',
           'time', 'market', 'price', 'nok', 'amc', 'shit', 'back', 'good',
           'share', 'day', 'today', 'financial', 'stocks')

# substituting words to raise relevance
text$text <- gsub('buying', 'buy', text$text, ignore.case = T )

text$text <- gsub('selling', 'sell', text$text, ignore.case = T )

text$text <- gsub('holding', 'hold', text$text, ignore.case = T )
                   

# extract Temporal Grouping Options
#text$hr <- hour(text$comm_date)



# EDA

# number of unique posts
# n_distinct(text$post_text)
# 
# # average upvote and post score
# mean(unique(text$upvote_prop))
# mean(unique(text$post_score))





#################
# CREATE CORPUS AND CLEAN DATA

txt <- VCorpus(VectorSource(text$text))

txt <- cleanCorpus(txt, stops)


# dtm 
txtDTM <- DocumentTermMatrix(txt)

DTM <- as.matrix(txtDTM)


# tidy 
tidyCorp <- tidy(txtDTM)



# append dates for terms and sentiment analysis
Dates <- data.frame(document = as.character(seq_along(text$comm_date)),
                    comm_date = text$comm_date)

tidyCorpSent <- left_join(tidyCorp, Dates, by = c('document'= 'document'))





#################
# COMMENT COUNT AND WORD FREQUENCY

# term count
ctComm <- as.matrix(table(text$comm_date))

ctComm <- data.frame(Date = rownames(ctComm), ctComm = ctComm[,1])

ctComm$Date <- as.Date(ctComm$Date)

rownames(ctComm) <- NULL

# plot cumulative sum of comments
commPlot <- ctComm %>% 
  ggplot(., aes( x=Date, y = cumsum(ctComm)), 
         type = 'l', main = 'cumulative count')+
  geom_point(size = 1.5, color = '#ffc425')+
  geom_line(size = 1.2, color = '#ffc425')+
  geom_vline(xintercept = as.numeric(as.Date("2021-01-25")), linetype=2)+ 
  theme_minimal()+
  labs(x='Date', y='Sum of Comments')

# show plot
commPlot



# checking words occurrence
checkDiamond <- grepl('diamond', text$text, ignore.case = T)

checkPaper <- grepl('paper', text$text, ignore.case = T)

checkMoon <- grepl('moo*n', text$text, ignore.case = T)

# occurrence in percentage to compare slang words
mean(checkDiamond) * 100

mean(checkPaper) * 100

mean(checkMoon) * 100



# WFM
topWords <- colSums(DTM)

# organize matrix
WFM <- data.frame(term = names(topWords), frequency = topWords)

rownames(topWords) <- NULL

WFM <- WFM[order(WFM$frequency, decreasing = T),]


# plot WFM with 15 most used
plotWords <- data.frame(term = WFM$term[1:15], frequency = WFM$frequency[1:15])

ggplot(plotWords, aes(reorder(term,frequency), frequency)) + 
  geom_bar(stat="identity", fill = 'brown2') + 
  coord_flip()+
  theme_minimal()+
  theme(axis.text.x=element_blank(), text = element_text(size=15))+
  labs(x='Terms', y='Frequency')+
  geom_text(aes(label=frequency), colour="white",hjust=1.25, size=4.0)



# selecting terms to plot over time
plotCorp <- tidyCorpSent %>% 
  filter(term == "buy" |term == "hold")

plotCorp <- aggregate(count~comm_date + term, plotCorp, sum) 

plotCorp <- plotCorp[order(plotCorp$comm_date),]

# plot mentions over time alone
# ggplot(plotCorp, aes(x=comm_date, y=count, color = term))+
#          geom_point()+
#          geom_line()+
#          theme_minimal()+
#          labs(x='Date', y = 'Mentions') + 
#          scale_color_manual(values=c('brown2', '#ffc425'))


# joining data to compare terms selected and stock volume 
gme_df$Date <- as.Date(gme_df$Date)

plotWV <- as.data.frame(plotCorp)

plotWV <- left_join(plotCorp, gme_df, by = c('comm_date'='Date'))

# plot
plotWV %>% 
  ggplot() +
  geom_bar(aes(x=comm_date, y=GME.Volume/2),stat="identity", fill="#cccccc")+
  geom_line(aes(x=comm_date, y=count*500000, color = term), size = 1.2)+
  geom_point(aes(x=comm_date, y=count*500000, color = term), size = 1.5 )+
  scale_color_manual(values=c('#f37735', '#ffc425'))+
  scale_y_continuous(sec.axis = sec_axis(~./500000, name = "Mention Count"),
                     labels = unit_format(unit = "M", scale = 1e-6))+
  labs(x = 'Date', y= 'GME Volume')+
  theme_minimal()+
  theme(legend.title = element_text(size = 15, face="bold"),
        legend.text = element_text(size = 15))



# # associations for word sell if it is matched with negative terms
# associations <- findAssocs(txtDTM, "sell", 0.15)
# 
# # organize associations
# assocs <- data.frame(terms=names(associations[[1]]),
#                      value=unlist(associations))
# assocs$terms <- factor(assocs$terms, levels=assocs$terms)
# rownames(assocs) <- NULL
# 
# # dot plot for associations
# ggplot(assocs, aes(y=terms)) +
#   geom_point(aes(x=value), data=assocs, color='brown2') +
#   geom_text(aes(x=value,label=value), nudge_x = 0.01, size=5.5) +
#   theme_minimal()





#################
# SENTIMENT ANALYSIS

# polarity lexicon
afinn <- get_sentiments(lexicon = c("afinn"))

# adding words to lexicon to adjust to WSB slang
new_sentiment <- tibble(word=c("moon","tendies", "yolo", "paper", "diamond"),
                        value=c(4, 1, 3, -3, 2))

wsb_afinn <- get_sentiments(lexicon = c("afinn"))%>%
  rbind(new_sentiment)


# join polarity
sent <- left_join(tidyCorpSent, wsb_afinn, by = c('term'='word'))


# examine the quantity
sent$amt<- sent$count * sent$value

# convert to date & reorder
sent$comm_date <- as.Date(sent$comm_date)

sentTemp <- aggregate(amt~comm_date, sent, mean)

sentTemp$comm_date <- as.Date(sentTemp$comm_date)

sentTemp <- sentTemp[order(sentTemp$comm_date),]


# plot
sentPlot <- sentTemp %>% 
  ggplot(., aes(x=comm_date, y=amt))+
  geom_point(size = 1.5, color = '#f37735')+
  geom_line(size = 1.2, color = '#f37735')+
  geom_vline(xintercept = as.numeric(as.Date("2021-01-25")), linetype=2)+ 
  labs(y= 'Average Afinn Sentiment')+
  theme_minimal()+
  theme(axis.title.x=element_blank(), axis.text.x=element_blank())
  

sentPlot

# plotting two figures together to compare
grid.newpage()
grid.draw(rbind(ggplotGrob(sentPlot), ggplotGrob(commPlot), size = "last"))





#################
# SENTIMENT ANALYSIS WITH EMOTIONS

# subset again for period of interest for predictions
textPred <- subset(text, comm_date <= as.Date('2021-01-28'))

# creating corpus and cleaning
txtDTMP <- VCorpus(VectorSource(textPred$text))
txtDTMP <- cleanCorpus(txtDTMP, stops)

# dtm
txtDTMP <- DocumentTermMatrix(txtDTMP)

# tidy
tidyCorpPred <- tidy(txtDTMP)



# using affect word-net
# get emotions from lexicon
emotionLex <- affect_wordnet

emotionLex <- subset(emotionLex, 
                     emotionLex$emotion=='Positive'|emotionLex$emotion=='Negative')

# inner join with tidy corpus
lexSent <- inner_join(tidyCorpPred,emotionLex, by=c('term' = 'term'))

# prepare for plot
emotionID <- aggregate(count ~ category, lexSent, sum)

# radar chart
emotionID %>% 
  e_charts(category) %>% 
  e_radar(count, max =max(emotionID$count), 
          name = "WSB Emotional Categories (10th to 28th January)") %>%
  e_tooltip() %>% e_theme("red")



# END
