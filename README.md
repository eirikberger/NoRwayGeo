# NoRwayGeo <a href="https://github.com/eirikberger/NoRwayGeo"><img src="https://raw.githubusercontent.com/eirikberger/NoRwayGeo/main/logo.png" align="right" height="140" /></a>

The package uses a cleaned version of SSB's overview of [historical changes in the municipality structure](https://www.ssb.no/metadata/alle-endringer-i-de-regionale-inndelingene/_/attachment/download/fe7adaa5-aeca-401f-95ff-688465ecf48f:0700aa845b3e92021383b96789be7237f87650ba/kommuneendringer_1838_2017.xlsx) to produce clusters of municipalities that can be followed consistently between two given years. 

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("eirikberger/NoRwayGeo", auth_token="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")
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

# Logo

The logo for this package uses a self portrait of famous Norwegian painter [Nikolai Astrup](https://en.wikipedia.org/wiki/Nikolai_Astrup) (1880–1928). His name brother, [Nikolai Astrup](https://en.wikipedia.org/wiki/Nikolai_Astrup_(politician)), was a minister in the Norwegian Government responsible for merging municipalities as a part of a large reform in 2020-2021. He is therefore responsible for increasing the problem of inconsistent municipality structures over time in Norwegian data, that this package attempts to solve. 
