---
title: "Supp-Figure_2"
author: "toobiwankenobi"
date: "2020-10-13"
output: workflowr::wflow_html
editor_options:
  chunk_output_type: console
---

<p>
<button type="button" class="btn btn-default btn-workflowr btn-workflowr-report"
  data-toggle="collapse" data-target="#workflowr-report">
  <span class="glyphicon glyphicon-list" aria-hidden="true"></span>
  workflowr
  <span class="glyphicon glyphicon-exclamation-sign text-danger" aria-hidden="true"></span>
</button>
</p>

<div id="workflowr-report" class="collapse">
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#summary">Summary</a></li>
  <li><a data-toggle="tab" href="#checks">
  Checks <span class="glyphicon glyphicon-exclamation-sign text-danger" aria-hidden="true"></span>
  </a></li>
  <li><a data-toggle="tab" href="#versions">Past versions</a></li>
</ul>

<div class="tab-content">
<div id="summary" class="tab-pane fade in active">
  <p><strong>Last updated:</strong> 2020-10-13</p>
  <p><strong>Checks:</strong>
  <span class="glyphicon glyphicon-ok text-success" aria-hidden="true"></span>
  6
  <span class="glyphicon glyphicon-exclamation-sign text-danger" aria-hidden="true"></span>
  1
  </p>
  <p><strong>Knit directory:</strong>
  <code>melanoma_publication_old_data/</code>
  <span class="glyphicon glyphicon-question-sign" aria-hidden="true"
  title="This is the local directory in which the code in this file was executed.">
  </span>
  </p>
  <p>
  This reproducible <a href="http://rmarkdown.rstudio.com">R Markdown</a>
  analysis was created with <a
  href="https://github.com/jdblischak/workflowr">workflowr</a> (version
  1.6.2). The <em>Checks</em> tab describes the
  reproducibility checks that were applied when the results were created.
  The <em>Past versions</em> tab lists the development history.
  </p>
<hr>
</div>
<div id="checks" class="tab-pane fade">
  <div class="panel-group" id="workflowr-checks">
  <div class="panel panel-default">
<div class="panel-heading">
<p class="panel-title">
<a data-toggle="collapse" data-parent="#workflowr-checks" href="#strongRMarkdownfilestronguncommittedchanges">
  <span class="glyphicon glyphicon-exclamation-sign text-danger" aria-hidden="true"></span>
  <strong>R Markdown file:</strong> uncommitted changes
</a>
</p>
</div>
<div id="strongRMarkdownfilestronguncommittedchanges" class="panel-collapse collapse">
<div class="panel-body">
  The R Markdown is untracked by Git. 
To know which version of the R Markdown file created these
results, you'll want to first commit it to the Git repo. If
you're still working on the analysis, you can ignore this
warning. When you're finished, you can run
<code>wflow_publish</code> to commit the R Markdown file and
build the HTML.

</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading">
<p class="panel-title">
<a data-toggle="collapse" data-parent="#workflowr-checks" href="#strongEnvironmentstrongempty">
  <span class="glyphicon glyphicon-ok text-success" aria-hidden="true"></span>
  <strong>Environment:</strong> empty
</a>
</p>
</div>
<div id="strongEnvironmentstrongempty" class="panel-collapse collapse">
<div class="panel-body">
  
Great job! The global environment was empty. Objects defined in the global
environment can affect the analysis in your R Markdown file in unknown ways.
For reproduciblity it's best to always run the code in an empty environment.

</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading">
<p class="panel-title">
<a data-toggle="collapse" data-parent="#workflowr-checks" href="#strongSeedstrongcodesetseed20200728code">
  <span class="glyphicon glyphicon-ok text-success" aria-hidden="true"></span>
  <strong>Seed:</strong> <code>set.seed(20200728)</code>
</a>
</p>
</div>
<div id="strongSeedstrongcodesetseed20200728code" class="panel-collapse collapse">
<div class="panel-body">
  
The command <code>set.seed(20200728)</code> was run prior to running the code in the R Markdown file.
Setting a seed ensures that any results that rely on randomness, e.g.
subsampling or permutations, are reproducible.

</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading">
<p class="panel-title">
<a data-toggle="collapse" data-parent="#workflowr-checks" href="#strongSessioninformationstrongrecorded">
  <span class="glyphicon glyphicon-ok text-success" aria-hidden="true"></span>
  <strong>Session information:</strong> recorded
</a>
</p>
</div>
<div id="strongSessioninformationstrongrecorded" class="panel-collapse collapse">
<div class="panel-body">
  
Great job! Recording the operating system, R version, and package versions is
critical for reproducibility.

</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading">
<p class="panel-title">
<a data-toggle="collapse" data-parent="#workflowr-checks" href="#strongCachestrongnone">
  <span class="glyphicon glyphicon-ok text-success" aria-hidden="true"></span>
  <strong>Cache:</strong> none
</a>
</p>
</div>
<div id="strongCachestrongnone" class="panel-collapse collapse">
<div class="panel-body">
  
Nice! There were no cached chunks for this analysis, so you can be confident
that you successfully produced the results during this run.

</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading">
<p class="panel-title">
<a data-toggle="collapse" data-parent="#workflowr-checks" href="#strongFilepathsstrongrelative">
  <span class="glyphicon glyphicon-ok text-success" aria-hidden="true"></span>
  <strong>File paths:</strong> relative
</a>
</p>
</div>
<div id="strongFilepathsstrongrelative" class="panel-collapse collapse">
<div class="panel-body">
  
Great job! Using relative paths to the files within your workflowr project
makes it easier to run your code on other machines.

</div>
</div>
</div>
<div class="panel panel-default">
<div class="panel-heading">
<p class="panel-title">
<a data-toggle="collapse" data-parent="#workflowr-checks" href="#strongRepositoryversionstrongahrefhttpsgithubcomBodenmillerGroupmelanomapublicationtreec3e8a470a34a0512f7c31e40da611e115ce6cd53targetblankc3e8a47a">
  <span class="glyphicon glyphicon-ok text-success" aria-hidden="true"></span>
  <strong>Repository version:</strong> <a href="https://github.com/BodenmillerGroup/melanoma_publication/tree/c3e8a470a34a0512f7c31e40da611e115ce6cd53" target="_blank">c3e8a47</a>
</a>
</p>
</div>
<div id="strongRepositoryversionstrongahrefhttpsgithubcomBodenmillerGroupmelanomapublicationtreec3e8a470a34a0512f7c31e40da611e115ce6cd53targetblankc3e8a47a" class="panel-collapse collapse">
<div class="panel-body">
  
<p>
Great! You are using Git for version control. Tracking code development and
connecting the code version to the results is critical for reproducibility.
</p>

<p>
The results in this page were generated with repository version <a href="https://github.com/BodenmillerGroup/melanoma_publication/tree/c3e8a470a34a0512f7c31e40da611e115ce6cd53" target="_blank">c3e8a47</a>.
See the <em>Past versions</em> tab to see a history of the changes made to the
R Markdown and HTML files.
</p>

<p>
Note that you need to be careful to ensure that all relevant files for the
analysis have been committed to Git prior to generating the results (you can
use <code>wflow_publish</code> or <code>wflow_git_commit</code>). workflowr only
checks the R Markdown file, but you know if there are other scripts or data
files that it depends on. Below is the status of the Git repository when the
results were generated:
</p>

<pre><code>
Ignored files:
	Ignored:    .DS_Store
	Ignored:    .Rhistory
	Ignored:    .Rproj.user/
	Ignored:    ._.DS_Store
	Ignored:    analysis/.DS_Store
	Ignored:    analysis/._.DS_Store
	Ignored:    analysis/._01_RNA_read_data.rmd
	Ignored:    analysis/._03_Protein_quality_control.rmd
	Ignored:    analysis/._04_1_Protein_celltype_classification.rmd
	Ignored:    analysis/._07_RNA_chemokine_community_clustering.Rmd
	Ignored:    analysis/._Supp-Figure_1.rmd
	Ignored:    code/.DS_Store
	Ignored:    code/._.DS_Store
	Ignored:    data/.DS_Store
	Ignored:    data/._.DS_Store
	Ignored:    data/._survdat_for_modelling.csv
	Ignored:    data/12plex_validation/
	Ignored:    data/200323_TMA_256_Hot Cold_Clinical Data_Updated Response Data_For Collaborators_latest updated_Mar_2020_for_Coxph_modeling.csv
	Ignored:    data/colour_vector.rds
	Ignored:    data/layer_1_classification_protein.csv
	Ignored:    data/layer_1_classification_rna.csv
	Ignored:    data/protein/
	Ignored:    data/rna/
	Ignored:    data/sce_RNA.rds
	Ignored:    data/sce_protein.rds
	Ignored:    data/survdat_for_modelling.csv

Untracked files:
	Untracked:  analysis/Supp-Figure_2.rmd
	Untracked:  analysis/XX_Protein_NeighbouRhood_analysis.Rmd
	Untracked:  analysis/XX_RNA_NeighbouRhood_analysis.Rmd

Unstaged changes:
	Modified:   analysis/05_protein_Tcell_quantification.Rmd
	Modified:   analysis/06_Protein_Ki67status.Rmd
	Modified:   analysis/XX_cohort_summary.Rmd
	Deleted:    data/T_frac_score_per_BlockID
	Deleted:    data/T_frac_score_per_Description
	Deleted:    data/T_frac_score_per_ImageNumber

</code></pre>

<p>
Note that any generated files, e.g. HTML, png, CSS, etc., are not included in
this status report because it is ok for generated content to have uncommitted
changes.
</p>

</div>
</div>
</div>
</div>
<hr>
</div>
<div id="versions" class="tab-pane fade">
  <p>There are no past versions. Publish this analysis with
      <code>wflow_publish()</code> to start tracking its development.</p>
<hr>
</div>
</div>
</div>






# Introduction
This script gives an overview over the clinical data and generates statistics used in the manuscript.

# Preparations



## Load libraries


```r
sapply(list.files("code/helper_functions", full.names = TRUE), source)
```

```
        code/helper_functions/calculateSummary.R
value   ?                                       
visible FALSE                                   
        code/helper_functions/censor_dat.R
value   ?                                 
visible FALSE                             
        code/helper_functions/detect_mRNA_expression.R
value   ?                                             
visible FALSE                                         
        code/helper_functions/DistanceToClusterCenter.R
value   ?                                              
visible FALSE                                          
        code/helper_functions/findClusters.R
value   ?                                   
visible FALSE                               
        code/helper_functions/findCommunity.R
value   ?                                    
visible FALSE                                
        code/helper_functions/getCellCount.R
value   ?                                   
visible FALSE                               
        code/helper_functions/getInfoFromString.R
value   ?                                        
visible FALSE                                    
        code/helper_functions/getSpotnumber.R
value   ?                                    
visible FALSE                                
        code/helper_functions/plotBarFracCluster.R
value   ?                                         
visible FALSE                                     
        code/helper_functions/plotCellCounts.R
value   ?                                     
visible FALSE                                 
        code/helper_functions/plotCellFrac.R
value   ?                                   
visible FALSE                               
        code/helper_functions/plotCellFracGroups.R
value   ?                                         
visible FALSE                                     
        code/helper_functions/plotCellFracGroupsSubset.R
value   ?                                               
visible FALSE                                           
        code/helper_functions/plotDist.R
value   ?                               
visible FALSE                           
        code/helper_functions/scatter_function.R
value   ?                                       
visible FALSE                                   
        code/helper_functions/sceChecks.R
value   ?                                
visible FALSE                            
        code/helper_functions/validityChecks.R
value   ?                                     
visible FALSE                                 
```

```r
library(data.table)
library(survival)
library(ggplot2)
library(broom)
library(dplyr)
library(RColorBrewer)
library(ggalluvial)
library(tidyverse)
library(cowplot)
```

## Load Data


```r
# clinical data
dat <- read_csv("data/protein/clinical_data_protein.csv")

# SCE object
sce = readRDS(file = "data/sce_protein.rds")
```

# Analysis

## Clinical features of the cohort 

Note: as the cohort is very diverse, we are using the BlockID as the minimal unit since clinical parameters are described per BlockID. However, sometimes we do have patients of which we have multiple FFPE blocks (BlockIDs). Nonetheless, clinical parameters are not given per patient but per patient FFPE block and are therefore considered the minimial unit.

## Number of Samples


```r
dat[dat$BlockID %in% unique(sce[,sce$Location == "CTRL"]$BlockID),]$MM_location <- "Control"

# remove control samples
dat <- dat[dat$BlockID %in% unique(sce[,sce$Location != "CTRL"]$BlockID),]

p1 <- unique(dat[,c("BlockID","MM_location")]) %>%
  ggplot()+
  geom_bar(aes(y=MM_location),stat ="count") +
  xlab("BlockIDs per Location") +
  ylab("Metastasis Location") +
  theme(text = element_text(size=18))
  
p2 <- dat %>%
  ggplot()+
  geom_bar(aes(x=BlockID, fill=(MM_location)),stat="count")+
  theme(axis.text.x = element_text(angle = 90,vjust = 0.5)) + 
  ylab("Number of Samples") +
  guides(fill=guide_legend(title="Metasis Location")) +
  theme(text = element_text(size=18))

plot_grid(p1,p2,rel_widths = c(1,3))  
```

<img src="figure/Supp-Figure_2.rmd/Supp_Figure_2A-1.png" width="1728" style="display: block; margin: auto;" />

## Location Information


```r
cur_df <- dat %>%
  select(BlockID,Nr_treatments_before_surgery,MM_location,Treatment_after_surgery, Status_at_3m, Date_death,Location,Cancer_Stage, E_I_D)
cur_df <- unique(cur_df)
cur_df$Death <- "Dead"
cur_df[which(is.na(cur_df$Date_death)),]$Death <- "Alive"

# Alluvial plot
cur_df %>%
  dplyr::count(MM_location,Cancer_Stage,Location,E_I_D) %>%
  ggplot(aes(axis1 = MM_location, axis2 = Cancer_Stage, axis3 = Location,axis4 = E_I_D,y=n))+
  geom_alluvium(aes(fill=as.factor(MM_location)))+
  geom_stratum()+
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  theme_minimal()+
  scale_x_discrete(limits = c("Met Location", "Cancer Stage", "Punch position", "Global Infiltration"), expand = c(.2, .05)) +
  theme(text = element_text(size=18)) +
  guides(fill=guide_legend(title="Metasis Location")) +
  ylab("Number of Samples")
```

<img src="figure/Supp-Figure_2.rmd/Supp_Figure_2B-1.png" width="1344" style="display: block; margin: auto;" />

## Treamtents before Surgery


```r
cur_df %>%
  dplyr::count(MM_location, Nr_treatments_before_surgery, Cancer_Stage,Death) %>%
  ggplot(aes(axis1 = MM_location, axis2 = Nr_treatments_before_surgery, axis3 = Cancer_Stage,axis4 = Death,y=n))+
  geom_alluvium(aes(fill=as.factor(Death)))+
  geom_stratum()+
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  theme_minimal()+
  scale_x_discrete(limits = c("Met Location", "# Previous Treatments", "Cancer Stage", "Outcome"), expand = c(.2, .05)) +
  theme(text = element_text(size=18)) +
  guides(fill=guide_legend(title="Outcome")) +
  ylab("Number of Samples")
```

<img src="figure/Supp-Figure_2.rmd/Supp_Figure_2C-1.png" width="1344" style="display: block; margin: auto;" />


<br>
<p>
<button type="button" class="btn btn-default btn-workflowr btn-workflowr-sessioninfo"
  data-toggle="collapse" data-target="#workflowr-sessioninfo"
  style = "display: block;">
  <span class="glyphicon glyphicon-wrench" aria-hidden="true"></span>
  Session information
</button>
</p>

<div id="workflowr-sessioninfo" class="collapse">

```r
sessionInfo()
```

```
R version 4.0.2 (2020-06-22)
Platform: x86_64-apple-darwin17.0 (64-bit)
Running under: macOS High Sierra 10.13.6

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRblas.dylib
LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] parallel  stats4    stats     graphics  grDevices utils     datasets 
[8] methods   base     

other attached packages:
 [1] SingleCellExperiment_1.10.1 SummarizedExperiment_1.18.2
 [3] DelayedArray_0.14.1         matrixStats_0.56.0         
 [5] Biobase_2.48.0              GenomicRanges_1.40.0       
 [7] GenomeInfoDb_1.24.2         IRanges_2.22.2             
 [9] S4Vectors_0.26.1            BiocGenerics_0.34.0        
[11] cowplot_1.0.0               forcats_0.5.0              
[13] stringr_1.4.0               purrr_0.3.4                
[15] readr_1.3.1                 tidyr_1.1.1                
[17] tibble_3.0.3                tidyverse_1.3.0            
[19] ggalluvial_0.12.2           RColorBrewer_1.1-2         
[21] dplyr_1.0.2                 broom_0.7.0                
[23] ggplot2_3.3.2               survival_3.1-12            
[25] data.table_1.13.0           workflowr_1.6.2            

loaded via a namespace (and not attached):
 [1] httr_1.4.2             jsonlite_1.7.0         splines_4.0.2         
 [4] modelr_0.1.8           assertthat_0.2.1       blob_1.2.1            
 [7] GenomeInfoDbData_1.2.3 cellranger_1.1.0       yaml_2.2.1            
[10] pillar_1.4.6           backports_1.1.8        lattice_0.20-41       
[13] glue_1.4.1             digest_0.6.25          promises_1.1.1        
[16] XVector_0.28.0         rvest_0.3.6            colorspace_1.4-1      
[19] htmltools_0.5.0        httpuv_1.5.4           Matrix_1.2-18         
[22] pkgconfig_2.0.3        haven_2.3.1            zlibbioc_1.34.0       
[25] scales_1.1.1           later_1.1.0.1          git2r_0.27.1          
[28] farver_2.0.3           generics_0.0.2         ellipsis_0.3.1        
[31] withr_2.2.0            cli_2.0.2              magrittr_1.5          
[34] crayon_1.3.4           readxl_1.3.1           evaluate_0.14         
[37] fs_1.5.0               fansi_0.4.1            xml2_1.3.2            
[40] tools_4.0.2            hms_0.5.3              lifecycle_0.2.0       
[43] munsell_0.5.0          reprex_0.3.0           compiler_4.0.2        
[46] rlang_0.4.7            grid_4.0.2             RCurl_1.98-1.2        
[49] rstudioapi_0.11        labeling_0.3           bitops_1.0-6          
[52] rmarkdown_2.3          gtable_0.3.0           DBI_1.1.0             
[55] R6_2.4.1               lubridate_1.7.9        knitr_1.29            
[58] rprojroot_1.3-2        stringi_1.4.6          Rcpp_1.0.5            
[61] vctrs_0.3.2            dbplyr_1.4.4           tidyselect_1.1.0      
[64] xfun_0.16             
```
</div>
