# helper function to generate barplot split by colData and colored by celltype.

plotCellCounts <- function(x, colour_by = NULL, split_by = NULL, proportion = FALSE){

  # Check if x is SingleCellExpriment
  .sceCheck(x)

  # Check if selected variable exists
  entries <- colnames(colData(x))
  if(!is.null(colour_by)){
    if(!(colour_by %in% entries)){
      stop("The entry for colour_by is not a colData slot of the object.")
    }
  }
  if(!is.null(split_by)){
    if(!(split_by %in% entries)){
      stop("The entry for split_by is not a colData slot of the object.")
    }
  }

  # Plot the counts
  if(!is.null(split_by)){
    cur_df <- data.frame(split_by = as.factor(colData(x)[,split_by]))
  } else {
    cur_df <- data.frame(split_by = as.factor(rep("All", ncol(x))))
  }

  if(!is.null(colour_by)){
    cur_df$colour_by <- as.factor(colData(x)[,colour_by])
  } else {
    cur_df$colour_by <- as.factor(rep("All", ncol(x)))
  }

  if(proportion){
    df_sum <- reshape2::melt(table(cur_df)/rowSums(table(cur_df)))

    ggplot(df_sum) + geom_bar(aes(x = split_by, y = value, fill = colour_by), stat = "identity") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            axis.title.x = element_blank(),
            panel.background = element_blank(),
            panel.grid.minor=element_blank(),
            panel.grid.major.x=element_blank(),
            panel.grid.major.y=element_line(color="grey", size=.3)) +
      ylab("Cell counts") + scale_fill_discrete(name = colour_by)

  } else {
    ggplot(cur_df) + geom_bar(aes(x = split_by, fill = colour_by)) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            axis.title.x = element_blank(),
            panel.background = element_blank(),
            panel.grid.minor=element_blank(),
            panel.grid.major.x=element_blank(),
            panel.grid.major.y=element_line(color="grey", size=.3)) +
      ylab("Cell counts") + scale_fill_discrete(name = colour_by)

  }
}
