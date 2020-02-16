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
