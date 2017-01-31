# I'm choosing a hdb flat!
I've decided to use a slightly more rigorous approach to choose my BTO flat. 

First, I scraped the data from hdb website (saved all https web pages into a folder). Then, I cleaned the data into a structured long format. Lastly I construct a model by assigning a weight of 0 to 5 for important factors and 0 to 3 for not so important ones. Here're all the factors that I consider.

- Is there afternoon sun
- Is it near main road
- Is it near rubbish dump
- Is it near pavallion
- Is it near hard court
- Is there anything in void deck
- Is it a low floor -> weight of 0 to 5 from lowest to second highest floor
- Is it the highest floor (not good since there's nothing blocking you)
- Is it near playground
- Is it near bus stop
- Is it near mrt
- How's the floor plan
- 90 or 93 square feet?
- Is it airy enough? Near parks? Or is it surrounded by flats (not too good). People may see what you're doing.

You may take a look at my R code if you're interested to find out more! 
