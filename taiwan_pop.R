# Load necessary packages
library(sf)
library(tidyverse)
library(stars)
library(rayshader)
library(MetBrewer)
library(colorspace)
library(rayrender)

# Read in population data from a geopackage (gpkg)
# Source: https://www.kontur.io/portfolio/population-dataset/
data <- st_read("data/kontur_population_TW_20220630.gpkg")

# Load the map data for Taiwan
# Source: https://gadm.org/download_country_v3.html
taiwan_data <- read_sf("data/gadm36_TWN_shp/gadm36_TWN_2.shp")

# Transform the Taiwan data to match the coordinate reference system of the population data
taipei <- taiwan_data %>% 
  st_transform(crs = st_crs(data))

# Create a new dataset containing only the intersection of the population and Taiwan map data
# Only keep relevant columns (NAME_2, population, geometry)
taipei_pop <- st_intersection(taipei, data)
taipei_pop <- taipei_pop %>% select(NAME_2, population, geometry)

# Plot the intersection data
taipei_pop |> 
  ggplot() +
  geom_sf()

# Define the bounding box (extent) of the intersection data
bb <- st_bbox(taipei_pop)

# Define the bottom-left and bottom-right points of the bounding box
bottom_left <- st_point(c(bb[["xmin"]], bb[["ymin"]])) %>%
  st_sfc(crs = st_crs(data))

bottom_right <- st_point(c(bb[["xmax"]], bb[["ymin"]])) %>%
  st_sfc(crs = st_crs(data))

# Calculate the width of the bounding box
width <- st_distance(bottom_left, bottom_right)

# Define the top-left point of the bounding box and calculate its height
top_left <- st_point(c(bb[["xmin"]], bb[["ymax"]])) %>%
  st_sfc(crs = st_crs(data))

height <- st_distance(bottom_left, top_left)

# Calculate the aspect ratio of the bounding box
if (width > height) {
  w_ratio <- 1
  h_ratio <- height/width
} else {
  h_ratio <- 1
  w_ratio <- width/height
}

# Convert the intersection data to raster format to create a matrix of the population data
size <- 1000
taipei_rast <- st_rasterize(taipei_pop, 
                            nx = floor(size * 0.866),
                            ny = floor(size * 1))
mat <- matrix(taipei_rast$population,
              nrow = floor(size * 0.866),
              ncol = floor(size * 1))

# Create a color palette
c1 <- met.brewer("Nattier")

# Create a texture using the color palette
texture <- grDevices::colorRampPalette(c1, bias = 2)(256)

# Close any open rgl devices
rgl::rgl.close()

# Plot a 3D map of the population data, using the color palette to represent population density
mat |> 
  height_shade(texture = texture) |> 
  plot_3d(heightmap = mat,
          zscale = 200,
          solid = FALSE,
          shadowdepth = 1)
render_camera(theta = 0, phi = 40, zoom = 0.8, shift_vertical = -20)

# Define the output file path
outfile <- "images/final_plot.png"

# Render the 3D plot in high quality and save it as a PNG file
{
  start_time <- Sys.time()
  cat(crayon::cyan(start_time), "\n")
  render_highquality(
    filename = outfile,
    interactive = FALSE,
    lightdirection = 280,
    lightaltitude = c(20, 80),
    lightcolor = c(c1[2], "white"),
    lightintensity = c(600, 100),
    samples = 450,
    width = 6000,
    height = 6000
  )
  end_time <- Sys.time()
  diff <- end_time - start_time
  cat(crayon::cyan(diff), "\n")
}


