#' Define a milieu surrounding a patch of cells
#' @param input_sce SingleCellExperiment object
#' @param cellID column name for object/cell IDs
#' @param X_coord column name for X coordinate
#' @param Y_coord column name for Y coordinate
#' @param ImageNumber column name for Image IDs
#' @param patch column name for cell patch IDs
#' @param distance (numeric) distance to enlarge (buffer) the patch
#' @param convex (optional) logical, should the patch be enlarged based on its convex or concave hull? default = FALSE (concave)
#' @param plot (optional) logical, plot images showing patch and milieu borders using ggplot, default = FALSE
#' @param xlim (optional) set x scale limit for plotting
#' @param ylim (optional) set y scale limit for plotting
#' @param point_size (optional) set size for geom_points, default = 1
#' @param output_colname (optional) column name for the milieu ID column, default = "milieu"
#' @return SingleCellExperiment object with new colData entry storing the milieu ID.
#'
#' @examples
#' # TODO
#'
#' @author Tobias Hoch \email{tobias.hoch@@bluewin.ch}
#'
#' @import sf
#' @import ggplot2
#' @importFrom grDevices chull
#' @importFrom data.table copy
#' @importFrom data.table as.data.table
#' @importFrom concaveman concaveman
#' @importFrom SingleCellExperiment colData
#' @importFrom RANN nn2
#' @importFrom dplyr inner_join
#' @export

findMilieu <- function(input_sce,
                          cellID,
                          X_coord, Y_coord,
                          ImageNumber,
                          patch,
                          distance,
                          convex = F,
                          output_colname = "milieu",
                          plot = FALSE,
                          xlim = NULL,
                          ylim = NULL,
                          point_size = 1){
  # start time
  start <- Sys.time()

  # check if required colData is present
  .checkInputMilieu(input_sce, cellID, X_coord, Y_coord, ImageNumber, patch, distance, output_colname)

  # create cur_df with
  input_df <- data.frame(cellID = input_sce[[cellID]],
                         X = input_sce[[X_coord]],
                         Y = input_sce[[Y_coord]],
                         ImageNumber = input_sce[[ImageNumber]],
                         patch = input_sce[[patch]])

  # add milieu ID - empty vector
  input_df$milieu <- NA
  input_df$unique_milieu <- NA

  for(j in unique(input_df$ImageNumber)){

    # create multipoint object with all cells from one image
    cell_coord = as.matrix(input_df[input_df$ImageNumber == j,2:3])
    rownames(cell_coord) = input_df[input_df$ImageNumber == j,1]
    cells = st_multipoint(cell_coord)
    cells_sfc = st_cast(st_sfc(cells), "POINT")

    # create data.frame for all border cells of all patches (image-wise)
    border_cells_patches = data.frame(matrix(ncol=ncol(input_df), nrow = 0))
    colnames(border_cells_patches) = colnames(input_df)

    # create data.frame for all milieu cells
    milieu_cells = copy(border_cells_patches)

    # create list for plots/polygon objects
    polygon_plots = ggplot()

    # loop through all patches and identify milieu of each patch
    for(i in unique(input_df[input_df$ImageNumber == j & input_df$patch != 0,]$patch)){
      # remove patch 0
      cur_df <- input_df[input_df$patch == i & input_df$patch != 0,]
      if(nrow(cur_df) == 0) {
        next
      }

      ## case where patch is a single cell - no hull can be computed
      if (nrow(cur_df) == 1){
        polygon = st_point(as.matrix(cur_df[,2:3]))
        border_cells_patches <- rbind(border_cells_patches, cur_df)
      }

      ## case where patch includes two cells - no hull can be computed
      if (nrow(cur_df) == 2){
        polygon = st_multipoint(as.matrix(cur_df[,2:3]))
        border_cells_patches <- rbind(border_cells_patches, cur_df)
      }

      ## more than 2 cells - hull can be computed
      if (nrow(cur_df) > 2){
        ## compute hull of patch (default is concave)
        if(convex == TRUE){
          # find convex hull
          hull = chull(x = cur_df$X, y = cur_df$Y)

          # cells that build the border of a patch
          border_cells = cur_df[hull,]

          # add cells to the list for the whole image
          border_cells_patches = rbind(border_cells_patches, border_cells)
          coordinates = as.matrix(border_cells[,2:3])

          # close the polygon (first row = last row)
          coordinates = rbind(coordinates, coordinates[1,])

          # create polygon object
          polygon = st_polygon(list(coordinates))
        }

        if(convex == FALSE){
          # compute concave hull
          coords <- as.matrix(cbind(cur_df$X, cur_df$Y))
          hull = data.frame(concaveman(coords, concavity = 1))
          colnames(hull) <- c("X", "Y")

          # return common rows between input and the hull
          # first, we need to round the digits of cur_df since concaveman does not return full-length coordinates
          # (see github issue https://github.com/joelgombin/concaveman/issues/13)
          # is obsolete once the bug is fixed
          cur_df_2 <- copy(cur_df)
          cur_df_2$X <- round(cur_df_2$X, digits = 4)
          cur_df_2$Y <- round(cur_df_2$Y, digits = 4)

          # find common rows
          border_cells <- inner_join(hull, cur_df_2, by = c("X", "Y"))

          # return original rows from data set with full-length cooridantes
          border_cells <- cur_df[cur_df$cellID %in% border_cells$cellID,]

          # add cells to the list for the whole image
          border_cells_patches = rbind(border_cells_patches, border_cells)

          # create polygon object
          polygon = st_polygon(list(as.matrix(hull)))
        }
      }

      # buffer/enlarge polygon by "distance" pixels
      polygon_buff = st_buffer(polygon, distance)
      polygon_buff_sfc = st_sfc(polygon_buff)

      if(plot == TRUE){
      polygon_plots <- polygon_plots +
        geom_sf(data = polygon, fill = NA, size = 4, col = "deepskyblue2") +
        geom_sf(data = polygon_buff_sfc, fill = NA, size=4, col = "blue")
      }

      # return coordinates of the enlarged polygon
      enlarged_coordinates = as.data.frame(polygon_buff[1])

      # define cells within this enlarged polygon
      intersect <- st_intersects(polygon_buff_sfc, cells_sfc)
      intersect <- rownames(as.data.frame(cells[intersect[[1]],]))
      milieu_cells <- rbind(milieu_cells, input_df[input_df$cellID %in% intersect,])

      # assing patch ID to cells - if a milieu already has been assigned
      if(nrow(input_df[input_df$cellID %in% intersect & !is.na(input_df$milieu),]) > 0){
        input_df[input_df$cellID %in% intersect & !is.na(input_df$milieu),]$milieu =
          paste(input_df[input_df$cellID %in% intersect & !is.na(input_df$milieu),]$milieu,i, sep="_")
      }
      # assing patch ID to cells - if no milieu has been assinged yet
      if(nrow(input_df[input_df$cellID %in% intersect & is.na(input_df$milieu),]) > 0){
        input_df[input_df$cellID %in% intersect & is.na(input_df$milieu),]$milieu = i
      }
    }

    ## find the closest border_cell and assing same milieu (for visualization purposes)
    # cells with multiple milieus
    multi_milieu <- input_df[grep("_", input_df$milieu),]

    # select current image
    multi_milieu <- multi_milieu[multi_milieu$ImageNumber == j, ]

    # only cells which are not part of a patch - (non-chemokine producers)
    multi_milieu <- multi_milieu[multi_milieu$patch == 0,]

    # nearest neighbour search (for k = number of border cells)
    if(nrow(multi_milieu) > 0){
      nn <- nn2(data = border_cells_patches[,2:3], query = multi_milieu[,2:3], k = nrow(border_cells_patches))

      # first column of nn.idx is the row-index of the border_cell with the lowest distance
      input_df[input_df$cellID %in% multi_milieu$cellID,]$unique_milieu <- border_cells_patches[nn$nn.idx[,1],]$patch
    }

    if(plot == TRUE){
      # all patch cells
      clust_cells <- input_df[input_df$ImageNumber == j & input_df$patch != 0,]
      p <- polygon_plots +
             geom_sf(data = cells_sfc, color = alpha("black",0.3), size = point_size) +
             geom_point(data = clust_cells, aes(x = X, y = Y), color = "red",size = point_size) +
             ggtitle(paste(ImageNumber, j, sep = ": "))
      if(is.null(xlim) == FALSE & is.null(ylim) == FALSE){
        p <- p + xlim(xlim) + ylim(ylim)
      }
      plot(p + theme_void() + theme(plot.title = element_text(hjust = 0.5)))
    }
  }

  # assign for each cell a unique milieu
  input_df[input_df$patch == 0 & is.na(input_df$milieu),]$unique_milieu = 0
  input_df[input_df$patch != 0,]$unique_milieu = input_df[input_df$patch != 0,]$patch
  input_df[is.na(input_df$unique_milieu),]$unique_milieu = input_df[is.na(input_df$unique_milieu),]$milieu

  end <- Sys.time()
  print(end-start)

  # check if cellIDs have same sorting in both data sets - if yes, return sce with new colData
  if(all(input_df$cellID == input_sce[[cellID]]) == TRUE){
    if("closest_milieu" %in% colnames(colData(input_sce))){
      colData(input_sce)$closest_milieu <- NULL
    }
    colData(input_sce)$closest_milieu <- input_df$unique_milieu
    # overwrite column name of milieu ID column
    names(colData(input_sce))[length(names(colData(input_sce)))] <- output_colname
    print("milieus successfully added to sce object")
    return(input_sce)
  }

  # check if cellIDs have same sorting in both data sets - if not, return input_df instead of sce
  if(!(all(IDs$cellID == input_sce[[cellID]]) == TRUE)){
    print("Output SCE does not contain same cells as input SCE. For safety reasons, data.frame instead of SCE is returned")
    return(input_df)
  }
}
