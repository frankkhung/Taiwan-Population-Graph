# Load required libraries
library(magick)
library(MetBrewer)
library(colorspace)
library(ggplot2)
library(glue)
library(stringr)

# Define color palette using MetBrewer's "OKeeffe2"
colors <- met.brewer("OKeeffe2")
swatchplot(colors)

# Darken the seventh color in the palette by 25%
text_color <- darken(colors[7], .25)
swatchplot(text_color)

# Define annotation text and wrap it to fit within a width of 50 characters
annot <- glue("This map shows population density of Taiwan ",
              "Population estimates are bucketed into 400 meter (about 1/4 mile) ",
              "hexagons.") |> 
  str_wrap(50)

# Perform image operations on "img" (assuming "img" is previously defined)
#   1. Crop image to specified dimensions (4000x3000) and offset (+700-200)
#   2. Add multiple annotations on the image at specific locations
#      The annotations include the title, details about the map, locations in Taiwan, credits, and data source
#   3. Save the final image as a PNG file
img |> 
  image_crop(gravity = "center",
             geometry = "4000x3000+700-200") |> 
  image_annotate("Taiwan Population Density",
                 gravity = "northwest",
                 location = "+200+100",
                 color = text_color,
                 size = 150,
                 weight = 600,
                 font = "PT Serif Caption") |> 
  image_annotate(annot,
                 gravity = "southwest",
                 location = "+200+100",
                 color = text_color,
                 size = 70,
                 weight = 50,
                 font = "PT Serif Caption") |> 
  # Annotations for various locations across Taiwan
  image_annotate("Matsu Islands",
                 # Rest of the annotations...
                 image_annotate("Graphic by Frank Hung (@frankkhung)",
                                gravity = "southeast",
                                location = "+50+100",
                                font = "PT Serif Caption",
                                color = alpha(text_color, .5),
                                size = 30) |> 
                   image_annotate("Kontour Population Data (Released June 30, 2022)",
                                  gravity = "southeast",
                                  location = "+50+50",
                                  font = "PT Serif Caption",
                                  color = alpha(text_color, .5),
                                  size = 30) |> 
                   image_write("images/titled_final_plot.png"))