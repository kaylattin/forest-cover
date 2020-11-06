### EXTRACTING % MEAN FOREST COVER FOR PRELIMINARY ANALYSIS -----
# done to see whether changing buffer distance / stop length makes a difference in forest cover estimates


# Reproject my layers to the correct datum - NAD 1983 to match my shapefiles
# EPSG:4269


library(raster)
library(rgdal)

setwd()

can11_1000 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b11_1000")
can11_400 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b11")
can11_600 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b11_600")
can11_800 <- readOGR(dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="b11_800t")

can3_1000 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b3_1000")
can3_400 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b3")
can3_600 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b3_600")
can3_800 <-readOGR(dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="b3_800")

can6_1000 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b6_1000t")
can6_400 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b6")
can6_600 <-readOGR(dsn="/Users/kayla/Documents/BBS data", layer="b6_600")
can6_800 <-readOGR(dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="b6_800")

setwd(file.path('C:','Users','kayla','Documents','THESIS','FOREST LAYERS'))

forest2000 <- raster("forestcover_2000.tif")
forest2018 <- raster("cover2018_f.tif")

## ////////////////// 11 stops ///////////////////

# Extract mean % values for 2000 and 2018, 11 stops, buffer = 1km 
stops11_1000 <- extract(forest2018,can11_1000,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops11_1000_2 <- extract(forest2000,can11_1000,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops11_1000,dsn="/Users/kayla/Documents/BBS data", layer="stops11_1000", driver="ESRI Shapefile")
writeOGR(stops11_1000_2,dsn="/Users/kayla/Documents/BBS data", layer="stops11_1000_2", driver="ESRI Shapefile")

# 11 stops, buffer = 400 m
stops11_400 <- extract(forest2018,can11_400,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops11_400_2 <- extract(forest2000,can11_400,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops11_400,dsn="/Users/kayla/Documents/BBS data", layer="stops11_400", driver="ESRI Shapefile")
writeOGR(stops11_400_2,dsn="/Users/kaylaDocuments/BBS data", layer="stops11_400_2", driver="ESRI Shapefile")

# 11 stops, buffer = 600 m
stops11_600 <- extract(forest2018,can11_600,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops11_600_2 <- extract(forest2000,can11_600,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops11_600,dsn="/Users/kayla/Documents/BBS data", layer="stops11_600", driver="ESRI Shapefile")
writeOGR(stops11_600_2,dsn="/Users/kayla/Documents/BBS data", layer="stops11_600_2", driver="ESRI Shapefile")

# 11 stops, buffer = 800 m

stops11_800 <- extract(forest2018,can11_800,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops11_800_2 <- extract(forest2000,can11_600,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops11_800,dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="stops11_800", driver="ESRI Shapefile")
writeOGR(stops11_800_2,dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="stops11_800_2", driver="ESRI Shapefile")

## /////////////// 3 stops ////////////////////

# 3 stops, buffer = 1km
stops3_1000 <- extract(forest2018,can3_1000,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops3_1000_2 <- extract(forest2000,can3_1000,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops3_1000,dsn="/Users/kayla/Documents/BBS data", layer="stops3_1000", driver="ESRI Shapefile")
writeOGR(stops3_1000_2,dsn="/Users/kayla/Documents/BBS data", layer="stops3_1000_2", driver="ESRI Shapefile")

# 3 stops, buffer = 400 m
stops3_400 <- extract(forest2018,can3_400,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops3_400_2 <- extract(forest2000,can3_400,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops3_400,dsn="/Users/kayla/Documents/BBS data", layer="stops3_400", driver="ESRI Shapefile")
writeOGR(stops3_400_2,dsn="/Users/kayla/Documents/BBS data", layer="stops3_400_2", driver="ESRI Shapefile")

# 3 stops, buffer = 600 m
stops3_600 <- extract(forest2018,can3_600,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops3_600_2 <- extract(forest2000,can3_600,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops3_600,dsn="/Users/kayla/Documents/BBS data", layer="stops3_600", driver="ESRI Shapefile")
writeOGR(stops3_600_2,dsn="/Users/kayla/Documents/BBS data", layer="stops3_600_2", driver="ESRI Shapefile")

# 3 stops, buffer = 800 m

stops3_800 <- extract(forest2018,can3_800,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops3_800_2 <- extract(forest2000,can3_800,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops3_800,dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="stops3_800", driver="ESRI Shapefile")
writeOGR(stops3_800_2,dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="stops3_800_2", driver="ESRI Shapefile")

## ///////////////// 6 stops //////////////////

# 6 stops, buffer = 1km
stops6_1000 <- extract(forest2018,can6_1000,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops6_1000_2 <- extract(forest2000,can6_1000,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops6_1000,dsn="/Users/kayla/Documents/BBS data", layer="stops6_1000", driver="ESRI Shapefile")
writeOGR(stops6_1000_2,dsn="/Users/kayla/Documents/BBS data", layer="stops6_1000_2", driver="ESRI Shapefile")

# 6 stops, buffer = 400 m
stops6_400 <- extract(forest2018,can6_400,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops6_400_2 <- extract(forest2000,can6_400,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops6_400,dsn="/Users/kayla/Documents/BBS data", layer="stops6_400", driver="ESRI Shapefile")
writeOGR(stops6_400_2,dsn="/Users/kayla/Documents/BBS data", layer="stops6_400_2", driver="ESRI Shapefile")

# 6 stops, buffer = 600 m
stops6_600 <- extract(forest2018,can6_600,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops6_600_2 <- extract(forest2000,can6_600,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops6_600,dsn="/Users/kayla/Documents/BBS data", layer="stops6_6002", driver="ESRI Shapefile")
writeOGR(stops6_600_2,dsn="/Users/kayla/Documents/BBS data", layer="stops6_600_4", driver="ESRI Shapefile")

# 6 stops, buffer = 800 m
stops6_800 <- extract(forest2018,can6_800,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
stops6_800_2 <- extract(forest2000,can6_800,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(stops6_800,dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="stops6_800", driver="ESRI Shapefile")
writeOGR(stops6_800_2,dsn="/Users/kayla/Documents/BBS data_March11/BBS data_March10/BBS data", layer="stops6_800_2", driver="ESRI Shapefile")