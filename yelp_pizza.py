import rauth
import time
import json
import csv

#create empty lists for coordinates and restaurants
LL = []
restaurants= []

for i in range(150):
	for j in range(150):
		LL.append((40.65+i*0.002,-74.1+i*0.0015))


#formats coordinate duples for the Yelp API
def get_search_parameters(lat,long):
	#See the Yelp API for more details
	params = {}
	params["category_filter"] = "pizza"
	params["ll"] = "{},{}".format(str(lat),str(long))
	params["radius_filter"] = "500"
	return params		

#Makes API call
def get_results(params):

	#Get your own from Yelp!
  	consumer_key = "XXXXXX"
	consumer_secret = "XXXX"
	token = "XXXX"
	token_secret = "XXXXX"
	
	session = rauth.OAuth1Session(
		consumer_key = consumer_key
		,consumer_secret = consumer_secret
		,access_token = token
		,access_token_secret = token_secret)
		
	request = session.get("http://api.yelp.com/v2/search",params=params)
	
	#let's us know if something goes wrong
	try:
		data = request.json()
	except ValueError:
		print "Error"
		print params

	session.close()
	
	#creates a tuple for each pizza place with name, rating, location, and review count
	#adds it to list of restaurants
	for i in range(len(data['businesses'])):
		try:
			tape = (data['businesses'][i]['name'],
			data['businesses'][i]['rating'],
			data['businesses'][i]['location']['coordinate']['latitude'],
			data['businesses'][i]['location']['coordinate']['longitude'],
			data['businesses'][i]['location']['postal_code'],
			data['businesses'][i]['review_count'])
			restaurants.append(tape)


#calls the API with each coordinate
def main():
	api_calls = []
	for lat,long in LL:
		params = get_search_parameters(lat,long)
		api_calls.append(get_results(params))
		
		#making the script sleep for a beat will keep us from pissing off Yelp
		time.sleep(1)

#don't run this all at once! Change the range of the coordinates, otherwise you'll go over the 10K call limit!
main()

#prints unique results. Write to a csv if you'd prefer
for tape in set(restaurants):
	print tape[0] + ',' + str(tape[1]) + ',' + str(tape[2]) + ',' + str(tape[3]) + ',' + tape[4] + ',' + str(tape[5])'''