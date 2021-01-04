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
