### MERGING GFC RASTER FOR NET LOSS IN 2018 -----
library("rgdal")
library("gdalUtils")
library("raster")

# Set working directory
setwd()

# List of rasters to merge stored as variable 'a'
a <- c('Hansen_GFC-2018-v1.6_lossyear_50N_060W.tif','Hansen_GFC-2018-v1.6_lossyear_50N_070W.tif','Hansen_GFC-2018-v1.6_lossyear_50N_080W.tif','Hansen_GFC-2018-v1.6_lossyear_50N_090W.tif','Hansen_GFC-2018-v1.6_lossyear_50N_100W.tif','Hansen_GFC-2018-v1.6_lossyear_50N_110W.tif','Hansen_GFC-2018-v1.6_lossyear_50N_120W.tif','Hansen_GFC-2018-v1.6_lossyear_50N_130W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_060W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_070W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_080W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_090W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_100W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_110W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_120W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_130W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_140W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_150W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_160W.tif','Hansen_GFC-2018-v1.6_lossyear_60N_170W.tif','Hansen_GFC-2018-v1.6_lossyear_70N_100W.tif','Hansen_GFC-2018-v1.6_lossyear_70N_110W.tif','Hansen_GFC-2018-v1.6_lossyear_70N_120W.tif','Hansen_GFC-2018-v1.6_lossyear_70N_130W.tif','Hansen_GFC-2018-v1.6_lossyear_70N_140W.tif','Hansen_GFC-2018-v1.6_lossyear_70N_150W.tif','Hansen_GFC-2018-v1.6_lossyear_70N_160W.tif','Hansen_GFC-2018-v1.6_lossyear_70N_170W.tif')

# Set extent of template file, x-min, x-max, y-min, y-max
e <- extent(-170,-50,40,70)
template_loss <- raster(e)

# Set geographic datum to WGS 1984
proj4string(template_loss) <- CRS('+init=epsg:4326')

# Name template file and mosaic rasters
writeRaster(template_loss, file="netloss2018.tif",format="GTiff")
mosaic_rasters(gdalfile=a,dst_dataset="netloss2018.tif",of="GTiff")

# Summary info on output raster
gdalinfo("netloss2018.tif")


## EXTRACTING YEARLY LOSS -----
# To make maps of forest loss within each year, reclassify
library(raster)

setwd(file.path('C:','Users','kayla','Documents','can us','lossyear','originals'))

rnet <- raster("netloss2018.tif")

# Set reclassification table for 2001
isBecomes <- cbind(c(0:18), c(0,100,rep(0,17)))
isBecomes

r2001 <- reclassify(rnet, rcl=isBecomes,filename="loss_2001.tif")

# Repeat above for 2002
isBecomes <- cbind(c(0:18), c(rep(0,2),100,rep(0,16)))
isBecomes
r2002 <- reclassify(rnet, rcl=isBecomes,filename="loss_2002.tif")

# Repeat for 2003
isBecomes <- cbind(c(0:18), c(rep(0,3),100,rep(0,15)))
isBecomes
r2003 <- reclassify(rnet, rcl=isBecomes,filename="loss_2003.tif")

# Repeat for 2004
isBecomes <- cbind(c(0:18), c(rep(0,4),100,rep(0,14)))
isBecomes
r2004 <- reclassify(rnet, rcl=isBecomes,filename="loss_2004.tif")

# Repeat for 2005
isBecomes <- cbind(c(0:18), c(rep(0,5),100,rep(0,13)))
isBecomes
r2005 <- reclassify(rnet, rcl=isBecomes,filename="loss_2005.tif")

# Repeat for 2006
isBecomes <- cbind(c(0:18), c(rep(0,6),100,rep(0,12)))
isBecomes
r2006 <- reclassify(rnet, rcl=isBecomes,filename="loss_2006.tif")

# Repeat for 2007
isBecomes <- cbind(c(0:18), c(rep(0,7),100,rep(0,11)))
isBecomes
r2007 <- reclassify(rnet, rcl=isBecomes,filename="loss_2007.tif")

# Repeat for 2008
isBecomes <- cbind(c(0:18), c(rep(0,8),100,rep(0,10)))
isBecomes
r2008 <- reclassify(rnet, rcl=isBecomes,filename="loss_2008.tif")

# Repeat for 2009
isBecomes <- cbind(c(0:18), c(rep(0,9),100,rep(0,9)))
isBecomes
r2009 <- reclassify(rnet, rcl=isBecomes,filename="loss_2009.tif")

# Repeat for 2010
isBecomes <- cbind(c(0:18), c(rep(0,10),100,rep(0,8)))
isBecomes
r2010 <- reclassify(rnet, rcl=isBecomes,filename="loss_2010.tif")

# Repeat for 2011
isBecomes <- cbind(c(0:18), c(rep(0,11),100,rep(0,7)))
isBecomes
r2011 <- reclassify(rnet, rcl=isBecomes,filename="loss_2011.tif")

# Repeat for 2012
isBecomes <- cbind(c(0:18), c(rep(0,12),100,rep(0,6)))
isBecomes
r2012 <- reclassify(rnet, rcl=isBecomes,filename="loss_2012.tif")

# Repeat for 2013
isBecomes <- cbind(c(0:18), c(rep(0,13),100,rep(0,5)))
isBecomes
r2013 <- reclassify(rnet, rcl=isBecomes,filename="loss_2013.tif")

# Repeat for 2014
isBecomes <- cbind(c(0:18), c(rep(0,14),100,rep(0,4)))
isBecomes
r2014 <- reclassify(rnet, rcl=isBecomes,filename="loss_2014.tif")

# Repeat for 2015
isBecomes <- cbind(c(0:18), c(rep(0,15),100,rep(0,3)))
isBecomes
r2015 <- reclassify(rnet, rcl=isBecomes,filename="loss_2015.tif")

# Repeat for 2016
isBecomes <- cbind(c(0:18), c(rep(0,16),100,rep(0,2)))
isBecomes
r2016 <- reclassify(rnet, rcl=isBecomes,filename="loss_2016.tif")

# Repeat for 2017
isBecomes <- cbind(c(0:18), c(rep(0,17),100,rep(0,1)))
isBecomes
r2017 <- reclassify(rnet, rcl=isBecomes,filename="loss_2017.tif")

# Repeat for 2018
isBecomes <- cbind(c(0:18), c(rep(0,18),100))
isBecomes
r2018 <- reclassify(rnet, rcl=isBecomes,filename="loss_2018.tif")