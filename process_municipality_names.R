pacman::p_load(data.table, readxl, stringr, janitor, zoo)

###

# Source: https://no.wikipedia.org/wiki/Norske_kommunenummer

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
setnames(dta, "opprettet", "year_created")

###

# Source: https://no.wikipedia.org/wiki/Liste_over_tidligere_norske_kommuner
tmp <- setDT(read_excel("inst/data/tidligere_kommuner.xlsx"))
tmp <- clean_names(tmp)

tmp <- tmp[str_detect(nr, "[0-9]{3,4}")][, nr := as.integer(nr)]
tmp <- tmp[str_detect(fra, "[0-9]{3,4}")][, fra := as.integer(fra)]
tmp <- tmp[str_detect(til, "[0-9]{3,4}")][, til := as.integer(til)]

tmp <- tmp[,.(nr, fra, til)]

setnames(tmp, "fra", "year_created")
setnames(tmp, "til", "year_stopped")

# removing year_created because the first source is more complete
tmp[, year_created := NULL]

###

dta <- merge(dta, tmp, by = c("nr"), all = TRUE)

# If no stop year, then set 9999
dta <- dta[is.na(year_stopped), year_stopped := 9999]

###

setnames(dta, "nr", "municipality_number")
fwrite(dta, "inst/data/municipality_names.csv")

