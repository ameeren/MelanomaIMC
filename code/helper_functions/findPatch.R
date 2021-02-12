#' Define a patch of cells by cellIDs
#' @param input_sce SingleCellExperiment object
#' @param IDs_of_interst vector containing the cellsID's of the cells of interest
#' @param cellID column name for object/cell IDs
#' @param X_coord column name for X coordinate
#' @param Y_coord column name for Y coordinate
#' @param ImageNumber column name for Image IDs
#' @param distance (numeric) maximal distance for a cell considered to be a neighbour
#' @param min_patch_size (numeric) min. number of cells for a community of cells to be considered as patch
#' @param output_colname (optional) column name for the community ID column, defalut = "cell_patch"
#' @return new colData entry called "cell_patch" with unique ID for each patch
#'
#' @examples
#' # TODO
#'
#' @author Tobias Hoch \email{tobias.hoch@@bluewin.ch}
#'
#' @importFrom SingleCellExperiment colData
#'
#' @export

findPatch <- function(input_sce,
                         IDs_of_interest,
                         cellID,
                         X_coord, Y_coord,
                         ImageNumber,
                         distance,
                         min_clust_size,
                         output_colname = "cell_patch"){
  # start time
  start = Sys.time()

  # check if required colData is present
  .checkInputPatch(input_sce, IDs_of_interest, cellID, X_coord, Y_coord, ImageNumber, distance, min_clust_size, output_colname)

  # subset sce object
  input_sce_sub <- input_sce[,input_sce$cellID %in% IDs_of_interest]

  # create cur_df with
  input_df <- data.frame(cellID = input_sce_sub[[cellID]],
                       X = input_sce_sub[[X_coord]],
                       Y = input_sce_sub[[Y_coord]],
                       ImageNumber = input_sce_sub[[ImageNumber]])

  # add patch column
  input_df$patch = NA

  patches = 1
  for(i in 1:nrow(input_df)){
    # check if there is another cell in the surrounding
    cur_neighbours = input_df[which(sqrt((input_df[i,]$X - input_df$X)^2 + (input_df[i,]$Y - input_df$Y)^2) <= distance &
                                input_df$ImageNumber == input_df[i,]$ImageNumber),]

    # no other cells surrounding the current cell - assign patch 0
    if(nrow(cur_neighbours) == 1){
      input_df[i,]$patch = patches
      patches = patches + 1
    }

    # multiple neighbours in a new patch
    if(nrow(cur_neighbours) > 1 & all(is.na(cur_neighbours$patch))){
      input_df[input_df$cellID %in% cur_neighbours$cellID,]$patch = patches
      patches = patches + 1
    }

    # multiple neighbours in an existing patch
    if(nrow(cur_neighbours) > 1 & length(unique(sort(cur_neighbours$patch))) == 1){
      input_df[input_df$cellID %in% cur_neighbours$cellID,]$patch = unique(sort(cur_neighbours$patch))
    }

    # multiple neighbours in different patches
    if(nrow(cur_neighbours) > 1 & length(unique(sort(cur_neighbours$patch))) > 1){
      existing_patches = unique(sort(cur_neighbours$patch))
      lowest_patch_id = unique(sort(cur_neighbours$patch))[1]
      input_df[input_df$cellID %in% cur_neighbours$cellID,]$patch = lowest_patch_id

      # overwrite patch id of other cells which are not in cur_neighbours list but still part of this patch
      input_df[input_df$patch %in% existing_patches,]$patch = lowest_patch_id
    }
  }

  # remove patches with less than "min_clust_size number of cells
  for(i in unique(input_df$patch)){
    if(nrow(input_df[input_df$patch == i,]) < min_clust_size){
      input_df[input_df$patch == i,]$patch = 0
    }
  }

  # merge with complete data set
  IDs = as.data.frame(input_sce[[cellID]])
  colnames(IDs) = "cellID"
  IDs = left_join(IDs, input_df, by = "cellID")
  IDs[is.na(IDs$patch),]$patch = 0

  # print computing time
  end = Sys.time()
  print(end-start)

  # check if cellIDs have same sorting in both data sets - if yes, return sce with new colData
  if(all(IDs$cellID == input_sce[[cellID]]) == TRUE){
    if("cell_patch" %in% colnames(colData(input_sce))){
      colData(input_sce)$cell_patch <- NULL
    }
    colData(input_sce)$cell_patch <- IDs$patch
    # overwrite column name for patch ID
    names(colData(input_sce))[length(names(colData(input_sce)))] <- output_colname
    print("patches successfully added to sce object")
    return(input_sce)
  }
  # check if cellIDs have same sorting in both data sets - if not, return input_df instead of sce
  if(!(all(IDs$cellID == input_sce[[cellID]]) == TRUE)){
    print("Output SCE does not contain same cells as input SCE. For safety reasons, data.frame instead of SCE is returned")
    return(input_df)
  }
}
