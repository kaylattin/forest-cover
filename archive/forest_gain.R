### MERGING GFC RASTER FOR NET LOSS IN 2018 -----
library("rgdal")
library("gdalUtils")
library("raster")

# Set working directory
setwd("/Users/kayla/Documents/forest_gain")

# List of rasters to merge stored as variable 'a'
a <- c('Hansen_GFC-2019-v1.7_gain_50N_060W.tif',
       'Hansen_GFC-2019-v1.7_gain_50N_070W.tif',
       'Hansen_GFC-2019-v1.7_gain_50N_080W.tif',
       'Hansen_GFC-2019-v1.7_gain_50N_090W.tif',
       'Hansen_GFC-2019-v1.7_gain_50N_100W.tif',
       'Hansen_GFC-2019-v1.7_gain_50N_110W.tif',
       'Hansen_GFC-2019-v1.7_gain_50N_120W.tif',
       'Hansen_GFC-2019-v1.7_gain_50N_130W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_060W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_070W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_080W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_090W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_100W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_110W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_120W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_130W.tif',
       'Hansen_GFC-2019-v1.7_gain_60N_140W.tif')


# Set extent of template file, x-min, x-max, y-min, y-max
e <- extent(-140,-60,50,60)
template_gain <- raster(e)

# Set geographic datum to WGS 1984
proj4string(template_gain) <- CRS('+init=epsg:4326')

# Name template file and mosaic rasters
writeRaster(template_gain, file="gain2012.tif",format="GTiff")
mosaic_rasters(gdalfile=a,dst_dataset="gain2012.tif",of="GTiff")

# Summary info on output raster
gdalinfo("gain2012.tif")
gain <- raster("gain2012.tif")
plot(gain)


setwd("/Users/kayla/Documents/WORKING BBS DATA/BBS data/Working files - Mar27/")
# read in my transects
buffer <-readOGR(dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data/Working files - Mar27", layer="buffer_Mar27")

gainresults <- extract(gain, buffer, fun=mean, df=TRUE)
writeOGR(gainresults, dsn="/Users/kayla/Documents/WORKING BBS DATA/BBS data", layer="forestgain2012", driver="ESRI Shapefile")


