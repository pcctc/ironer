library(tidyverse)
library(pcctc)

data_cut <- "2025-02-24"
lst_blind_medidata <- readRDS(
  file =fs::path(pcctc::path_llc_projects(),
                 "c16-170_IRONMAN Registry_MSKDukeHSPH",
                 "Data Science",
                 "derived-data",
                 glue::glue("{data_cut}"),
                 "df_blinded_data.RDS")
  )



usethis::use_data(lst_blind_medidata, overwrite = TRUE)
