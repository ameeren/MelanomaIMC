#' helper function to generate barplot split_by colData and colored by celltype.
#' @param sce SingleCellExperiment object
#' @param sce_sub (optional) subsetted version of input SCE as input for (normalized) visualization.
#' If normalize = TRUE, sce_sub must be a subset of sce. If normalize == FALSE, the subsetted version of the input SCE
#' must be passed to the sce parameter and not to sce_sub.
#' @param proportion plot proportions instead of absolute counts
#' @param normalize normalize counts with the total number of cells in split_by grouping
#' @param imageID colData entry name for unique image identifier (e.g. "ImageNumber")
#' @param cellID (optional) colData entry name for unique cell identifier (e.g. "cellID")
#' @param colour_vector (optional) named colour vector. names(color_vector) must return unique colour_by levels
#' @param colour_by color barplot stacks by variable
#' @param split_by split plots by variable

#' @return ggplot objects
#' @export

plotCellCounts <- function(sce,
                           sce_sub = NULL,
                           proportion = FALSE,
                           normalize = FALSE,
                           cellID = NULL,
                           imageID = NULL,
                           colour_by = NULL,
                           split_by = NULL,
                           colour_vector = NULL){

  # validity checks
  .plotCellCountsCheck(sce, sce_sub, proportion, normalize, cellID, imageID, colour_by, split_by)

  # check if color vector is correct
  if(!is.null(colour_vector) & is.null(sce_sub)){
    if(all(names(colour_vector) %in% unique(colData(sce)[,colour_by])) != TRUE){
      stop("names(color_vector) is not equal to unique colour_by levels")
    }
  }

  if(!is.null(colour_vector) & !is.null(sce_sub)){
    if(all(names(colour_vector) %in% unique(colData(sce_sub)[,colour_by])) != TRUE){
      stop("names(color_vector) is not equal to unique colour_by levels")
    }
  }

  # create color vector if none is provided
  if(is.null(colour_vector)){
    color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
    n <- length(unique(colData(sce)[,colour_by]))
    colour_vector=sample(color, n)
    names(colour_vector) <- unique(colData(sce)[,colour_by])
    }

  # Plot the counts
  if (!is.null(split_by)) {
    cur_df <- data.frame(split_by = as.factor(colData(sce)[, split_by]))
  } else {
    cur_df <- data.frame(split_by = as.factor(rep("All", ncol(sce))))
  }

  if (!is.null(colour_by)) {
    cur_df$colour_by <- as.factor(colData(sce)[, colour_by])
  } else {
    cur_df$colour_by <- as.factor(rep("All", ncol(sce)))
  }

  # calculate sample size to indicate "n" on plots
  if(is.null(sce_sub)){
    sample_size <- data.frame(colData(sce)) %>%
      mutate(split_by = .[,split_by], imageID = .[,imageID]) %>%
      group_by(imageID, split_by) %>%
      distinct(imageID, .keep_all = T) %>%
      group_by(split_by) %>%
      summarise(n=n(), .groups = 'drop')
  } else if(!is.null(sce_sub)){
    sample_size <- data.frame(colData(sce_sub)) %>%
      mutate(split_by = .[,split_by], imageID = .[,imageID]) %>%
      group_by(imageID, split_by) %>%
      distinct(imageID, .keep_all = T) %>%
      group_by(split_by) %>%
      summarise(n=n(), .groups = 'drop')
  }

  # Generate different plots
  if (proportion == TRUE) {
    df_sum <- reshape2::melt(table(cur_df) / rowSums(table(cur_df)))

    ggplot(df_sum, aes(x = split_by, y = value, fill = colour_by)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = unname(colour_vector),
                        breaks = names(colour_vector),
                        labels = names(colour_vector)) +
      scale_x_discrete(breaks = unique(df_sum$split_by),
                       labels = paste(unique(df_sum$split_by), sample_size$n, sep = "\n#Samples = ")) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_blank(),
        panel.background = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = .3)
      ) +
      ylab("Proportional Cell Counts")
  } else if (normalize == TRUE & !is.null(sce_sub)) {
    # Counts for subsetted sce
    if (!is.null(split_by)) {
      cur_df_sub <-
        data.frame(split_by = as.factor(colData(sce_sub)[, split_by]))
    } else {
      cur_df_sub <-
        data.frame(split_by = as.factor(rep("All", ncol(sce_sub))))
    }

    if (!is.null(colour_by)) {
      cur_df_sub$colour_by <- as.factor(colData(sce_sub)[, colour_by])
    } else {
      cur_df_sub$colour_by <- as.factor(rep("All", ncol(sce_sub)))
    }

    cells_per_group <-  cur_df %>%
      group_by(split_by) %>%
      summarise(n_cells_group = n(), .groups = 'drop')

    df_norm <- cur_df_sub %>%
      group_by(split_by, colour_by) %>%
      summarise(n_cells = n(), .groups = 'drop') %>%
      left_join(., cells_per_group, by = "split_by") %>%
      mutate(n_cells_norm = n_cells / n_cells_group)

    # Plot
    ggplot(df_norm, aes(x = split_by, y = n_cells_norm, fill = colour_by)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = unname(colour_vector),
                        breaks = names(colour_vector),
                        labels = names(colour_vector)) +
      scale_x_discrete(breaks = unique(df_norm$split_by),
                       labels = paste(unique(df_norm$split_by), sample_size$n, sep = "\n#Samples = ")) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_blank(),
        panel.background = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = .3)
      ) +
      ylab("Cell Fraction (Normalized by Total Group Size)")

  } else if(proportion == FALSE & normalize == FALSE) {
    ggplot(cur_df, aes(x = split_by, fill = colour_by)) +
      geom_bar() +
      scale_fill_manual(values = unname(colour_vector),
                        breaks = names(colour_vector),
                        labels = names(colour_vector)) +
      scale_x_discrete(breaks = unique(cur_df$split_by),
                       labels = paste(unique(cur_df$split_by), sample_size$n, sep = "\n#Samples = ")) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_blank(),
        panel.background = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "grey", size = .3)
      ) +
      ylab("Cell counts")
    }
}
