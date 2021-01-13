# 1km, 11-stop buffer
library(raster)
library(rgdal)

setwd("D:/US layers")

buffer <-readOGR(dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Working files - Mar27", layer="buffer_Mar27")

setwd(file.path('C:','Users','kayla','Documents','THESIS','FOREST LAYERS'))
forest2000 <- raster("forestcover_2000.tif")
forest2018 <- raster("cover2018_f.tif")

results <- extract(forest2018,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results2 <- extract(forest2000,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)

writeOGR(results,dsn="/Users/kayla/Documents/BBS data", layer="FOREST_2018_Mar27", driver="ESRI Shapefile")
writeOGR(results2,dsn="/Users/kayla/Documents/BBS data", layer="FOREST_2000_Mar27", driver="ESRI Shapefile")

# ////// yearly estimates

setwd(file.path('C:','Users','kayla','Documents','WORKING BBS DATA','BBS data','Working files - Mar27'))

buffer <- readOGR(dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Working files - Mar27", layer="buffer_Mar27")


setwd(file.path('C:','Users','kayla','Documents','THESIS','CANADA FOREST LAYERS'))
forest2001 <-raster("cover2001_f.tif")
forest2002 <-raster("cover2002_f.tif")
forest2003 <-raster("cover2003_f.tif")
forest2004 <-raster("cover2004_f.tif")
forest2005 <-raster("cover2005_f.tif")
forest2006 <-raster("cover2006_f.tif")
forest2007 <-raster("cover2007_f.tif")
forest2008 <-raster("cover2008_f.tif")
forest2009 <-raster("cover2009_f.tif")
forest2010 <-raster("cover2010_f.tif")
forest2011 <-raster("cover2011_f.tif")
forest2012 <-raster("cover2012_f.tif")
forest2013 <-raster("cover2013_f.tif")
forest2014 <-raster("cover2014_f.tif")
forest2015 <-raster("cover2015_f.tif")
forest2016 <-raster("cover2016_f.tif")
forest2017 <-raster("cover2017_f.tif")


results1 <- extract(forest2001,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results2 <- extract(forest2002,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results3 <- extract(forest2003,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results4 <- extract(forest2004,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results5 <- extract(forest2005,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results6 <- extract(forest2006,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results7 <- extract(forest2007,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results8 <- extract(forest2008,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results9 <- extract(forest2009,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results10 <- extract(forest2010,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results11 <- extract(forest2011,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results12 <- extract(forest2012,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results13 <- extract(forest2013,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results14 <- extract(forest2014,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results15 <- extract(forest2015,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results16 <- extract(forest2016,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)
results17 <- extract(forest2017,buffer,fun=mean,df=TRUE,sp=TRUE,normalizeWeights=TRUE)


writeOGR(results1,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2001", driver="ESRI Shapefile")
writeOGR(results2,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2002", driver="ESRI Shapefile")

writeOGR(results3,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2003", driver="ESRI Shapefile")
writeOGR(results4,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2004", driver="ESRI Shapefile")

writeOGR(results5,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2005", driver="ESRI Shapefile")
writeOGR(results6,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2006", driver="ESRI Shapefile")

writeOGR(results7,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2007", driver="ESRI Shapefile")
writeOGR(results8,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2008", driver="ESRI Shapefile")

writeOGR(results9,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2009", driver="ESRI Shapefile")
writeOGR(results10,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2010", driver="ESRI Shapefile")

writeOGR(results11,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2011", driver="ESRI Shapefile")
writeOGR(results12,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2012", driver="ESRI Shapefile")

writeOGR(results13,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2013", driver="ESRI Shapefile")
writeOGR(results14,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2014", driver="ESRI Shapefile")

writeOGR(results15,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2015", driver="ESRI Shapefile")
writeOGR(results16,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2016", driver="ESRI Shapefile")
writeOGR(results17,dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Yearly estimates", layer="FOREST_2017", driver="ESRI Shapefile")