#' Match Municipality Function
#'
#' This function takes a data.table with municipality details and matches a provided municipality name
#' to its corresponding municipality number for a given year, using Jaro-Winkler string matching method.
#' An optional county number can be specified.
#'
#' @param name The name of the municipality.
#' @param year The year (optional). If not provided, the function will match the municipality
#' irrespective of the year.
#' @param county_number The number of the county (optional).
#' @param threshold The minimum difference in string distance between the best and the second best match.
#' @return The number of the municipality that matches the provided name and (if specified) year and
#' county number, as well as the string distance and municipality name in a list.
#' @examples
#' \dontrun{
#' df <- data.table(
#'   municipality_name = c("Municipality1", "Municipality2", "Municipality3"),
#'   municipality_number = c(1001, 1002, 1003),
#'   year_created = c(1900, 1920, 1940),
#'   year_stopped = c(1950, 1980, 2020)
#' )
#'
#' name <- "Municipality1"
#' year <- 1930
#' county_num <- 10
#'
#' match_municipality(df, name, year, county_num)
#' }
#' @export
#' @import data.table
match_municipality <- function(name, year = NULL, county_number_input = NULL, threshold = 0.1) {
  # Import municipality names
  file_path <- system.file("data", "municipality_names.csv", package="NoRwayGeo")
  df <- fread(file_path)

  # Create a new column "county_number"
  df[, county_number := floor(municipality_number / 100)]

  # Compute the string distances
  df[, dist := stringdist::stringdist(df$historiske_navn, name, method = "jw")]

  # Filter based on the provided conditions
  if(!is.null(year) & !is.null(county_number_input)){
    result <- df[dist == min(dist) & year_created <= year & year_stopped >= year & county_number == county_number_input, .(municipality_number, dist, historiske_navn)]
  } else if(!is.null(year)){
    result <- df[dist == min(dist) & year_created <= year & year_stopped >= year, .(municipality_number, dist, historiske_navn)]
  } else if(!is.null(county_number_input)){
    result <- df[dist == min(dist) & county_number == county_number_input, .(municipality_number, dist, historiske_navn)]
  } else {
    result <- df[dist == min(dist), .(municipality_number, dist, historiske_navn)]
  }

  result <- unique(result)

  # Sort the result by string distance and check the second best match
  result <- result[order(dist)]
  if(nrow(result) > 1 && (result$dist[2] - result$dist[1]) < threshold){
    print(paste("The second best match is too close to the best match for", name))
    return(list("municipality_name" = "",
            "string_distance" = "",
            "name" = ""))
  } else if(nrow(result) == 0){
    print(paste("No municipality found for", name, "in the year", year))
    return(list("municipality_name" = "",
            "string_distance" = "",
            "name" = ""))
  } else {
    return(list("municipality_name" = result$municipality_number[1],
                "string_distance" = result$dist,
                "name" = result$historiske_navn))
  }
}
