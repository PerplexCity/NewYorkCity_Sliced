library(ggplot2)
library(ggmap)

pizza <- read.csv("~/Desktop/pizza_spots.csv")

#gets map of New York City
nycmap <- get_map(location = c(-74.05, 40.67, -73.9, 40.84), source = "osm")

#first map is just of pizza places
pizza_loc <- ggmap(nycmap) +
  geom_point(data=pizza, 
             aes(x = long, 
                 y = lat),
             col = "red",
             size = 1.5, shape = 16, alpha = 0.6) + 
  labs(x="longitude", y="latitude", 
       title= "Pizza Places in NYC") + 
  theme(title=bbi)

#for next map we have to recreate coordinates
#and then measure how many places are nearby and what they're ratings are

#custom mode function since for some reason R doesn't have one
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

#chops map 200 times in both directions
#determines which places are within ~1000 feet (.003 length degree radius)
#for ones that are (TRUE), creates "hood" subset with new column for rounded-up stars
#finally adds the longitude, lattitude, count, and class for each coordinate
coords <-data.frame(lat=integer(), long=integer(), near=integer(), class=integer())
for (i in 0:200){
  for (j in 0:200){
    lat <-40.67+i*.00085
    long <- -74.05+j*.00075
    pizza$test <- as.numeric(((pizza$lat-lat)^2 + (pizza$long-long)^2)^.5<.003)
    hood <- subset(pizza, test==TRUE)
    hood$stars2 <- ceiling(hood$stars)
    count<-nrow(hood)
    starsort <-sort(hood$stars2, decreasing=TRUE)
    class <- getmode(starsort)
    
    coords <- rbind(coords, c(lat, long, count, class))
  }
}

names(coords) <- c("lat", "long", "count", "Rating")
coords$Rating <- as.factor(coords$Rating)

#map of number of places within 1000 feet
pizza_thousand <- ggmap(nycmap) +
  geom_point(data = subset(coords, count>0), aes(x = long, y = lat, 
                                                 colour = count), 
             size = 1, shape = 16, alpha=0.7) + 
  scale_colour_gradient2(low="yellow",  
                         high = "red", 
                         mid="orange", 
                         limits=c(1,17), 
                         midpoint = 8) +
  labs(x="longitude", y="latitude", 
       title= "Pizza Places within ~1000 ft") + 
  theme(title=bbi)

#map of classification within 1000 feet
pizza_thousand_class <- ggmap(nycmap) +
  geom_point(data = subset(coords, count>0), 
             aes(x = long, y = lat, colour = Rating), 
             size = 1, shape = 16, alpha=0.5) +
  guides( size=FALSE) + 
  scale_colour_manual(drop=TRUE, 
                      limits = levels(coords$Rating),
                      values = c("white", "gray", "yellow", "orange", "red")) + 
  labs(x="longitude", 
       y="latitude", 
       title="Pizza Classification by ~1000 ft") +
  theme(title=bbi, legend.key.size=unit(1,"cm"))

#to get the individual maps for the GIF, change the radius in the for loop
# .001 degrees latitude ~=~ 300 feet