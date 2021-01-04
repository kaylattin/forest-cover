library(gfcanalysis)
library(rgdal)
setwd("/Users/kayla/Documents/thesis_data/arcmap")
d <- readOGR("buffer_dataset.shp")

tiles <- calc_gfc_tiles(d)

# canada & us ---------------------
#download_tiles(
#  tiles,
#  output_folder = "/Users/kayla/Documents/thesis_data/cover",
#  images = c("treecover2000", "lossyear", "gain", "datamask"),
#  dataset = "GFC-2019-v1.7"
  
#)

memory.limit(56000)

# extract info ------------------

forest <- extract_gfc(
  d,
  data_folder = "/Users/kayla/Documents/thesis_data/cover",
  to_UTM = FALSE,
  stack = "change",
  dataset = "GFC-2019-v1.7"
)

# write raster files --------
cover <- forest[[1]]
loss <- forest[[2]]
gain <- forest[[3]]


writeRaster(cover, "cover2000.tif", format = "GTiff")
writeRaster(loss, "lossyear.tif", format = "GTiff")
writeRaster(gain, "forestgain.tif", format = "GTiff")


save(forest, file ="gfc_forest_extract.RData")

