library(tidyverse)

g <- mtcars %>% ggplot(mapping = aes(x=mpg, y=gear)) + geom_point()
ggsave(g, filename = "testplot.png", device = "png")
