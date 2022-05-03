######################################
# Make package
######################################

# Load the basics
library(devtools)
library(roxygen2)

# From the folder where the package will be places
create('NoRwayGeo')
use_mit_license()

######################################
# Make icon
######################################
#install.packages("devtools")
#devtools::install_github("GuangchuangYu/ggimage")
#devtools::install_github("GuangchuangYu/hexSticker")

imgpath <- system.file("images", "Nikolai_Astrup.jpg", package="NoRwayGeo")

hexSticker::sticker(imgpath, package="NoRwayGeo", p_size=20, s_width=1.2,
        white_around_sticker = TRUE, p_color='#BA0C2F', h_color = '#00205B',
        s_y=0.5, p_y=0.7,
        filename="logo.png")

######################################
# Cleanup
######################################
usethis::use_tidy_description()
