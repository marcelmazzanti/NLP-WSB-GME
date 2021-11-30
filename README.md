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


