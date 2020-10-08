# Helper functions to check entries and validity of SingleCellExperiment
#' @importFrom methods is
.sceCheck <- function(x){
  if(!is(x, "SingleCellExperiment")){
    stop("x is not a SingleCellExperiment object.")
  }
}

.assayCheck <- function(x, exprs_values){
  .sceCheck(x)
  if(!(exprs_values %in% names(assays(x)))){
    stop(paste("The", exprs_values, "slot does not exists in the SingleCellExperiment object."))
  }
}

# checks for plotCellCounts()
.plotCellCountsCheck <- function(sce, sce_sub, proportion, normalize, cellID, imageID, colour_by, split_by){
  #Check if sce is SingleCellExpriment
  .sceCheck(sce)

  #Check if sce_sub is SingleCellExperiment
  if (!is.null(sce_sub)) {
    .sceCheck(sce_sub)
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

