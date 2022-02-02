# Docker inheritance
FROM rocker/rstudio:4.1.2

RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils \
	&& apt-get install -y --no-install-recommends \
	zlib1g-dev libfftw3-dev \
	## Remove packages in '/var/cache/' and 'var/lib'
	## to remove side-effects of apt-get update
	&& apt-get clean \
	&& rm -rf /var/lib/apt/ilists/* 

RUN R -e 'install.packages("BiocManager")'
RUN R -e 'BiocManager::install(version = "3.14", update = TRUE, ask = FALSE)'
RUN R -e 'BiocManager::install(c("abind", "ALL", "ape", "ash", "askpass", "assertthat", "backports", 
"base64enc", "bdsmatrix", "beachmat", "beeswarm", "BH", "Biobase", 
"BiocGenerics", "BiocManager", "BiocNeighbors", "BiocParallel", 
"BiocSingular", "BiocVersion", "bitops", "blob", "boot", "brew", 
"brio", "broom", "Cairo", "callr", "car", "carData", "caret", 
"CATALYST", "cba", "cellranger", "checkmate", "circlize", "classInt", 
"cli", "clipr", "clisymbols", "clue", "colorRamps", "colorspace", 
"commonmark", "ComplexHeatmap", "concaveman", "conquer", "ConsensusClusterPlus", 
"corpcor", "corrplot", "covr", "cowplot", "coxme", "cpp11", "crayon", 
"credentials", "crosstalk", "curl", "cytolib", "cytomapper", 
"CytoML", "d3r", "data.table", "DBI", "dbplyr", "DelayedArray", 
"DelayedMatrixStats", "deldir", "dendextend", "DEoptimR", "desc", 
"destiny", "devtools", "diffobj", "digest", "diptest", "dittoSeq", 
"docopt", "doParallel", "downlit", "dplyr", "dqrng", "drc", "DT", 
"dtplyr", "e1071", "EBImage", "edgeR", "ellipse", "ellipsis", 
"evaluate", "exactRankTests", "fansi", "farver", "fastmap", "fda", 
"fds", "fftwtools", "flexmix", "flowClust", "flowCore", "FlowSOM", 
"flowStats", "flowUtils", "flowViz", "flowWorkspace", "FNN", 
"forcats", "foreach", "foreign", "formatR", "Formula", "fpc", 
"fs", "futile.logger", "futile.options", "gdata", "gdtools", 
"generics", "GenomeInfoDb", "GenomeInfoDbData", "GenomicRanges", 
"gert", "GetoptLong", "getPass", "ggalluvial", "ggbeeswarm", 
"ggcyto", "ggplot.multistats", "ggplot2", "ggpmisc", "ggpubr", 
"ggrastr", "ggrepel", "ggridges", "ggsci", "ggsignif", "ggsunburst", 
"ggthemes", "gh", "git2r", "gitcreds", "GlobalOptions", "glue", 
"gmodels", "goftest", "gower", "graph", "gridExtra", "gtable", 
"gtools", "haven", "HDF5Array", "hdrcde", "hexbin", "highr", 
"Hmisc", "hms", "htmlTable", "htmltools", "htmlwidgets", "httpuv", 
"httr", "IDPmisc", "igraph", "ini", "ipred", "IRanges", "irlba", 
"isoband", "iterators", "janitor", "jpeg", "jsonlite", "kableExtra", 
"kernlab", "km.ci", "KMsurv", "knitr", "knn.covertree", "ks", 
"labeling", "laeken", "lambda.r", "later", "latticeExtra", "lava", 
"lazyeval", "lifecycle", "limma", "littler", "lme4", "lmerTest", 
"lmtest", "locfit", "LSD", "lubridate", "magick", "magrittr", 
"maptools", "markdown", "MASS", "MatrixGenerics", "MatrixModels", 
"matrixStats", "maxstat", "mclust", "memoise", "mime", "minqa", 
"mnormt", "ModelMetrics", "modelr", "modeltools", "multcomp", 
"multicool", "munsell", "mvtnorm", "ncdfFlow", "NCmisc", "neighbouRhood", 
"nlme", "nloptr", "nnls", "numDeriv", "openCyto", "openssl", 
"openxlsx", "papeR", "pbkrtest", "pcaMethods", "pcaPP", "pheatmap", 
"pillar", "pkgbuild", "pkgconfig", "pkgdown", "pkgload", "plotly", 
"plotrix", "plyr", "png", "polspline", "polyclip", "polynom", 
"prabclus", "praise", "prettyunits", "princurve", "pROC", "processx", 
"prodlim", "proftools", "progress", "promises", "proxy", "ps", 
"psych", "purrr", "quantreg", "R.methodsS3", "R.oo", "R.utils", 
"R6", "ragg", "rainbow", "randomcoloR", "randomForest", "ranger", 
"RANN", "rappdirs", "raster", "RBGL", "rcmdcheck", "RColorBrewer", 
"Rcpp", "RcppAnnoy", "RcppArmadillo", "RcppEigen", "RcppHNSW", 
"RcppParallel", "RcppProgress", "RCurl", "readr", "readxl", "recipes", 
"rematch", "rematch2", "remotes", "reprex", "reshape2", "reticulate", 
"rex", "Rgraphviz", "rhdf5", "Rhdf5lib", "rio", "rjson", "rlang", 
"rmarkdown", "rms", "robustbase", "roxygen2", "Rphenograph", 
"rprojroot", "RProtoBufLib", "rrcov", "RSpectra", "rstatix", 
"rstudioapi", "rsvd", "Rtsne", "Rtsne.multicore", "RUnit", "rversions", 
"rvest", "S4Vectors", "sandwich", "scales", "scater", "scatterplot3d", 
"selectr", "sessioninfo", "sf", "shape", "shiny", "shinydashboard", 
"shinyjs", "SingleCellExperiment", "sitmo", "slingshot", "smoother", 
"snakecase", "snow", "sourcetools", "sp", "SparseM", "spatstat", 
"spatstat.data", "spatstat.utils", "spicyR", "splus2R", "SQUAREM", 
"statmod", "stringi", "stringr", "SummarizedExperiment", "sunburstR", 
"survival", "survminer", "survMisc", "svglite", "svgPanZoom", 
"sys", "systemfonts", "tensor", "testthat", "textshaping", "TH.data", 
"threejs", "tibble", "tidyr", "tidyselect", "tidyverse", "tiff", 
"timeDate", "tinytex", "tmvnsim", "tsne", "TTR", "umap", "units", 
"usethis", "utf8", "uwot", "V8", "vcd", "vctrs", "VennDiagram", 
"VIM", "vipor", "viridis", "viridisLite", "waldo", "webshot", 
"whisker", "withr", "workflowr", "xfun", "XML", "xml2", "xopen", 
"xtable", "xts", "XVector", "yaml", "zip", "zlibbioc", "zoo"))'

RUN mkdir /home/rstudio/MelanomaIMC

COPY . /home/rstudio/MelanomaIMC

