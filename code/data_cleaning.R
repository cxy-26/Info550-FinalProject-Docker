
# load data

here::i_am("code/data_cleaning.R")

data <- read.csv(here::here("data/NACC_AF_Data_Long.csv"))


data$AF <- factor(data$AF, levels=c(0,1), labels=c("No","Yes"))

library(dplyr)

baseline = data[data$visit==1,] %>% 
  mutate(
    edulv = ifelse(EDUC %in% c(0:12),1, ifelse(EDUC %in% c(13:16),2, ifelse(EDUC >= 17 & EDUC < 99, 3, NA))),
    race = ifelse(NACCNINR %in% c(3,4,5,6,99,-4), 3, NACCNINR),
    marriage = ifelse(MARISTAT %in% c(1, 6), 1, 0),
    BMI = ifelse(NACCBMI %in% c(888.8, -4), NA, NACCBMI), 
    STROKE = ifelse(CBSTROKE %in% c(1,2) | STROKE == 1 | HXSTROKE==2, 1, 
                    ifelse(CBSTROKE %in% c(-4,9) & STROKE==-4 &HXSTROKE==-4, NA, 0))
  ) %>% 
  mutate(
    SEX = factor(SEX,level = c(2,1),labels=c("Female","Male")),
    race = factor(race,level = c(1,2,3),labels=c("White","Black","Others")),
    edulv = factor(edulv, level = c(1,2,3), labels=c("Highschool","Bachelor","Advanced")),
    marriage = factor(marriage, level = c(0,1), labels = c("others","married")),
    STROKE = factor(STROKE, level = c(0,1), labels = c( "No STROKE","STROKE")),
  )

saveRDS(
  baseline,
  here::here("output/baseline.rds")
)

newdata <- data[ which(data$n>=4), ] %>% select(c("NACCID", "AF", "fudays", "NACCMMSE", "MOCATOTS"))

saveRDS(
  newdata,
  here::here("output/newdata.rds")
)