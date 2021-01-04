library(gfcanalysis)
library(rgdal)

# load in ---------
setwd("/Users/kayla/Documents/thesis_data/arcmap")
d <- readOGR("buffer_dataset.shp")
c <- readOGR("canada_buffer_dec29.shp")
u <- readOGR("us_buffer_dec29.shp")

# determine which tiles in the GFC are needed to cover AOI -----------
tiles_c <- calc_gfc_tiles(c)
plot(tiles_c)
# plot(d, lt=2, add=TRUE)

tiles_u <- calc_gfc_tiles(u)
plot(tiles_u)

# canada ----------------
download_tiles(
  tiles_c,
  output_folder = "/Users/kayla/Documents/thesis_data/canada/gfc",
  images = c("treecover2000", "lossyear", "gain", "datamask"),
  dataset = "GFC-2019-v1.7"
)

# us ---------------------
download_tiles(
  tiles_u,
  output_folder = "/Users/kayla/Documents/thesis_data/us/gfc",
  images = c("treecover2000", "lossyear", "gain", "datamask"),
  dataset = "GFC-2019-v1.7"
  
)

memory.limit(56000)

# extract stack for us --------------
us <- extract_gfc(
  u,
  data_folder = "/Users/kayla/Documents/thesis_data/us/gfc",
  to_UTM = FALSE,
  stack = "change",
  dataset = "GFC-2019-v1.7",
)


# extract stack for us & canada ------------
forest <- extract_gfc(
  d,
  data_folder = "/Users/kayla/Documents/thesis_data/cover",
  to_UTM = FALSE,
  stack = "change",
  dataset = "GFC-2019-v1.7",
  filename = "us_canada_cover.tiff", format = "GTiff", options = c("INTERLEAVE=BAND", "COMPRESS=LZW")
)



# get different loss layers ----------
setwd("/Users/kayla/Documents/thesis_data")
load("gfc_forest_extract.RData")

writeRaster(forest, "gfc_analysis.tif", format= "GTiff", options = c("INTERLEAVE=BAND", "COMPRESS=LZW"))

cover <- forest[[1]]
loss <- forest[[2]]
gain <- forest[[3]]


writeRaster(cover, "cover2000.tif", format = "GTiff")
writeRaster(loss, "lossyear.tif", format = "GTiff")
writeRaster(gain, "forestgain.tif", format = "GTiff")


# initial 2001 -------
mask <- reclassify(loss, 
                   rbind(c(1,NA)))

treecover2001 <- mask(cover, mask)
writeRaster(treecover2001, "treecover2001.tif", sep = "")

forestcover <- vector("list")
forestcover[1] <- treecover2001

list <- c(paste("treecover200", seq(from = 2, to = 9), sep = ""),
          paste("treecover20", seq(from = 10, to = 19), sep = ""))

# the rest of the years -------

for(i in 2:20) {
  mask <- reclassify(loss, 
                     rbind(c(i,NA)))
  
  forestcover[[i]] <- mask(cover[[i-1]], mask)
  writeRaster(cover[[i]], paste(list[i], ".tif", sep = ""))
}

