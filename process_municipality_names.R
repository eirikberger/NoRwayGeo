pacman::p_load(data.table, readxl, stringr, janitor, zoo)

###

dta <- setDT(read_excel("inst/data/komnr.xlsx"))
dta <- clean_names(dta)
dta <- dta[,.(nr, navn, historiske_navn, opprettet)]

dta <- dta[, nr := na.locf(nr, na.rm = FALSE)]
dta <- dta[, navn := na.locf(navn, na.rm = FALSE)]
dta <- dta[, historiske_navn := na.locf(historiske_navn, na.rm = FALSE)]
dta <- dta[, opprettet := na.locf(opprettet, na.rm = FALSE)]
dta <- dta[!is.na(nr)]

dta <- dta[str_detect(nr, "^[0-9]{3,4}")][, nr := as.integer(str_match(nr,  "^[0-9]{3,4}"))]
dta <- dta[, opprettet := as.integer(str_match(opprettet,  "[0-9]{3,4}"))]
dta <- dta[, navn := str_remove(navn,  "[★*#]")]
dta <- dta[, historiske_navn := str_remove(historiske_navn,  "[★*#]")]

dta <- dta[, historisk_detaljer := str_match(historiske_navn,  "(.*)\\s\\((.*?)\\)$")[,3]]
dta <- dta[, historiske_navn := str_match(historiske_navn,  "(.*)\\s\\((.*?)\\)$")[,2]]

tmp <- copy(dta)[, historiske_navn := navn]
dta <- rbind(dta, tmp)
rm(tmp)

dta <- unique(dta)
dta <- dta[!is.na(historiske_navn)]

###

# changes <- fread("inst/data/historical_municipalities.csv")
# tmp1 <- changes[,.(.N), by = c("from", "year", "tidligere_kommunenavn")]
# tmp2 <- changes[, .(year = min(year)), by = to]

### Infer start and stop for municipalities and merge in ###

###

dta <- dta[, year_stopped := 2020]
setnames(dta, "nr", "municipality_number")
setnames(dta, "opprettet", "year_created")
fwrite(dta, "inst/data/municipality_names.csv")

