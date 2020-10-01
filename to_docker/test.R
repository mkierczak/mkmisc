library(tidyverse)

mtcars %>% ggplot(mapping = aes(x=mpg, y=gear)) + geom_point()
