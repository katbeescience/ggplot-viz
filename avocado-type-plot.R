# This script makes a barplot of avocado types sold in the U.S.
# Kathryn Busby
# mkbusby@email.arizona.edu
# May 25, 2020

# Install packages and load libraries.
# install.packages("tidyverse")
# install.packages("ggplot2")
# install.packages("magick")

library(tidyverse)
library(ggplot2)
library(magick)

# Load data.

avocado <- read.csv(file="avocado.csv")

# Clean up data a bit for plotting.

phoenix <- avocado %>%
  filter(region=="PhoenixTucson") %>%
  select(Date, "hass.small" = 'X4046',
         "hass.large" = 'X4225',
         "hass.x.large" = 'X4770') %>%
  pivot_longer(cols = -Date, names_to = "PLU", values_to = "Amount")

# Read in some image files to stick in the plot.

X4046 <- image_read("4046.png")
X4225 <- image_read("4225.png")
X4770 <- image_read("4770.png")

# Make the images into grobs.

gX4046 <- rasterGrob(X4046, interpolate=TRUE)
gX4225 <- rasterGrob(X4225, interpolate=TRUE)
gX4770 <- rasterGrob(X4770, interpolate=TRUE)

# Make the plot.

avo.plot.o <- ggplot(data=phoenix, mapping=aes(x=PLU, y=Amount, fill=PLU)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("darkorange4", "darkolivegreen3", "darkgreen")) +
  guides(fill=FALSE) +
  labs(title="Quantity of Avocado Types Sold in Phoenix and Tucson",
       y="Quantity Sold") +
  scale_x_discrete(labels=c("X4046 (Small Hass)",
                            "X4225 (Large Hass)",
                            "X4770 (Extra Large Hass)")) +
  annotation_custom(grob=gX4046, xmin=.25, xmax=1.75, ymin=5, ymax=3.0e+07) +
  annotation_custom(grob=gX4225, xmin=1.25, xmax=2.75, ymin=5, ymax=3.0e+07) +
  annotation_custom(grob=gX4770, xmin=2.25, xmax=3.75, ymin=5, ymax=3.0e+07) +
  theme_classic()

# Now save the pretty plot as a file:

ggsave(plot = avo.plot.o,
       filename="avocado-type-plot.png",
       width=6, height=6, units="in")
