# This script makes a pretty plot of avocado sales by time of year.
# Kathryn Busby
# mkbusby@email.arizona.edu
# May 25, 2020

# Install packages:

# install.packages("ggplot2")
# install.packages("lubridate")
# install.packages("dplyr")
# install.packages("grid")
# install.packages("png")

library(ggplot2)
library(lubridate)
library(dplyr)
library(grid)
library(png)

# Load in the data:

avocado <- read.csv(file="avocado.csv")

# To look at the features of this dataset, type the following in your console.

head(avocado)
summary(avocado)
class(avocado$Date)

# Make your own hypothesis. When do you suspect most avocados are sold?

# Clean up the data a bit:

tidy.avocado <- avocado %>%
  filter(region == "TotalUS", type=="conventional") %>%
  mutate(Date = as.Date(Date, format = "%m/%d/%y"))

# Let's choose some custom avocado colors!

avo.colors <- c("darkgreen", "darkkhaki", "darkgoldenrod4", "darkolivegreen3")

# Let's add an icon!

# Read the icon in from the .png file, using readPNG.
# Then it needs to get converted to a graphics object, or 'grob'.

img=readPNG("avo-icon.png")
g=rasterGrob(img, interpolate=TRUE)

# Now make the plot:

ggplot(data=tidy.avocado, mapping=aes(x=week(Date),
                                      y=Total.Volume,
                                      group=year, color=as.factor(year))) +
  geom_line() +
  scale_color_manual(values=avo.colors) +
  labs(y="Total Volume", x="Week", color="Year",
       title="Volume of Avocados Purchased Each Week in the U.S. in 2015, 2016, 2017, and 2018") +
  scale_x_continuous(name="Week",
                     limits=c(0,52),
                     breaks=seq(0,52,2),
                     expand=c(0,0)) +
  annotation_custom(grob=g, xmin=35, xmax=45, ymin=4.5e+07, ymax=6e+07) +
  theme_classic()

# Beautiful! Now make it automatically save in your folder.

ggsave(filename="avocado-volume-plot.png",
       width=12, height=6, units="in")

