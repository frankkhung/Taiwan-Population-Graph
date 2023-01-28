library(magick)
library(MetBrewer)
library(colorspace)
library(ggplot2)
library(glue)
library(stringr)



colors <- met.brewer("OKeeffe2")
swatchplot(colors)

text_color <- darken(colors[7], .25)
swatchplot(text_color)

annot <- glue("This map shows population density of Taiwan ",
              "Population estimates are bucketed into 400 meter (about 1/4 mile) ",
              "hexagons.") |> 
  str_wrap(50)


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
  image_annotate("Matsu Islands",
                 gravity = "north",
                 location = "+0+400",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Taipei/New Taipei",
                 gravity = "north",
                 location = "+650+600",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Taoyuan",
                 gravity = "north",
                 location = "+650+850",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Yilan",
                 gravity = "north",
                 location = "+1350+1200",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Hsinchu",
                 gravity = "north",
                 location = "+350+1050",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Taichung",
                 gravity = "north",
                 location = "+40+1400",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Kinmen",
                 gravity = "west",
                 location = "+450+0",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Tainan",
                 gravity = "north",
                 location = "-250+1800",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Penghu",
                 gravity = "north",
                 location = "-750+1850",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Kaohsiung",
                 gravity = "north",
                 location = "-250+2300",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Green Island",
                 gravity = "north",
                 location = "+1100+2350",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
  image_annotate("Lanyu",
                 gravity = "north",
                 location = "+1100+2650",
                 color = text_color,
                 size = 40,
                 font = "PT Serif Caption") |> 
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
  image_write("images/titled_final_plot.png")
