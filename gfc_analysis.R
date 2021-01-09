library(gfcanalysis)
library(rgdal)

# load in ---------
setwd("/Users/kayla/Documents/thesis_data/arcmap")
d <- readOGR("buffer_dataset_1km.shp") # dataset where bbs coords <= 1 km from line
d2 <- readOGR("buffered_dataset.shp") # dataset where bbs coords <= 3 km from line

# determine which tiles in the GFC are needed to cover AOI -----------
tiles <- calc_gfc_tiles(d)
plot(tiles)
# plot(d, lt=2, add=TRUE)

memory.limit(56000)

# extract stack for us & canada ------------
forest <- extract_gfc(
  d,
  data_folder = "/Users/kayla/Documents/thesis_data/cover",
  to_UTM = FALSE,
  stack = "change",
  dataset = "GFC-2019-v1.7",
)

writeRaster(forest, "gfc_analysis.tif", format= "GTiff", options = c("INTERLEAVE=BAND", "COMPRESS=LZW"))

cover <- forest[[1]]
loss <- forest[[2]]
gain <- forest[[3]]


writeRaster(cover, "cover2000.tif", format = "GTiff")
writeRaster(loss, "lossyear.tif", format = "GTiff")
writeRaster(gain, "forestgain.tif", format = "GTiff")



## ANNUAL TREE COVER FROM 2000 TO 2019 ## ------
setwd("C:/Users/kayla/Documents/thesis_data/arcmap")
d <- readOGR("buffer_dataset_1km.shp")

setwd("D:/forest_layers")
cover <- raster("cover2000.tif")
loss <- raster("lossyear.tif")
gain <- raster("forestgain.tif")

# reclassify cover layer to binary (0 = no forest, 1 = forest) --------
reclassify(cover,
           c(1, 100, 1),
           filename = "cover2000_binary.tif",
           options="COMPRESS=LZW")

cover_bin <- raster("cover2000_binary.tif")

plot(cover_bin)
plot(cover)


# reclassify 2001 -------
isBecomes <- cbind(c(0:19), c(0, rep(NA, 1), seq(from = (1+1), to = 19)))
isBecomes

system.time(reclassify(loss,
                       rcl = isBecomes,
                       filename = "loss.tif",
                       options = "COMPRESS=LZW"))

lossyear <- raster("loss.tif")

# masking 2001 -----
mask(cover_bin, lossyear,
     filename = "treecover2001.tif",
     options = "COMPRESS=LZW")

treecover2001 <- raster("treecover2001.tif")


# set some stuff up -------
forestcover <- vector("list")
forestcover[1] <- treecover2001

list <- c(paste("treecover200", seq(from = 1, to = 9), sep = ""),
          paste("treecover20", seq(from = 10, to = 19), sep = ""))


# the first batch of years -------
for(i in 2:11) {
  print(paste0("Progress: ", round(i/11*100, 2), "% finished."))
  
  isBecomes <- cbind(c(0:19), c(0, rep(NA, i), seq(from = (i+1), to = 19)))
  
  # extract loss pixels from that year
  reclassify(loss,
             rcl = isBecomes,
             filename = "loss.tif",
             overwrite = TRUE,
             options = "COMPRESS=LZW")
  
  lossyear <- raster("loss.tif")
  
  mask(forestcover[[i-1]], lossyear,
       filename = paste(list[i], ".tif", sep = ""),
       options = "COMPRESS=LZW")
  
  forestcover[[i]] <- raster(paste(list[i], ".tif", sep = ""))
}


# add in gain for 2012, which will carry over into subsequent years
overlay(forestcover[[11]], gain, fun=function(r1,r2){return(r1+r2)},
        filename = "treecover2012_gain.tif"),
options = c("COMPRESS=LZW")

forestcover[[12]] <- raster("treecover2012_gain.tif")

isisBecomes <- cbind(c(0:19), c(0, rep(NA, 12), seq(from = (12+1), to = 19)))

# factor in 2012 loss to generate final file
reclassify(loss,
           rcl = isBecomes,
           filename = "loss.tif",
           overwrite = TRUE,
           options = "COMPRESS=LZW")

lossyear <- raster("loss.tif")

mask(forestcover[[12]], lossyear,
     filename = "treecover2012.tif",
     options = "COMPRESS=LZW")

forestcover[[12]] <- raster("treecover2012.tif")


# finish adding in loss for subsequent years --------
for(i in 13:19) {
  print(paste0("Progress: ", round(i/11*100, 2), "% finished."))
  
  isBecomes <- cbind(c(0:19), c(0, rep(NA, i), seq(from = (i+1), to = 19)))
  
  # extract loss pixels from that year
  reclassify(loss,
             rcl = isBecomes,
             filename = "loss.tif",
             overwrite = TRUE,
             options = "COMPRESS=LZW")
  
  lossyear <- raster("loss.tif")
  
  mask(forestcover[[i-1]], lossyear,
       filename = paste(list[i], ".tif", sep = ""),
       options = "COMPRESS=LZW")
  
  forestcover[[i]] <- raster(paste(list[i], ".tif", sep = ""))
}



### EXTRACTING ANNUAL VALUES FROM SITES ###
# reproject d
d_proj<- spTransform(d, CRS("+proj=longlat +datum=WGS84 +no_defs"))
writeOGR(d_proj, "buffer_dataset_1km_proj.shp")

# extract -----
ovR0 = extract(cover_bin, d_proj)
str(ovR0)

# table -----
tab <- lapply(ovR0, table)

# calculate percentages ----
for(i in 1:length(tab)){
  s <- sum(tab[[i]])
  mat <- as.matrix(tab[[i]])
  landcover[i, paste("X", row.names(mat), sep="")] <- as.numeric(tab[[i]]/s)
}
