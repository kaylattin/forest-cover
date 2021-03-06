## OBTAINING YEARLY FOREST COVER LAYERS ----

# Subtract 2001 from 2000
setwd("D:/US layers")

library(raster)

# Assign my 2 rasters I want to subtract
cover2000 <- raster("2000_us.tif")
loss2001 <- raster("loss_2001_us.tif")

# overlay function allows me to subtract 2 rasters and then save to a file
cover2001_us <- overlay(cover2000,loss2001,fun=function(r1,r2){return(r1-r2)},filename="cover2001_us.tif")

# plot both to see if it worked
plot(cover2000)
plot(cover2001_us)

# Will need to reclassify all negative values to 0
isBecomes <- cbind(c(-100:100),c(rep(0,100),c(0:100)))
isBecomes

cover2001_us <- reclassify(cover2001,rcl=isBecomes,filename="cover2001_us.tif")
plot(cover2001_us)
# Repeat for all years, so that the forest loss accumulates in each forest cover map for each year

loss2002 <- raster("loss_2002_us.tif")
overlay(cover2001,loss2002,fun=function(r1,r2){return(r1-r2)},filename="cover2002_us.tif")
cover2002 <- raster("cover2002_us.tif")
cover2002_us <- reclassify(cover2002,rcl=isBecomes,filename="cover2002_us.tif")

loss2003 <- raster("loss_2003_us.tif")
cover2003 <- overlay(cover2002,loss2003,fun=function(r1,r2){return(r1-r2)},filename="cover2003_us.tif")
cover2003_us <- reclassify(cover2003,rcl=isBecomes,filename="cover2003_us.tif")


loss2004 <- raster("loss_2004.tif")
overlay(cover2003,loss2004,fun=function(r1,r2){return(r1-r2)},filename="cover2004.tif")
cover2004 <- raster("cover2004.tif")
cover2004_us <- reclassify(cover2004,rcl=isBecomes,filename="cover2004_us.tif")


loss2005 <- raster("loss_2005.tif")
overlay(cover2004,loss2005,fun=function(r1,r2){return(r1-r2)},filename="cover2005.tif")
cover2005 <-raster("cover2005_f.tif")
cover2005_us <- cover2005_us <- reclassify(cover2005,rcl=isBecomes,filename="cover2005_us.tif")



loss2006 <- raster("loss_2006.tif")
cover2006 <- overlay(cover2005_f,loss2006,fun=function(r1,r2){return(r1-r2)},filename="cover2006.tif")
cover2006_us <- reclassify(cover2006,rcl=isBecomes,filename="cover2006_f.tif")

loss2007 <- raster("us_loss_2007.tif")
cover2007 <- overlay(cover2006_f,loss2007,fun=function(r1,r2){return(r1-r2)},filename="cover2007.tif")
cover2007_us <- reclassify(cover2007,rcl=isBecomes,filename="cover2007_f.tif")

loss2008 <- raster("us_loss_2008.tif")
cover2008 <- overlay(cover2007_f,loss2008,fun=function(r1,r2){return(r1-r2)},filename="cover2008.tif")
cover2008_us <- reclassify(cover2008,rcl=isBecomes,filename="cover2008_f.tif")

loss2009 <- raster("us_loss_2009.tif")
cover2009 <- overlay(cover2008_f,loss2009,fun=function(r1,r2){return(r1-r2)},filename="cover2009.tif")
cover2009_us <- reclassify(cover2009,rcl=isBecomes,filename="cover2009_f.tif")

loss2010 <- raster("us_loss_2010.tif")
cover2010 <- overlay(cover2009_f,loss2010,fun=function(r1,r2){return(r1-r2)},filename="cover2010.tif")
cover2010_us <- reclassify(cover2010,rcl=isBecomes,filename="cover2010_f.tif")

loss2011 <- raster("us_loss_2011.tif")
cover2011 <- overlay(cover2010_f,loss2011,fun=function(r1,r2){return(r1-r2)},filename="cover2011.tif")
cover2011_us <- reclassify(cover2011,rcl=isBecomes,filename="cover2011_f.tif")

loss2012 <- raster("us_loss_2012.tif")
cover2012 <- overlay(cover2011_f,loss2012,fun=function(r1,r2){return(r1-r2)},filename="cover2012.tif")
cover2012_us <-reclassify(cover2012,rcl=isBecomes,filename="cover2012_f.tif")

loss2013 <- raster("us_loss_2013.tif")
cover2013 <- overlay(cover2012_f,loss2013,fun=function(r1,r2){return(r1-r2)},filename="cover2013.tif")
cover2013_us <-reclassify(cover2013,rcl=isBecomes,filename="cover2013_f.tif")

loss2014 <- raster("us_loss_2014.tif")
cover2014 <- overlay(cover2013_f,loss2014,fun=function(r1,r2){return(r1-r2)},filename="cover2014.tif")
cover2014_us <- reclassify(cover2014,rcl=isBecomes,filename="cover2014_f.tif")

loss2015 <- raster("us_loss_2015.tif")
cover2015 <- overlay(cover2014_f,loss2015,fun=function(r1,r2){return(r1-r2)},filename="cover2015.tif")
cover2015_us <- reclassify(cover2015,rcl=isBecomes,filename="cover2015_f.tif")

loss2016 <- raster("us_loss_2016.tif")
cover2016 <- overlay(cover2015_f,loss2016,fun=function(r1,r2){return(r1-r2)},filename="cover2016.tif")
cover2016_us <- reclassify(cover2016,rcl=isBecomes,filename="cover2016_f.tif")
cover2016_f <-raster("cover2016_f.tif")
loss2017 <- raster("us_loss_2017.tif")
cover2017 <- overlay(cover2016_f,loss2017,fun=function(r1,r2){return(r1-r2)},filename="cover2017.tif")
cover2017_f <- reclassify(cover2017,rcl=isBecomes,filename="cover2017_f.tif")

loss2018 <- raster("us_loss_2018.tif")
cover2018 <- overlay(cover2017_f,loss2018,fun=function(r1,r2){return(r1-r2)},filename="cover2018.tif")
cover2018_f <- reclassify(cover2018,rcl=isBecomes,filename="cover2018_f.tif")