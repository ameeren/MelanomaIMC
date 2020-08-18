# function to get the spotnumber from the metadata. this links to the naming in HistoCatWeb

getSpotnumber <- function(imagenumber){
  image_mat[imagenumber,]$Metadata_Description
}
