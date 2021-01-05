library(gfcanalysis)
library(rgdal)

# load in ---------
setwd("/Users/kayla/Documents/thesis_data/arcmap")
d <- readOGR("buffer_dataset_1km.shp") # dataset where bbs coords <= 1 km from , buffer 1km
# d2 <- readOGR("buffered_dataset.shp") # dataset where bbs coords <= 3 km from line, buffer 1km
# d3 <- readOGR("buffer_dataset_3km.shp") # data where bbs coords <= 3 km from line, buffer 3 km

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



## ANNUAL TREE COVER FROM 2000 TO 2019 ##

# initial 2001 -------
mask <- reclassify(loss, 
                   rbind(c(1,NA)))

treecover2001 <- mask(cover, mask)
writeRaster(treecover2001, "treecover2001.tif")

# check plots -------
plot(cover)
plot(treecover2001)

forestcover <- vector("list")
forestcover[1] <- treecover2001

list <- c(paste("treecover200", seq(from = 2, to = 9), sep = ""),
          paste("treecover20", seq(from = 10, to = 19), sep = ""))

# the rest of the years -------
for(i in 2:19) {
  print(paste0("Progress: ", round(i/19*100, 2), "% finished."))
  mask <- reclassify(loss, 
                     rbind(c(i,NA)))
  
  forestcover[[i]] <- mask(forestcover[[i-1]], mask)
  writeRaster(cover[[i]], paste(list[i], ".tif", sep = ""))
}


# extract mean % forest ---------
results <- vector("list")
listb <- c(paste("FOREST_200", seq(from = 1, to = 9), sep = ""),
            paste("FOREST_20", seq(from = 10, to = 19), sep = ""))

for(i in 1:19) {
  print(paste0("Progress: ", round(i/19*100, 2), "% finished."))
  results[[i]] <- extract(forestcover[[i]], d, fun = mean, df = TRUE, normalizeWeights = TRUE)
  writeOGR(results[[i]], dsn = "/Users/kayla/Documents/thesis_data/arcmap", layer = listb[i], driver = "ESRI Shapefile")
  }


# repeat for 3km buffered area -------
results3km <- vector("list")
for(i in 1:19) {
  print(paste0("Progress: ", round(i/19*100, 2), "% finished."))
  results[[i]] <- extract(forestcover[[i]], d3, fun = mean, df = TRUE, normalizeWeights = TRUE)
  writeOGR(results[[i]], dsn = "/Users/kayla/Documents/thesis_data/arcmap", layer = listb[i], driver = "ESRI Shapefile")
}


### extract forest gain ------ 
g <- extract(gain, d, method = "simple")
class(g)
length(g)


# try this later to see if we can get proportions
# alternatively, look into tabulate area in arcmap

# this is from http://zevross.com/blog/2015/03/30/map-and-analyze-raster-data-in-r/
tabFunc <- function(indx, extract, rteno, rtename) {
  dat <- as.data.frame(table(extract[[indx]]))
  dat$name <- rteno[[rtename]][[indx]]
  return(dat)
}

tabs <- lapply(seq(g), tabFunc, g, rteno, "rtename")
tabs

tabs <- do.call("rbind", tabs)

tabs$Var1 <- factor(tabs$Var1, levels = c(0,1), labels = c("No gain", "Gain"))

tabs %>%
  group_by(rtename) %>%
  mutate(totcells = sum(Freq),
         percent.area = round(100*Freq/totcells, 2)) %>%
  dplyr::select(-c(Freq, totcells)) %>%
  spread(key = Var1, value = percent.area, fill = 0)
