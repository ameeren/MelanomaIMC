# function to get the number of a specified celltype for a specific image

getCellCount <- function(data, celltype, ImageNumber){
  (ncol(data[,which(data$ImageNumber == ImageNumber & data$celltype == celltype)]))
}
