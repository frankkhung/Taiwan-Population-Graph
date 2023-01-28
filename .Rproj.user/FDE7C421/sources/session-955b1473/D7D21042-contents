# read gpkg in
library(sf)
library(tidyverse)
library(stars)
library(rayshader)
library(MetBrewer)
library(colorspace)
library(rayrender)

#load the kontur data 
data <- st_read("data/kontur_population_TW_20220630.gpkg")

#load taiwan data
taiwan_data <- read_sf("data/gadm36_TWN_shp/gadm36_TWN_2.shp")


taipei <- taiwan_data %>% 
  st_transform(crs = st_crs(data))

taipei_pop <- st_intersection(taipei, data)
taipei_pop <- taipei_pop %>% select(NAME_2, population, geometry)

taipei_pop |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = bottom_left) +
  geom_sf(data = bottom_right, color = "red")

# translate into a matrix format

bb <- st_bbox(taipei_pop)

bottom_left <- st_point(c(bb[["xmin"]], bb[["ymin"]])) %>%
  st_sfc(crs = st_crs(data))

bottom_right <- st_point(c(bb[["xmax"]], bb[["ymin"]])) %>%
  st_sfc(crs = st_crs(data))

width <- st_distance(bottom_left, bottom_right)

top_left <- st_point(c(bb[["xmin"]], bb[["ymax"]])) %>%
  st_sfc(crs = st_crs(data))

height <- st_distance(bottom_left, top_left)

# handle conditions of width or height being the longer side
if (width > height) {
  w_ratio <- 1
  h_ratio <- height/width
} else {
  h_ratio <- 1
  w_ratio <- width/height
}

# convert to raster so we can convert to matrix

size <- 1000
taipei_rast <- st_rasterize(taipei_pop, 
                            nx = floor(size * 0.866),
                            ny = floor(size * 1))
mat <- matrix(taipei_rast$population,
              nrow = floor(size * 0.866),
              ncol = floor(size * 1))

# create color palette

c1 <- met.brewer("Nattier")
swatchplot(c1)

texture <- grDevices::colorRampPalette(c1, bias = 2)(256)
swatchplot(texture)

# plot that 3d thing!

rgl::rgl.close()

mat |> 
  height_shade(texture = texture) |> 
  plot_3d(heightmap = mat,
          zscale = 200,
          solid = FALSE,
          shadowdepth = 1)
render_camera(theta = 0, phi = 40, zoom = 0.8, shift_vertical = -20)

outfile <- "images/final_plot.png"

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



