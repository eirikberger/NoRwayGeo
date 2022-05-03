# NoRwayGeo <a href="https://github.com/eirikberger/NoRwayGeo"><img src="https://raw.githubusercontent.com/eirikberger/NoRwayGeo/main/logo.png?token=GHSAT0AAAAAABPXA6QTGI2OTLNKVSBURC6AYTRSXIQ" align="right" height="140" /></a>

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("eirikberger/NoRwayGeo")
```

# Using it

The current version of the package only supports Norwegian municipalities, which are built in. 


``` r
# Load library
library(NoRwayGeo)

# Run commands for years between and including 1980 and 2000.
print_changes(1980, 2000)
print_clusters(1980, 2000)
graph_clusters(1980, 2000)
count_clusters(1980, 2000)
```
