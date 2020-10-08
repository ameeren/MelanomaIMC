#' Extracts information from string fields
#'
#' @param name a string
#' @param seq the seperator that seperates fields in the string
#' @param strPos numeric or vector: indicates which positions of the string should be extracted
#' @param censorStr string that gets ignored
#' @return The extracted stringfield
#' @export
getInfoFromString<- function(name,sep='_',strPos=2,censorStr='.fcs'){
  tp <- gsub(censorStr,'',strsplit(name,sep)[[1]][strPos])
  tp <- paste(tp,collapse = sep)
  return(tp)
}


#' Parses a list of strings and gets the corresponding information
#'
#' See getInfoFromString for more information
#'
#' @export
getInfoFromFileList <- function(fileList,sep='_',strPos=2,censorStr='.fcs'){
  condDict = sapply(fileList,function(file){getInfoFromString(file,sep,strPos,censorStr)})
  names(condDict) <- fileList
  return(condDict)
}
