#' helper function to generate boxplot split_by colData for celltype fractions
#' @param sce SingleCellExperiment object
#' @param imageID colData entry name for unique image identifier (e.g. "ImageNumber")
#' @param cellID (optional) colData entry name for unique cell identifier (e.g. "cellID")
#' @param celltype_column colData entry name for cell type
#' @param celltype_subsets (optional) (character) vector containing subsets of `celltype_column` entries for visualization
#' @param merge_subsets (optional) logical, should subset fractions be summed up?
#' @param colour_vector (optional) named colour vector. names(color_vector) must return subsets indicated by `celltype_subsets`
#' @param split_by split plots by variable (colData entry)
#' @param facet_wrap (optional) logical, facet_wrap by `split_by`
#' @param show_n (optional) logical, should sample size be plotted on x-axis?
#'
#' @import grDevices
#' @importFrom ggbeeswarm geom_quasirandom
#' @import ggplot2
#' @return ggplot objects
#' @export

plotCellFractions <- function(sce,
                              imageID = NULL,
                              celltype_column = NULL,
                              celltype_subsets = NULL,
                              merge_subsets = FALSE,
                              split_by = NULL,
                              colour_vector = NULL,
                              show_n = TRUE,
                              facet_wrap = FALSE){

  # validity checks
  .plotCellFractionsCheck(sce, imageID, celltype_column, celltype_subsets, merge_subsets, split_by, show_n, facet_wrap)

  # check if color vector is correct
  if(!is.null(colour_vector) & is.null(celltype_subsets)){
    if(all(names(colour_vector) %in% unique(colData(sce)[,celltype_column])) != TRUE){
      stop("names(color_vector) is not equal to unique celltype_column entries")
    }
  }

  if(!is.null(colour_vector) & !is.null(celltype_subsets)){
    if(all(celltype_subsets %in% names(colour_vector)) != TRUE){
      stop("names(color_vector) is not equal to celltype_subsets entries")
    } else {
      # subset colour_vector if only a subset will be plottet
      colour_vector <- colour_vector[celltype_subsets]
    }
  }

  # create color vector if none is provided
  if(is.null(colour_vector)){
    color <- colors()[grep('gr(a|e)y', colors(), invert = T)]
    if(is.null(celltype_subsets)){
      names_celltypes <- unique(colData(sce)[,celltype_column])
      n <- length(names_celltypes)
    } else {
      names_celltypes <- unique(celltype_subsets)
      n <- length(names_celltypes)
    }
    colour_vector=sample(color, n)
    names(colour_vector) <- names_celltypes
  }

  # Calculate Fractions
  cur_df <- data.frame(colData(sce)) %>%
    mutate(split_by = .[,split_by], imageID = .[,imageID], celltype = .[,celltype_column]) %>%
    group_by(imageID, celltype) %>%
    mutate(n=n()) %>%
    distinct(celltype, .keep_all = TRUE) %>%
    group_by(imageID) %>%
    mutate(fraction = n / sum(n)) %>%
    select(split_by, imageID, celltype, fraction)

  # subset fractions if subset is provided
  if(!is.null(celltype_subsets)){
    cur_df <- cur_df[cur_df$celltype %in% celltype_subsets,]
  }

  if(merge_subsets == TRUE){
    cur_df <- cur_df %>%
      group_by(imageID) %>%
      mutate(fraction = sum(fraction)) %>%
      distinct(imageID, .keep_all = TRUE) %>%
      mutate(celltype = "Merged")
  }

  # check for NA's in grouping variable
  cur_df[is.na(cur_df$split_by) | cur_df$split_by == "",]$split_by <- "No Group"

  # Calculate sample size to indicate "n" on plots
  if(show_n == TRUE){
    sample_size <- cur_df %>%
      group_by(imageID, split_by) %>%
      distinct(imageID, .keep_all = T) %>%
      group_by(split_by) %>%
      summarise(n=n(), .groups = 'drop') %>%
      arrange(split_by)
    }

  # Generate Plot
  data <- cur_df %>%
    group_by(imageID)

  p <- ggplot(data = data, aes(x=split_by,y=fraction,fill=celltype)) +
    geom_boxplot(outlier.shape = NA, position = position_dodge(width=1)) +
    geom_quasirandom(dodge.width=1, groupOnX=TRUE, alpha=.2) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title.y = element_text(size=15),
      axis.text.y = element_text(size=12),
      axis.title.x = element_blank(),
      panel.background = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = "grey", size = .3)
    ) +
    ylab(ifelse(merge_subsets == FALSE, "Fraction of Cell Type per Image", "Summed Fractions per Image"))

  if(facet_wrap == TRUE){
    p$mapping$x <- 1
    if(show_n == TRUE){
      labels <- unique(sample_size$split_by)
      new_labels <- paste(unique(sample_size$split_by),
                      sample_size$n, sep = ", #Samples = ")
      names(new_labels) <- labels

      p <- p +
        facet_wrap(~split_by, labeller = labeller(split_by = new_labels)) +
        theme(axis.text.x = element_blank())
    }else{
      p <- p +
        facet_wrap(~split_by) +
        theme(axis.text.x = element_blank())
    }

  }

  if(merge_subsets == FALSE & show_n == FALSE){
    p <- p +
      scale_fill_manual(values = unname(colour_vector),
                        breaks = names(colour_vector),
                        labels = names(colour_vector))
  }

  if(merge_subsets == TRUE & show_n == FALSE){
    p <- p +
      theme(legend.position = "none")
  }

  if(merge_subsets == FALSE & show_n == TRUE & facet_wrap == FALSE){
    p <- p +
      scale_x_discrete(breaks = unique(sample_size$split_by),
                         labels = paste(unique(sample_size$split_by),
                                        sample_size$n, sep = "\n#Samples = ")) +
      scale_fill_manual(values = unname(colour_vector),
                        breaks = names(colour_vector),
                        labels = names(colour_vector))
  }

  if(merge_subsets == TRUE & show_n == TRUE){
    p <- p +
      scale_x_discrete(breaks = unique(sample_size$split_by),
                       labels = paste(unique(sample_size$split_by),
                                      sample_size$n, sep = "\n#Samples = ")) +
      theme(legend.position = "none")
  }
  # final plot
  plot(p)
}
