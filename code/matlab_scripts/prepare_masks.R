library(cytomapper)

# Read in melanoma masks
all_masks <- loadImages("/Volumes/bbvolume/server_homes/thoch/Git/MelanomaIMC/data/full_data/rna/cpout/",
                        pattern = "cellmask.tiff", as.is = TRUE)

max_id <- list()

for (i in 1:length(all_masks)){
    cur_mask <- all_masks[[i]]
    
    max_id[[names(all_masks)[i]]] <- max(cur_mask)
    
    cur_mask[cur_mask == 0] <- max(cur_mask) + 1
    cur_mask[cur_mask != max(cur_mask)] <- 0 
    cur_mask[cur_mask == max(cur_mask)] <- 1
    
    cur_seg <- watershed(distmap(cur_mask))
    
    cur_seg[cur_seg != 0] <- cur_seg[cur_seg != 0] + max(all_masks[[i]])
    cur_seg[cur_seg == 0] <- all_masks[[i]][cur_seg == 0]
    
    # Add the outlines
    cur_seg <- paintObjects(cur_seg, cur_seg, col = c("black", NA))
    
    writeImage(normalize(cur_seg, inputRange = c(0, 2 ^ 16 - 1)), 
               files = paste0("Desktop/REDSEA_masks/", names(all_masks)[i], ".tiff"),
               bits.per.sample = 16)
}

cur_max <- do.call("rbind", max_id)

write.csv(cur_max, "Desktop/REDSEA_masks/max_ids.csv")
