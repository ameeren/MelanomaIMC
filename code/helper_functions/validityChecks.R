# Input Check for Patch Detection

.checkInputPatch <- function(input_sce,
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
    stop("A column with the indicated output_colname already exists. Please indicate a unique column name.")
  }
}

# Input Check for Milieu Detection

.checkInputMilieu <- function(input_sce,
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


# Input Check for distance calculation

.checkInputDistance <- function(input_sce,
                                 cellID,
                                 X_coord, Y_coord,
                                 ImageNumber,
                                 cluster,
                                 output_colname){
  if(!(class(input_sce) == "SingleCellExperiment")){
    stop("input object is not of type SingleCellExperiment")
  }
  if(!(all(c(cellID, X_coord, Y_coord, ImageNumber, cluster) %in% names(colData(input_sce))))){
    stop("The indicated columnnames are not part of the input SCE object. Please make sure the columnnames are indicated correctly and that colData(input_sce) contains all necessary columns.")
  }
  if(output_colname %in% colnames(colData(input_sce))){
    stop("A column with the indicated output_colname already exists. Please indicate a unique column name. ")
  }
}

# Input Check for mRNA Detection

.checkInputmRNADetection <- function(input_sce,
                                cellID,
                                assay_name,
                                threshold = 0.05,
                                mRNA_channels,
                                negative_control){
  if(!(class(input_sce) == "SingleCellExperiment")){
    stop("input object is not of type SingleCellExperiment")
  }
  if(!(assay_name %in% names(assays(input_sce)))){
    stop("Provided assay name is not available.")
  }
  if(!(all(c(cellID) %in% names(colData(input_sce))))){
    stop("The indicated colData entry for the cell identifier is not part of the input SCE object. Please make sure that the colData entry is indicated correctly and that colData(input_sce) contains all necessary columns.")
  }
  if(!(all(c(mRNA_channels, negative_control) %in% rownames(input_sce)))){
    stop("The indicated mRNA channels do not match rownames of the SCE object. Please provide valid mRNA channel names.")
  }
  if(!is.numeric(threshold)){
    stop("Please provide an numeric threshold.")
  }
}

# checks for plotCellCounts()
.plotCellCountsCheck <- function(sce,
                                 sce_sub,
                                 proportion,
                                 normalize,
                                 cellID,
                                 imageID,
                                 colour_by,
                                 split_by,
                                 show_n){
  #Check if sce is SingleCellExpriment
  .sceCheck(sce)

  #Check if sce_sub is SingleCellExperiment
  if (!is.null(sce_sub)) {
    .sceCheck(sce_sub)
  }

  # is show_n logical?
  if(is.logical(show_n) != TRUE){
    stop("show_n must be logical, TRUE or FALSE")
  }

  # check
  if (normalize == FALSE & !is.null(sce_sub)) {
    stop(
      "If no normalization should be performed on sce_sub, sce_sub must be used as direct input (sce) for this function."
    )
  }

  #check if sce_sub is really a subset of sce if normalize==TRUE
  if (normalize == TRUE & !is.null(sce_sub)) {
    if (is.null(cellID)) {
      stop("cellID parameter must be provided in order to check validity of subsetted SCE")
    }
    if (all(colData(sce_sub)[, cellID] %in% colData(sce)[, cellID]) != TRUE) {
      stop("sce_sub is not part of sce. Please provide a subset of sce as input.")
    }
  }

  # Check if selected variable exists
  entries <- colnames(colData(sce))
  if (!is.null(colour_by)) {
    if (!(colour_by %in% entries)) {
      stop("The entry for colour_by is not a colData slot of the object.")
    }
  }

  if (!is.null(split_by)) {
    if (!(split_by %in% entries)) {
      stop("The entry for split_by is not a colData slot of the object.")
    }
  }

  if (is.null(imageID)) {
    stop("provide an imageID. imageID must be a colData entry of the sce object.")
  } else if (!(imageID %in% entries)) {
    stop("The entry for imageID is not a colData slot of the object.")
  }

}

.plotCellFractionsCheck <- function(sce,
                                    imageID,
                                    celltype_column,
                                    celltype_subsets,
                                    merge_subsets,
                                    split_by,
                                    show_n,
                                    facet_wrap){

  #Check if sce is SingleCellExpriment
  .sceCheck(sce)

  # Check if selected variable exists
  entries <- colnames(colData(sce))

  if (!(split_by %in% entries)) {
      stop("The entry for split_by is not a colData entry of the SCE object.")
  }
  if (!(imageID %in% entries)) {
    stop("The entry for imageID is not a colData entry of the SCE object.")
  }
  if (!(celltype_column %in% entries)) {
    stop("The entry for celltype_column is not a colData entry of the SCE object.")
  }

  # is show_n logical?
  if(is.logical(show_n) != TRUE){
    stop("show_n must be logical, TRUE or FALSE")
  }

  # is facet_wrap logical?
  if(is.logical(facet_wrap) != TRUE){
    stop("facet_wrap must be logical, TRUE or FALSE")
  }

  # is merge_subsets logical?
  if(is.logical(merge_subsets) != TRUE){
    stop("merge_subsets must be logical, TRUE or FALSE")
  }

  # merge only when subsets are provided
  if(merge_subsets == TRUE & is.null(celltype_subsets)){
    warning("Subsets can only be merged if celltype_subsets is provided. Either provide subset or set merge_subsets to FALSE")
  }

  # check subset column
  if(!is.null(celltype_subsets)){
    if(is.vector(celltype_subsets) != TRUE){
      stop("Please provide an (character) vector as celltype_subset input.")
    }
    if(all(celltype_subsets %in% unique(data.frame(colData(sce))[,celltype_column])) != TRUE){
      stop("The provided celltype_subset is not a subset of celltype_column. Please check.")
    }
  }
}
