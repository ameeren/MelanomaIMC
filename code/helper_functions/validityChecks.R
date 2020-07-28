# Input Check for Cluster Detection

.checkInputCluster <- function(input_sce, 
                               IDs_of_interest, 
                               cellID, 
                               X_coord, Y_coord, 
                               ImageNumber, 
                               distance, 
                               min_clust_size, 
                               output_colname){
  if(!(class(input_sce) == "SingleCellExperiment")){
    stop("input object is not of type SingleCellExperiment")
  }
  if(!(class(IDs_of_interest) == "character")){
    stop("input IDs_of_interest is not of type character. Please indicate a vector containing the cellIDs of the cells of interest.")
  }
  if(!(all(c(cellID, X_coord, Y_coord, ImageNumber) %in% names(colData(input_sce))))){
    stop("The indicated columnnames are not part of the input SCE object. Please make sure the columnnames are indicated correctly and that colData(input_sce) contains all necessary columns.")
  }
  if(!(class(distance) == "numeric")){
    stop("input distance is not of type numeric. Please indicate an input of type numeric.")
  }
  if(!(class(min_clust_size) == "numeric")){
    stop("input min_clust_size is not of type numeric. Please indicate an input of type numeric.")
  }
  if(!(all(c(cellID, X_coord, Y_coord, ImageNumber) %in% colnames(colData(input_sce))) == TRUE)){
    stop("One or multiple of the indicated columns are not part of colData of the input SCE object. Verify colnames.")
  }
  if(output_colname %in% colnames(colData(input_sce))){
    stop("A column with the indicated output_colname already exists. Please indicate a unique column name. ")
  }
}

# Input Check for Community Detection

.checkInputCommunity <- function(input_sce, 
                                 cellID, 
                                 X_coord, Y_coord, 
                                 ImageNumber, 
                                 cluster, 
                                 distance, 
                                 output_colname){
  if(!(class(input_sce) == "SingleCellExperiment")){
    stop("input object is not of type SingleCellExperiment")
  }
  if(!(all(c(cellID, X_coord, Y_coord, ImageNumber, cluster) %in% names(colData(input_sce))))){
    stop("The indicated columnnames are not part of the input SCE object. Please make sure the columnnames are indicated correctly and that colData(input_sce) contains all necessary columns.")
  }
  if(!(class(distance) == "numeric")){
    stop("input distance is not of type numeric. Please indicate an input of type numeric.")
  }
  if(output_colname %in% colnames(colData(input_sce))){
    stop("A column with the indicated output_colname already exists. Please indicate a unique column name. ")
  }
}
