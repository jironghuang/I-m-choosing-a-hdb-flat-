# I'm choosing a hdb flat!
I've decided to use a slightly more rigorous approach to choose my BTO flat - by first scraping the data from hdb website. Second, I tidied the data into a structured format. Lastly I construct a model by assigning a weight of 0 to 5 for important factors and 0 to 3 for not so important ones. Here're all the factor that I consider.

- Afternoon sun
- Near main road
- Near rubbish bin
- Near pavallion
- Near hard court
- Anything in void deck
- Is it a low floor -> weight of 0 to 5 from lowest to second highest floor
- Is it the highest floor (not good since there's nothing blocking you)
- Is it near playground
- Is it near bus stop
- Is it near mrt
- Floor plan
- 90 or 93 square feet
- Is it airy enough? Near parks? Or is it surrounded by flats (not too good). People may see what you're doing.

You may take a look at my code if you're interested! 
