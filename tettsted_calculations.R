################################################################################
# This r-script retrives the municipality of the centroide of the largest
# polygon of each "tettsted" in Norway based on map data from a particular year.
# The "tettsted" data is from 2016.

# "Tettsted" data: https://kartkatalog.geonorge.no/metadata/tettsteder-2016/b4135456-43af-43fa-8111-7652b7c53b19
# Map data: From NSD/SIKT.

################################################################################

pacman::p_load("rgdal", "sf", "data.table", "dplyr", "here")
setwd(here::here("tettsted"))

################################################################################
# Read GML data
gml_data <- st_read("tettsteder_2016.gml", stringsAsFactors = FALSE,  layer = "Tettsted")

# gml_layers <- st_layers("tettsteder_2016.gml")
# print(gml_layers)

# Convert to data.table
gml_data_dt <- as.data.table(gml_data)
setnames(gml_data_dt, "område", "geometry")

# Calculate the area of each polygon
gml_data_dt[, area := as.numeric(st_area(geometry))]

# Keep only the largest polygon in each group
gml_data_dt <- gml_data_dt[, .SD[which.max(area)], by = c("tettstednummer", "tettstednavn")]

# Convert back to sf object
gml_data <- st_as_sf(gml_data_dt)

# Convert polygons in GML data to their centroids (center points)
gml_data <- st_centroid(gml_data)

# Read Shapefile data
shp_data <- st_read("kommuner_1951-1954.shp", stringsAsFactors = FALSE)

# Reproject GML data to the CRS of the Shapefile data
gml_data <- st_transform(gml_data, st_crs(shp_data))

# Perform a spatial join
joined_data <- st_join(gml_data, shp_data)

# Convert to data.table
joined_dt <- as.data.table(joined_data)

joined_dt <- joined_dt[,.(tettstednummer, tettstednavn, KNR, FNR, KOMMNR, KNAVN)]
joined_dt <- joined_dt[!is.na(KNR)]
joined_dt <- unique(joined_dt)

fwrite(joined_dt, "joined_points.csv")

################################################################################

# ###
# # It the projections correct? --> Now, yes...
# ###
#
# # Plot the Shapefile data (municipalities)
# plot(st_geometry(shp_data), col = "lightblue", border = "darkblue")
#
# # Add the GML data (points) on top
# plot(st_geometry(gml_data), add = TRUE, col = "red", pch = 20)
#
# st_crs(shp_data)
# st_crs(gml_data)
