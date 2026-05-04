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
#' @return A list with `municipality_name`, `string_distance`, and matched historical name.
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
match_municipality <- function(name, year = NULL, county_number = NULL, threshold = 0.1) {
  # Import municipality names
  file_path <- system.file("extdata", "municipality_names.csv", package="NoRwayGeo")
  df <- fread(file_path)

  # Create a new column "county_number"
  df[, county_number := floor(municipality_number / 100)]

  # Normalize query and candidate names for robust historical-name matching
  normalize_name <- function(x) {
    x <- tolower(x)
    x <- iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT", sub = "")
    x <- gsub("[^a-z0-9 ]", " ", x, perl = TRUE)
    x <- gsub("\\s+", " ", x, perl = TRUE)
    trimws(x)
  }

  df[, historiske_navn_normalized := normalize_name(historiske_navn)]
  name <- normalize_name(name)

  # Apply constraints before fuzzy matching to avoid selecting an off-scope nearest neighbor
  if (!is.null(year)) {
    df <- df[year_created <= year & year_stopped >= year]
  }
  if (!is.null(county_number)) {
    df <- df[county_number == county_number]
  }

  if (nrow(df) == 0L) {
    print(paste("No municipality found for", name))
    return(list("municipality_name" = "",
            "string_distance" = "",
            "name" = ""))
  }

  # Compute the string distances in the constrained set
  df[, dist := stringdist::stringdist(historiske_navn_normalized, name, method = "jw")]
  result <- df[order(dist, historiske_navn), list(municipality_number = municipality_number, dist = dist, historiske_navn = historiske_navn)]
  result <- unique(result, by = "municipality_number")

  if (nrow(result) == 0L) {
    print(paste("No municipality found for", name))
    return(list("municipality_name" = "",
            "string_distance" = "",
            "name" = ""))
  }

  # Check tie distance among best matches
  if (nrow(result) > 1 && (result$dist[2] - result$dist[1]) < threshold) {
    print(paste("The second best match is too close to the best match for", name))
    return(list("municipality_name" = "",
            "string_distance" = "",
            "name" = ""))
  } else {
    return(list("municipality_name" = result$municipality_number[1],
                "string_distance" = result$dist[1],
                "name" = result$historiske_navn))
  }
}
