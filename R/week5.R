# R Studio API Code
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Data Import
library(tidyverse)
Adata_tbl <- read_delim("../data/Aparticipants.dat", delim = "-", col_names = c("casenum", "parnum", "stimver", "datadate", "qs"))
Anotes_tbl <- read_csv("../data/Anotes.csv")
Bdata_tbl <- read_delim("../data/Bparticipants.dat", delim = "\t", col_names = c("casenum", "parnum", "stimver", "datadate", paste0("q", 1:10)))
Bnotes_tbl <- read_tsv("../data/Bnotes.txt")

# Data Cleaning
library(lubridate)
Adata_tbl <- Adata_tbl %>% 
                separate(qs, into = paste0("q", 1:5)) %>%
                mutate_at(vars(starts_with("q")), .funs = as.numeric) %>%
                mutate(datadate = mdy_hms(datadate))
Aaggr_tbl <- Adata_tbl %>%
                group_by(parnum) %>%
                summarize_at(vars(starts_with("q")), mean)
Baggr_tbl <- Bdata_tbl %>%
                group_by(parnum) %>%
                summarize_at(vars(starts_with("q")), mean)
Aaggr_tbl <- left_join(Aaggr_tbl, Anotes_tbl, by = "parnum")
Baggr_tbl <- left_join(Baggr_tbl, Bnotes_tbl, by = "parnum")
bind_rows(source_A = Aaggr_tbl, source_B = Baggr_tbl, .id = "data_source") %>%
  filter(is.na(notes)) %>%
  group_by(data_source) %>%
  summarize(n())