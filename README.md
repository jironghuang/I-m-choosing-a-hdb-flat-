# I'm choosing a hdb flat!
*With massive inputs from Sheena Ng!*

*You may visit the following github link if would like to refer to the code/further technical details - https://github.com/jironghuang/I-m-choosing-a-hdb-flat-/blob/master/Analysing%20hdb%20flats.R*

Just 3 weeks (at the point of writing in early Feb) before choosing a flat, I'm finally able to find some time to pick a flat from a sea of choices. 

It's also my 1 week break before the next job.
 
Being an analyst by training, I thought to myself- instead of using a conventional approach (in layman's terms, it's called gut instinct), should I use a model to pick our flat instead? Since the flat would be one of our heftiest purchases ever.

As you might have guessed from the title, I choose the latter. Yes, I set out to develop a simple model.

But how? Read on to find out.

# Finding the data
First, I gather the data. But I meet my first roadblock since the data in the hdb website doesn't seem to be in a nice friendly structured format for analysis. Fortunately, I had some experience in scraping web data. As the website is in https format, I'm unable to access the website directly from a programme. Hence, I proceed to save the web pages instead in html format for each respective block number. If you're curious to find out, here's how the raw data looks like,


With the raw html pages saved in a folder, I proceed to programmatically extract the data from html files using R by identifying the relevant 'nodes'.  Here's a snippet of how the structured data looks like.


Some of the data fields extracted are,

1. Housing prices
2. Unit number - I subsequently separate this into floor and unit number. 
3. Has the unit been chosen
4. Floor space

With this, I'm able to compute the monthly mortgage to be paid, floor level, demand and supply in all the blocks.

#Are there any other factors? Seeking experts' opinions
Second, I begin to think of other potential factors that may affect future 'returns' and our preferences.

Given that this is not my domain area of knowledge, I sought expert opinions...from my girlfriend, her dad and my cousin!

With the very valuable inputs and much deliberation, my girlfriend and I eventually settle on the following factors for consideration,

- Is there afternoon sun (facing west?)
- Is it near a main road
- Is it near a rubbish dump
- Is it near a pavilion
- Is it near a hard court
- Is it near a void deck
- Is it a low floor
- Is it the highest floor: Concrete absorbs heat and dissipate them at night. Hence we avoid this at all costs!
- Is it near a playground
- Is it too near to a bus stop
- Is it near mrt
- Floor plan
- Size of house
- Is it airy enough? Near parks? Or is it surrounded by flats (not too good for privacy too). 
- Does the unit number sound auspicious or inauspicious? May matter if we sell it to superstitious families

We then proceed to assign weights of 1 to 5 for each of them - 5 for the important factors and 1 for the least important one. I shall leave that to you to decide which is the important one for you  because we're none the wiser.

Short of constructing a regression or any fancy machine learning model for the weights (because I've no idea how to obtain the above data on existing estates), we proceed to assign a score of 1 to 5 for each unit factor. 
 
For each unit, we find the geometric average using the weights and scores. I shall leave you to 'google' on geometric average:) 

Now we end up with a score for each unit for ranking. This may sound onerous you think? By ranking all the units?! Yes, to a certain extent. But we're not assigning a score on each attribute for all the units. Simply because if a score of 0 is assigned to an attribute, we can save the effort of assigning a score to rest of the attributes. When you multiply 0 with any other numbers, it's still 0. So we can save our time and efforts on this.

I did consider to programmatically  find out the distance from mrt using postal codes. This could be done for exisiting places, but not for incomplete ones.

With the scores, we're able to rank all the units. There're some advantages using this approach,
- First, given that there are still 3 weeks to pick a flat, many of our top choices would have already been chosen. Instead of repeating  the exercise all over again, we could revisit our choices 1 day before our BIG OCCASION and strike out all the already chosen flats.
- Second, we also consider a suite of factors - instead of just a single factor that could potentially cloud our judgment.

# Even better suggestions for you!
- A scientific approach may be to conduct a longitudinal panel regression on existing estates- with the price as dependent variable and the attributes as independent variables
- Or carry out a comprehensive revealed preference survey with me and my girlfriend. Essentially 2 data points:)

Yes, that's it. You may PM me or visit my github link if you're keen to find out the codes/technical details.

Hopefully, this provides a useful framework for anyone who wishes to choose a BTO flat using a slightly more rigorous way. Pls feel free to adapt or adopt my very simple approach.

Meanwhile, we are keeping our fingers crossed while hoping for the best. Trust that this would be time well spent for our pick. We shall know.
