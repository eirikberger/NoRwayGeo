# Load packages
library(data.table)
library(jsonlite)

# Pull municipal change history directly from SSB's official Klass API.
classification_id <- 131
query_from <- "1838-01-01"
query_to <- format(Sys.Date(), "%Y-%m-%d")
changes_url <- paste0(
  "https://data.ssb.no/api/klass/v1/classifications/",
  classification_id,
  "/changes?from=", query_from,
  "&to=", query_to
)

raw <- tryCatch(
  {
    fromJSON(changes_url)
  },
  error = function(err) {
    stop("Failed to download changes from SSB API: ", conditionMessage(err))
  }
)
changes <- as.data.table(raw$codeChanges)

# Keep the columns used by package functions and discard malformed rows
dta <- changes[
  !is.na(oldCode) & !is.na(newCode) & !is.na(changeOccurred),
  .(
    from = as.integer(oldCode),
    to = as.integer(newCode),
    year = as.integer(substr(changeOccurred, 1, 4)),
    tidligere_kommunenavn = oldName
  )
]

dta <- dta[!is.na(from) & !is.na(to) & !is.na(year)]
dta <- dta[year >= 1838 & year <= as.integer(format(Sys.Date(), "%Y"))]

fwrite(dta, "inst/extdata/historical_municipalities.csv")

if (nrow(dta) == 0L) {
  warning("No rows were written to inst/extdata/historical_municipalities.csv. Check the SSB API response.")
} else {
  message(sprintf(
    "Wrote %d rows covering years %d-%d to inst/extdata/historical_municipalities.csv",
    nrow(dta),
    min(dta$year),
    max(dta$year)
  ))
}
