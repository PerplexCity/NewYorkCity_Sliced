# NewYorkCity, Sliced

The project begins by using yelp_pizza.py(https://github.com/PerplexCity/NewYorkCity_Sliced/blob/master/yelp_pizza.py) to make calls to Yelp's API at specific, sequential longitudinal and latitudinal coordinates. The script is a slightly modified version of [Philip Johnson's from "Let's Talk Data,"] (http://letstalkdata.com/2014/02/how-to-use-the-yelp-api-in-python/) so shoutout to him for doing some of the legwork. Although the for loop as is creates over 20,000 points, *don't call the Yelp API for all of them in one sitting*. Yelp limits you to 10,000 calls per day, so split it up over the course of a week if you do something with that many calls.

Once the data is gathered it's put into [pizza_spots.csv](https://github.com/PerplexCity/NewYorkCity_Sliced/blob/master/pizza_spots.csv). This version has been cleaned of duplicates and restaurants with fewer than ten reviews.

Finally, the graphs are made by feeding that data into [pizzza_graphs.R](https://github.com/PerplexCity/NewYorkCity_Sliced/blob/master/yelp_pizza.py)

