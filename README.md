# I'm choosing a hdb flat!
*With massive inputs from Sheena ng*

Just 3 weeks (at the point of writing in early Feb) before choosing a flat, I finally found some time to ponder on how to pick a flat from a sea of choices. 

It also happens to be my 1 week break before my next job.
 
Being an analyst by training, I thought - instead of using a conventional approach, should I use a model to pick our flat instead? Since the flat is going to be one of our heftiest purchases in our lifetime. 

Yes, during my well-deserved break, I set out to develop a very simple model.

First, I began to gather the data. However, the data in the hdb website doesn't seem to be in a nicely structured format. Fortunately ,I've some experience in scraping web data. As the website is in https format, I'm unable to access the website directly from a programme. Hence, I proceed to save the web pages instead in html format for each respective block number. Here's a print screen of how the raw data looks like.

Note: I probably would have been able to figure how to access https pages after many more countless hours. But this is counter-productive given that there are only 30 blocks to choose from.

With the raw html pages saved in a folder, I proceed to extract the data from html files using R programme. Some of the data extracted is,

1. Housing prices
2. Unit number - subsequently separated into floor and unit number. Floor to see if it's the highest level
3. Whether the unit is already chosen
4. Floor space

With these data extracted, I'm able to compute the monthly mortgage to be paid, floor level, demand and supply in all the blocks.

Second, I began to ponder on other potential factors that may affect future 'returns' and our preferences.

Given that this is not my domain area of knowledge, I began to gather massive inputs from my girlfriend and her dad. 

Eventually, my girlfriend and I settled on the following factors that we should consider,

- Is there afternoon sun
- Is it near a main road
- Is it near a rubbish dump
- Is it near a pavallion
- Is it near a hard court
- Is it near a void deck
- Is it a low floor -> weight of 0 to 5 from lowest to second highest floor
- Is it the highest floor
- Is it near a playground
- Is it too near to a bus stop
- Is it near mrt
- Floor plan
- Size of house: 90 or 93 square feet
- Is it airy enough? Near parks? Or is it surrounded by flats (not too good). People may see what you're doing
-Does the unit number sounds auspicious or inauspicious? May matter if sell it to superstitious families

We then proceed to assign weights of 3 to 5 for each of them - 5 for the important factors and 3 for less so important ones.

Short of constructing a regression or any machine learning model for the weights (because I've no idea on how to obtain the above data on existing estates), we proceed to assign a score w.r.t the factor for each unit with a cap of weight to the factor. i.e. if we assign a weight of 3 to playground, we wouldn't assign a weight beyond 3 for that particular unit. We would assign a weight of 2 for a house that's not too near and far from the playground. I hope you get the idea.
 
We then proceed to multiply all the weights to derive a score for each unit.

This may sound onerous you think? By ranking all the units?! Yes, to a certain extent. But we're not assigning a score on each attribute for all the units. Simply because if a score of 0 is assigned to an attribute, we can save the effort of assigning a score to rest of the attributes. When you multiply 0 with any other numbers, it's still 0. So we can save our efforts on this.

I did consider to programmatically  find out the distance from mrt using postal codes. This could be done for exisiting places, but not for incomplete ones.

With the scores, we're able to rank all the units. There're some advantages using this approach,
- First, given that there are still 3 weeks to pick a flat, many of our top choices would have already been chosen. Instead of repeating  the exercise all over again, we could revisit our choices 1 day before our BIG OCCASION and strike out all the already chosen flats.
- Second, we also consider a suite of factors - instead of just a single factor that could potentially cloud our judgment.

Caveats
- A better approach is to conduct a longitudinal panel regression - with the price as dependent variable and the attributes as dependent variables
- Or carry out a comprehensive revealed preference survey with me and my gf. Essentially 2 data points:)

Yes, that's it. You may PM me if you're keen to find out the technical details.

Meanwhile, we can only hope for the best.

