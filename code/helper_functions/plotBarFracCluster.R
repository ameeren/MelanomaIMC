# this function generates a barplot from a sce object which can be celltype_subsetted to a specific celltype_subset. the fraction is then displayed as a fraction of all cells and not as a fraction of the celltype_subset

plotBarFracCluster <- function(x, colour_by = NULL, split_by = NULL,celltype_col=NULL, celltype_subset = NULL, celltype_cluster_col=NULL, scale=c("percent","count")){

  # Check if x is SingleCellExpriment
  .sceCheck(x)

  scale <- match.arg(scale)
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
  if(is.null(celltype_col)){
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

    ggplot(cur_df) + geom_bar(aes(x = split_by, fill = colour_by)) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            axis.title.x = element_blank(),
            panel.background = element_blank(),
            panel.grid.minor=element_blank(),
            panel.grid.major.x=element_blank(),
            panel.grid.major.y=element_line(color="grey", size=.3)) +
      ylab("Cell counts") + scale_fill_discrete(name = colour_by)
  }



    else{
      if(!is.null(celltype_subset)){
        if(!(celltype_subset %in% colData(x)[,celltype_col])){
          stop("provide the name of the celltype_subset you want to display")
        }
      }

      if(is.null(celltype_cluster_col) & !is.null(celltype_subset)){
        stop("provide the colData entry of the object of clusters in celltype_cluster_col")
      }
      if(!is.null(celltype_cluster_col) & is.null(celltype_subset)){
        warning("celltype_cluster_column entry not used for plotting")
      }


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

      cur_df$cluster <- as.factor(colData(x)[,celltype_cluster_col])

      if(scale == "count"){
        cur_df %>%
          group_by(split_by) %>%
          add_count(cluster,name="n") %>%
          unique() %>%
          mutate(total = sum(n), frac = n/total) %>%
          filter(colour_by==celltype_subset) %>%
          ggplot(aes(x=split_by,y=n,fill=cluster))+
          geom_bar(stat="identity")+
          theme(axis.text.x = element_text(angle = 45, hjust = 1),
                axis.title.x = element_blank(),
                panel.background = element_blank(),
                panel.grid.minor=element_blank(),
                panel.grid.major.x=element_blank(),
                panel.grid.major.y=element_line(color="grey", size=.3)) +
          ylab("Cell count") + scale_fill_discrete(name = colour_by)
      } else {
        if(scale == "percent"){
          cur_df %>%
            group_by(split_by) %>%
            add_count(cluster,name="n") %>%
            unique() %>%
            mutate(total = sum(n), frac = n/total) %>%
            filter(colour_by==celltype_subset) %>%
            ggplot(aes(x=split_by,y=frac,fill=cluster))+
            geom_bar(stat="identity")+
            theme(axis.text.x = element_text(angle = 45, hjust = 1),
                  axis.title.x = element_blank(),
                  panel.background = element_blank(),
                  panel.grid.minor=element_blank(),
                  panel.grid.major.x=element_blank(),
                  panel.grid.major.y=element_line(color="grey", size=.3)) +
            ylab("Cell fraction of all cells per group") + scale_fill_discrete(name = colour_by)
        }

      }

    }
}

