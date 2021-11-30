# Natural Language Processing Analysis 
### Could Hedge Funds predict the Game Stop short squeeze by analysing Reddit's comments?

Retail investors are representing an increasing market risk for Hedge Funds, a dimostration was the case of GameStop (GME), when in January 2021 losses larger than 50% on large short-selling postions were recorded for many funds.
It all started from a Reddit blog called Wall Street Bets (WSB), where small investors deliberately decided to act bullish on $GME to contrast big funds. 

This analysis aims at identifying early indicators within the  not-always-technical language used in the blog, in order to give insights on how to avoid or exploit similar future scenarios.
The data comes directly from the Reddit Forum API for WSB, selecting posts containing GME and sub-setted to frame the period of interest (January 10th to February 2nd).


## Stock Performance

Over the selected period the GME stock was incredibly volatile, rising with a very steep trend. To give a reference, we can see the change in price compared to the S&P500 index throughout that period:


![Alt text](https://github.com/marcelmazzanti/NLP-WSB-GME/blob/0021a8dc7ea61e084690b9ccbf142df9c1bf6f08/stock-compare.png "Stock Comparison")



## Frequent Terms

To assess the kind of lexicon used, the first thing we check is the terms that are used the most within the comments:


![Alt text](https://github.com/marcelmazzanti/NLP-WSB-GME/blob/c30b7407fc37edf76ee2858e95fb288ff25e215d/frequent-terms.png "Frequent Terms")

It is already clear that the language is often aggressive and sarcastic, and a very specific slang is used. apart from technical financial terms, we notice words like "moon" because as the stock value was going up, the motto in the blog became "to the moon", indicating excitement for the high returns implied.

Performance related words are also used to indicate the relative size, growth or shrink of investments made. The majority of the terms, however, seem to be focused on trading suggestions on whether to hold, buy or sell the stock. It is interesting to see when those terms are used the most over the period when the large volume of transactions kept the stock fluctuating:


![Alt text](https://github.com/marcelmazzanti/NLP-WSB-GME/blob/5b192be65baf5cec9e003d8050045071db15fd6e/stock-terms.png "Terms and Volume")


Buy and hold, which are among the most used terms, seem to be used in a similar amount and in the same occasions. The moments when the two terms peak are, when the volume of transactions is going down and, comparing the dates with the price change, we can see in these moments are also when people are selling the most. Hence, the words are used as a consequence to persuade investors not to sell, but just to buy or hold on.



## Sentiment Analysis

A sentiment analysis was conducted to understand if the language used expressed negative or positive emotional intent, using the Afinn Score Package in R. A score for terms that are often seen in catch phrases is manually implemented to increase relevance of the analysis (e.g. “to the moon”, is present in 13% of all the comments). The following graphs define the average sentiment over time and how it changes from positive to negative, also in relation with the total number of comments:


![Alt text](https://github.com/marcelmazzanti/NLP-WSB-GME/blob/e2e5e1c7bbcfc44bf32e61f3094f108c2433a918/afinn.png "Afinn Score")


The sentiment sarts with a highly positive score, but is defined by very few comments, as the number of contributors increases toward the most hectic days the sentiment decreases sharply. Averagin around a slighlty neutral and negative score, a positive peak can be found the day before the stock price rises substantially.

Going deeper on the analysis of the comments, a specific package can also be used to map the emotions expressed with the words used on the blog. Limiting the dataset to the days before the stock plunged (in order to avoid outliers toward sadness and fear) the following map highlights these emotions:

![Alt text](https://github.com/marcelmazzanti/NLP-WSB-GME/blob/86a8d3d04aead1e8e40854602ab94ab0a8942bd5/emotions.png "Emotions")

Two very different emotional outcomes are indicated, both understandable if the level of involvement that 

<img width="536" alt="emotions" src="https://user-images.githubusercontent.com/77210085/143980702-9e587891-5593-4531-87d4-3a1fd53f7cbc.png">

