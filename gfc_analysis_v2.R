library(gfcanalysis)
library(rgdal)
library(openxlsx)
library(tidyverse)

# load in ---------
setwd("/Users/kayla/Documents/thesis_data/arcmap")
d <- readOGR("buffer_dataset_1km.shp") # dataset where bbs coords <= 1 km from line
# d2 <- readOGR("buffered_dataset.shp") # dataset where bbs coords <= 3 km from line

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
d_proj<- spTransform(d, CRS("+proj=longlat +datum=WGS84 +no_defs"))
d_proj <- d_proj[!duplicated(d_proj$rteno),]

writeOGR(d_proj, dsn = "C:/Users/kayla/Documents/thesis_data/arcmap", layer = "buffer_dataset_1km_proj", driver = "ESRI Shapefile")

setwd("D:/50_forestlayers")
cover <- raster("cover2000.tif")
loss <- raster("lossyear.tif")
gain <- raster("forestgain.tif")

# reclassify cover layer to binary --------
# 0 = no forest, 1 = forest, pixels with at least 50% canopy closure / tree cover
isBecomes <- cbind(0:100, c(rep(0, 50), rep(1, 51)))
isBecomes

cover_50 <- reclassify(cover,
                       rcl = isBecomes,
                       filename = "cover2000_above50.tif",
                       options="COMPRESS=LZW")

# mask loss layer ---------
# so that it only counts loss of forest with >= 50% canopy closure / tree cover
loss_mask <- mask(loss, cover_50,
                  maskvalue = 0,
                  updatevalue = 0,
                  filename = "masked_loss.tif",
                  options = "COMPRESS=LZW")

# extract pixel counts of cover2000 -----
exCover <- raster::extract(cover_50, d_proj, method = "simple")
save(exCover, file = "extract_cover2000.RData")

# extract pixel counts of loss_mask -----
exLoss <- raster::extract(loss_mask, d_proj, method = "simple")
save(exLoss, file = "extract_loss.RData")

# extract pixel counts of gain -----
exGain <- raster::extract(gain, d_proj, method = "simple")
save(exGain, file = "extract_gain2012.RData")

# create a list of frequency tables for each route  ------
load("extract_cover2000.RData")
load("extract_loss.RData")
load("extract_gain2012.RData")
  
coverTab <- lapply(exCover, table)
lossTab <- lapply(exLoss, table)
gainTab <- lapply(exGain, table)

# create empty lists -----
forest <- vector("list") # list of forest cover for a single route
newForest <- vector("list")
elseForest <- vector("list")
pForest <- vector("list")
forestMat <- vector("list") # list of forest cover for each route; list of "forest"
pixelList <- vector("list")
percentList <- vector("list")



# create a new loss dataframe for each route
newLoss <- vector("list")
routes <- d_proj@data$rteno

for(i in 1:3558) {
  u <- data.frame(lossTab[[i]])
  
  if (length(u$Freq) >= 1) {
    u$rte = routes[i]
  }
  
  else {
    u <- routes[i]
  }
  
  newLoss[[i]] <- u
}

# bind dataframes into one dataframe
newLoss <- do.call("rbind", newLoss)

# wide format so that now every route has information on # pixels lost for every year - even if 0 
# i.e., years aren't skipped in the matrix, data entered for 2000 to 2019 inclusive so all tables are n = 19
newLoss_wide <- reshape(newLoss, direction = "wide", idvar = "rte", timevar = "Var1")
newLoss_wide[is.na(newLoss_wide)]<-0 


for(i in 1:3558) {
  
  coverMat <- matrix(coverTab[[i]])
  lossMat <- newLoss_wide[i,]
  gainMat <- matrix(gainTab[[i]])
  
  if (length(coverMat) == 2) {
    
  # num total pixels in the site
  tot <- sum(coverMat)
    
  # initiate forest list for the site in 2001
  f2000 <- coverMat[2, 1]
  p2000 <- f2000 / tot
  
  # set up 2001 in forest list
  newForest[[1]] <- f2000 - lossMat[,1+2]
  pForest[[1]] <- newForest[[1]] / tot
  
  # calculate cover - loss for 2002 to 2011
      for(k in 2:11) {
       newForest[[k]] <- newForest[[k-1]] - lossMat[,k+2]
       pForest[[k]] <- newForest[[k]] / tot
      }
  
          if (length(gainMat) == 2) {
          # add gain to 2012, then subtract loss
          newForest[[12]] <- newForest[[11]] + gainMat[2,1]
          pForest[[12]] <- (newForest[[12]] - lossMat[, 14]) / tot
          } else {
          newForest[[12]] <- newForest[[11]] - lossMat[, 14]
          pForest[[12]] <- newForest[[12]] / tot 
        }
  
  # continue with years 2013 to 2019
     for(n in 13:19) {
       newForest[[n]] <- newForest[[n-1]] - lossMat[, n+2]
       pForest[[n]] <- newForest[[n]] / tot
      }
  
  pixelList[[i]] <- newForest
  percentList[[i]] <- pForest
  
  
  t <- unlist(pForest)
  percent <- append(p2000, t)
  year <- seq(from = 2000, to = 2019)
  rte <- newLoss_wide$rte[i]
  forestMat[[i]] <- data.frame(rte, year, percent)

  }
     # if no cover in 2000, and no gain in 2012, then assign 0
      else {
        rte <- newLoss_wide$rte[i]
        year <- seq(from = 2000, to = 2019)
        percent <- 0
        forestMat[[i]] <- data.frame(rte, year, percent)
      }
 
    
  }
  
# compile final master sheet
final <- do.call("rbind", forestMat) ## will this work?!?!?!
finalWide <- reshape(final, direction = "wide", idvar = "rte", timevar = "year")

write.csv(finalWide, "finalWide.csv")

# how much change from 2000 to 2019?
finalWide$change <- finalWide$percent.2019 - finalWide$percent.2000
gain20<- finalWide %>% dplyr::filter(change >= 0.20)
lose20 <- finalWide %>% dplyr::filter(change <= -0.20)
candidates1 <- rbind(gain20, lose20)



# -------------------------------------------------------------
## filter out removed sites that were < 5 km away from others
setwd("C:/Users/kayla/Documents/thesis_data/arcmap")
d_clean <- readOGR("buffer_dataset_1km_proj_V3.shp")

newRoutes <- d_clean@data$rteno

finalClean <- finalWide %>% filter(rte %in% newRoutes)

write.csv(finalClean, "finalClean.csv")


# how much change from 2000 to 2019?
finalClean$change <- finalClean$percent.2019 - finalClean$percent.2000
gain20<- finalClean %>% dplyr::filter(change >= 0.20)
lose20 <- finalClean %>% dplyr::filter(change <= -0.20)
candidates2 <- rbind(gain20, lose20)

write.csv(candidates, "candidates_temporal.csv")




#### check back ------------------------------------------------------------------------------
# if no cover in 2000, then

  # check to see if there was gain in 2012, and if so, add it and subtract loss
  if (length(gainMat) == 2) {
    
    # 0 forest from 2001 to 2011
    for(i in 1:11){
      elseForest[[i]] <- 0
      
    }
    
    for(i in 1:11){
      pForest[[i]] <- 0
      
    }
    
    # add gain to 2012
    elseForest[[12]] <- gainMat[2,1]
    elseForest[[12]] <- elseForest[[12]] - lossMat[, 14]
    pForest[[12]] <- elseForest[[12]] / tot
    
    
    # subtract any loss from 2012 to 2019, if gain occurred in 2012
    for(i in 1:7) {
      elseForest[[i+12]] <- elseForest[[i+11]] - lossMat[, i+14]
      pForest[[i+12]] <- elseForest[[i+12]] / tot
    }
    
    t <- unlist(pForest)
    percent <- append(0, t)
    year <- seq(from = 2000, to = 2019)
    rte <- newLoss_wide$rte[i]
    forestMat[[i]] <- data.frame(rte, year, percent)
    

