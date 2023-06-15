
<!-- README.md is generated from README.qmd. Please edit that file -->

# NoRwayGeo <a href="https://github.com/eirikberger/NoRwayGeo"><img src="https://raw.githubusercontent.com/eirikberger/NoRwayGeo/main/logo.png" align="right" height="140" /></a>

The package uses a cleaned version of SSB’s overview of [historical
changes in the municipality
structure](https://www.ssb.no/metadata/alle-endringer-i-de-regionale-inndelingene/_/attachment/download/fe7adaa5-aeca-401f-95ff-688465ecf48f:0700aa845b3e92021383b96789be7237f87650ba/kommuneendringer_1838_2017.xlsx)
to produce clusters of municipalities that can be followed consistently
between two given years. It was developed to meet the needs of the
author and his coauthors.

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("eirikberger/NoRwayGeo")
```

The current version of the package only supports Norwegian
municipalities, which are built in.

``` r
# Load library
library(NoRwayGeo)
```

## Consistent Municipality Structures

Run commands for years between and including 1980 and 2000.

``` r
print_changes(1980, 2000)
#>     from   to year tidligere_kommunenavn
#>  1:  102  105 1992             Sarpsborg
#>  2:  114  105 1992               Varteig
#>  3:  115  105 1992              Skjeberg
#>  4:  130  105 1992                  Tune
#>  5:  103  106 1994           Fredrikstad
#>  6:  113  106 1994                 Borge
#>  7:  131  106 1994               Rolvsøy
#>  8:  133  106 1994              Kråkerøy
#>  9:  134  106 1994                 Onsøy
#> 10: 1940 1940 1994               Kåfjord
#> 11: 2011 2011 1987            Kautokeino
#> 12: 2021 2021 1988              Karasjok
#> 13: 2025 2025 1992                  Tana
```

``` r
print_clusters(1980, 2000)
#>     muni_number      cluster
#>  1:         102 cluster_0001
#>  2:         114 cluster_0001
#>  3:         115 cluster_0001
#>  4:         130 cluster_0001
#>  5:         103 cluster_0002
#>  6:         113 cluster_0002
#>  7:         131 cluster_0002
#>  8:         133 cluster_0002
#>  9:         134 cluster_0002
#> 10:        1940 cluster_0003
#> 11:        2011 cluster_0004
#> 12:        2021 cluster_0005
#> 13:        2025 cluster_0006
#> 14:         105 cluster_0001
#> 15:         106 cluster_0002
```

``` r
graph_clusters(1980, 2000)
```

<a href="https://github.com/eirikberger/NoRwayGeo"><img src="https://raw.githubusercontent.com/eirikberger/NoRwayGeo/main/man/figures/unnamed-chunk-6-1.png"/></a>

``` r
count_clusters(1980, 2000)
#> [1] 6
```

## Linking Municipality Names to Number

The data with historical municipality names are built in. Here is an
example of how to use it.

``` r
match_municipality("Oppegaard")
```

You can also add optional argument to help the linking algorithm.

``` r
match_municipality("Oppegaard", year = 1950, county_number = 2, threshold = 0.1)
#> $municipality_name
#> [1] 217
#> 
#> $string_distance
#> [1] 0
#> 
#> $name
#> [1] "Oppegaard"
```

## Logo

The logo for this package uses a self portrait by famous Norwegian
painter [Nikolai Astrup](https://en.wikipedia.org/wiki/Nikolai_Astrup)
(1880–1928). His name brother, [Nikolai
Astrup](https://en.wikipedia.org/wiki/Nikolai_Astrup_(politician)), was
a minister in the Norwegian Government responsible for merging
municipalities as a part of a large reform in 2020-2021. He is therefore
responsible for increasing the problem of changing municipality
structures over time.
