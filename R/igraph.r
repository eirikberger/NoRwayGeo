# Load packages
library(igraph)
library(data.table)
library(readxl)
library(janitor)
library(stringr)

# Inputs
FROM <- 1992
TO <- 1992

# Import data
dta <- setDT(read_excel("inst/data/kommuneendringer_1838_2017.xlsx"))
dta <- clean_names(dta)

# # NB!!
# # There are some duplicates in the imported data
# dta[,test:=.N, by=c(colnames(dta))][test>1,.(endringstidspunkt, tidligere_kommuneenhet, ny_kommuneenhet)]
#
# endringstidspunkt tidligere_kommuneenhet ny_kommuneenhet
# 1:              1838            0680 Strømm    0711 Svelvik
# 2:              1838            0680 Strømm    0711 Svelvik
# 3:              1863          1941 Skjervøy   1941 Skjervøy
# 4:              1863          1941 Skjervøy   1941 Skjervøy
# 5:              1858             2003 Vadsø      2003 Vadsø
# 6:              1858             2003 Vadsø      2003 Vadsø

# There is at least one error in the input data
# This regards '0120 Rødenes' in 1902, where municipality
# number is both 0130 and 0120.


dta <- dta[,count_from:=.N, by=c('endringstidspunkt', 'tidligere_kommunenr')]
dta <- dta[,count_to:=.N, by=c('endringstidspunkt', 'nytt_kommunenr')]

dta <- dta[count_from==1 & count_to>1,type:='merge']
dta <- dta[count_from>1 & count_to==1,type:='split']
dta <- dta[count_from>1 & count_to>1,type:='split & merge']
dta <- dta[count_from==1 & count_to==1,type:='rename']

###

# Edit data
setnames(dta, 'x8', 'beskrivelse')

dta <- dta[,from:=tidligere_kommunenr]
dta <- dta[,to:=nytt_kommunenr]
dta <- dta[,year:=str_match(endringstidspunkt, '[0-9]{4}')]

d <- dta[year>=FROM & year<=TO][,.(from,to, tidligere_kommunenavn)]

# Graph
g <- graph_from_data_frame(d, directed=FALSE, vertices = NULL)

print(g, e=TRUE, v=TRUE)
plot(g, vertex.label=d$tidligere_kommunenavn, main=paste0('Municipality changes between ', FROM, ' and ', TO))

# Get unique groups
muni_groups <- components(g, mode = c("strong"))
print(paste('Number of clusters:', muni_groups$no))

t <- setDT(as.data.frame(muni_groups$membership), keep.rownames='muni_number')
setnames(t, 'muni_groups$membership', 'cluster')

###
