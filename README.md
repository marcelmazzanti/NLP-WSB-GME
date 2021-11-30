# Natural Language Processing Analysis 
### Could Hedge Funds predict the Game Stop short squeeze by analysing Reddit's comments?

Retail investors are representing an increasing market risk for Hedge Funds, a dimostration was the case of GameStop (GME), when in January 2021 losses larger than 50% on large short-selling postions were recorded for many funds.
It all started from a Reddit blog called Wall Street Bets (WSB), where small investors deliberately decided to act bullish on $GME to contrast big funds. 

This analysis aims at identifying early indicators within the  not-always-technical language used in the blog, in order to give insights on how to avoid or exploit similar future scenarios.
The data comes directly from the Reddit Forum API for WSB, selecting posts containing GME and sub-setted to frame the period of interest (January 10th to February 2nd).


## Stock Performance

Over the selected period the GME stock was incredibly volatile, rising with a very steep trend. To give a reference, we can see the change in price compared to the S&P500 index throughout that period:


<img width="580" alt="stock-compare" src="https://user-images.githubusercontent.com/77210085/143980886-aeb7a949-f6d0-41d2-a367-336823d4ffe0.png">



## Frequent Terms

To assess the kind of lexicon used, the first thing we check is the terms that are used the most within the comments:

<img width="580" alt="frequent-terms" src="https://user-images.githubusercontent.com/77210085/143980911-7ae13b37-11c6-41e8-8a5a-4a45f5327eeb.png">


It is already clear that the language is often aggressive and sarcastic, and a very specific slang is used. apart from technical financial terms, we notice words like "moon" because as the stock value was going up, the motto in the blog became "to the moon", indicating excitement for the high returns implied.

Performance related words are also used to indicate the relative size, growth or shrink of investments made. The majority of the terms, however, seem to be focused on trading suggestions on whether to hold, buy or sell the stock. It is interesting to see when those terms are used the most over the period when the large volume of transactions kept the stock fluctuating:

<img width="580" alt="stock-terms" src="https://user-images.githubusercontent.com/77210085/143980935-caa01143-5049-4c8d-99f9-f5e181c0570f.png">


Buy and hold, which are among the most used terms, seem to be used in a similar amount and in the same occasions. The moments when the two terms peak are, when the volume of transactions is going down and, comparing the dates with the price change, we can see in these moments are also when people are selling the most. Hence, the words are used as a consequence to persuade investors not to sell, but just to buy or hold on.



## Sentiment Analysis

A sentiment analysis was conducted to understand if the language used expressed negative or positive emotional intent, using the Afinn Score Package in R. A score for terms that are often seen in catch phrases is manually implemented to increase relevance of the analysis (e.g. “to the moon”, is present in 13% of all the comments). The following graphs define the average sentiment over time and how it changes from positive to negative, also in relation with the total number of comments:

<img width="580" alt="afinn" src="https://user-images.githubusercontent.com/77210085/143980956-8b6f5c62-6f42-4b07-88e2-d150c505a83d.png">



The sentiment sarts with a highly positive score, but is defined by very few comments, as the number of contributors increases toward the most hectic days the sentiment decreases sharply. Averagin around a slighlty neutral and negative score, a positive peak can be found the day before the stock price rises substantially.

Going deeper on the analysis of the comments, a specific package can also be used to map the emotions expressed with the words used on the blog. Limiting the dataset to the days before the stock plunged (in order to avoid outliers toward sadness and fear) the following map highlights these emotions:

<img width="580" alt="emotions" src="https://user-images.githubusercontent.com/77210085/143980702-9e587891-5593-4531-87d4-3a1fd53f7cbc.png">

Two very different emotional outcomes are indicated, both understandable considering the level of financial involvement that many of these investors seemed to have in the stock. Joy was likely found in comments made when $GME value was rapidly growing, Love was be expressed toward peer reddittors for showing they were buying the stock, or at least not selling it. Finally, anxiety and fear were occurring because of money loss. To better understand the ongoing scenario, it is important to know that, during the timeframe considered, the most common trading platforms (e.g. Robinhood) closed the possibility to buy the stock due to high volatility, allowing investors to only sell it.

<img width="580" alt="volatility" src="https://user-images.githubusercontent.com/77210085/143981746-710565ca-77de-4c71-8438-ccccf4a06e05.png">


This incredible volatility and the incresing risk of loss caused by regulators, explain the peaks in negative emotions expressed, as a consequence of a sitback in the stock price. 




The nature of the stock market makes it difficult for any prediction to be reliable

Increase in positive sentiment and expression of positive emotions might be an indicator of collective excitement and larger shares buying volumes

When words such as “hold” start to be used more fear and anxiety are likely to take over resulting in higher selling volumes


