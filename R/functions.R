#' Print change in municipality structure in Norway between `from_year` and `to_year`.
#'
#' @param from_year years equal to or above.
#' @param to_year years lower or equal to.
#' @return A data frame/data.table listing results.
#' @examples
#' print_changes(1980, 2000)
#'
#' @export
print_changes <- function(from_year, to_year) {
  loadNamespace('data.table')

  file_path <- system.file("data", "historical_municipalities.csv", package="NoRwayGeo")
  dta <- fread(file_path)
  d <- dta[year>=from_year & year<=to_year][,.(from, to, year, tidligere_kommunenavn)]
  return(d)
}



#' Print clusters of municipalities in Norway between `from_year` and `to_year`. Municipalities that remains unchanged, not merged or split, are not listed.
#'
#' @param from_year years equal to or above.
#' @param to_year years lower or equal to.
#' @return A data frame/data.table listing municipality numbers with corresponding cluster ids.
#' @examples
#' print_clusters(1980, 2000)
#'
#' @export
print_clusters <- function(from_year, to_year) {
  loadNamespace('data.table')

  # Import data
  file_path <- system.file("data", "historical_municipalities.csv", package="NoRwayGeo")
  dta <- fread(file_path)
  d <- dta[year>=from_year & year<=to_year][,.(from, to, tidligere_kommunenavn)]

  # Graph
  g <- igraph::graph_from_data_frame(d, directed=FALSE, vertices = NULL)

  # Get unique groups
  muni_groups <- igraph::components(g, mode = c("strong"))

  t <- setDT(as.data.frame(muni_groups$membership), keep.rownames='muni_number')
  setnames(t, 'muni_groups$membership', 'cluster')
  print(t)
}



#' Graph clusters of municipality changes in Norway between `from_year` and `to_year`. Municipalities that remains unchanged, not merged or split, are not listed.
#'
#' @param from_year years equal to or above.
#' @param to_year years lower or equal to.
#' @return A plot illustrating clusters for the defined period.
#' @examples
#' graph_clusters(1980, 2000)
#'
#' @export
graph_clusters <- function(from_year, to_year) {
  loadNamespace('data.table')

  # Import data
  file_path <- system.file("data", "historical_municipalities.csv", package="NoRwayGeo")
  dta <- fread(file_path)
  d <- dta[year>=from_year & year<=to_year][,.(from, to, tidligere_kommunenavn)]

  # Graph
  g <- igraph::graph_from_data_frame(d, directed=FALSE, vertices = NULL)
  plot(g, vertex.label=d$tidligere_kommunenavn, main=paste0('Municipality changes between ', from_year, ' and ', to_year))
}



#' Counts numbers of clusters in the defined period.
#'
#' @param from_year years equal to or above.
#' @param to_year years lower or equal to.
#' @return The number of clusters in the defined period.
#' @examples
#' count_clusters(1980, 2000)
#'
#' @export
count_clusters <- function(from_year, to_year) {
  loadNamespace('data.table')

  # Import data
  file_path <- system.file("data", "historical_municipalities.csv", package="NoRwayGeo")
  dta <- fread(file_path)
  d <- dta[year>=from_year & year<=to_year][,.(from, to, tidligere_kommunenavn)]

  # Graph
  g <- igraph::graph_from_data_frame(d, directed=FALSE, vertices = NULL)

  # Get unique groups
  muni_groups <- igraph::components(g, mode = c("strong"))

  return(muni_groups$no)
}
