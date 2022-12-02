# Tables

here::i_am("code/tables.R")

library(table1)
library(dplyr)

#Function written for p-value
pvalue <- function(x, ...) { 
  x <- x[-length(x)]  # Remove "overall" group
  # Construct vectors of data y, and groups (strata) g
  y <- unlist(x)
  g <- factor(rep(1:length(x), times=sapply(x, length)))
  if (is.numeric(y)) {
    # For numeric variables, perform an ANOVA
    p <- summary(aov(y ~ g))[[1]][["Pr(>F)"]][1]
  } else {
    # For categorical variables, perform a chi-squared test of independence
    p <- chisq.test(table(y, g), simulate.p.value = TRUE)$p.value
  }
  # Format the p-value, using an HTML entity for the less-than sign.
  # The initial empty string places the output on the line below the variable label.
  c("", sub("<", "&lt;", format.pval(p, digits=3, eps=0.001)))
}

baseline <- readRDS(here::here("output/baseline.rds"))

# label variables
library(Hmisc)
label(baseline$SEX) <- "Gender"
label(baseline$NACCAGE) <- "Age"
label(baseline$edulv) <- "Education Level"
label(baseline$marriage) <- "Marriage Status"
label(baseline$race) <- "Race"

table1 <- table1::table1(~ SEX + NACCAGE + edulv + marriage + STROKE + BMI | AF, 
               data=baseline, extra.col=list(`P-value`=pvalue))

saveRDS(
  table1,
  here::here("output/table1.rds"))


data <- read.csv(here::here("data/NACC_AF_Data_Long.csv"))

first.stage = data %>% dplyr::filter (visit == 1 & n > 1 ) %>% select(NACCID, AF, NACCUDSD)
last.stage  = data %>% dplyr::filter (visit == n & n > 1 ) %>% select(NACCID, NACCUDSD, fudays)
first.last.stage = merge(first.stage, last.stage, by="NACCID", suffixes = c(".first",".last"), sort=TRUE) 
first.last.stage.table = round(100*table(first.last.stage[,c(3,4)])/sum(table(first.last.stage[,c(3,4)])),1)

saveRDS(
  first.last.stage.table,
  here::here("output/first.last.stage.table.rds")
)

first.stage = data %>% dplyr::filter (AF == "Yes" & visit == 1 & n > 1 ) %>% select(NACCID, AF, NACCUDSD)
last.stage  = data %>% dplyr::filter (AF == "Yes" & visit == n & n > 1 ) %>% select(NACCID, NACCUDSD, fudays)
first.last.stage = merge(first.stage, last.stage, by="NACCID", suffixes = c(".first",".last"), sort=TRUE) 
first.last.stage.table.af = round(100*table(first.last.stage[,c(3,4)])/sum(table(first.last.stage[,c(3,4)])),1)

saveRDS(
  first.last.stage.table,
  here::here("output/first.last.stage.table.af.rds")
)

first.stage = data %>% dplyr::filter (AF == "No" & visit == 1 & n > 1 ) %>% select(NACCID, AF, NACCUDSD)
last.stage  = data %>% dplyr::filter (AF == "No" & visit == n & n > 1 ) %>% select(NACCID, NACCUDSD, fudays)
first.last.stage = merge(first.stage, last.stage, by="NACCID", suffixes = c(".first",".last"), sort=TRUE) 
first.last.stage.table.noaf = round(100*table(first.last.stage[,c(3,4)])/sum(table(first.last.stage[,c(3,4)])),1)

saveRDS(
  first.last.stage.table,
  here::here("output/first.last.stage.table.noaf.rds")
)