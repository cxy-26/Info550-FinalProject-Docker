# plots

here::i_am("code/plots.R")

newdata <- readRDS(
  here::here("output/newdata.rds")
)

require(ggplot2)
p <- ggplot(data = newdata, aes(x = fudays/365.25, y = NACCMMSE, group = NACCID))
plot1 <- p + geom_line()  + 
  facet_grid(. ~ AF) + 
  ylab("MMSE Score")

ggsave(
  here::here("output/plot1.png"),
  plot1,
  device = "png"
)

p <- ggplot(data = newdata, aes(x = fudays/365.25, y = MOCATOTS, group = NACCID))
plot2 <- p + geom_line()  + 
  facet_grid(. ~ AF) +  
  ylab("MoCA Score")

ggsave(
  here::here("output/plot2.png"),
  plot1,
  device = "png"
)

