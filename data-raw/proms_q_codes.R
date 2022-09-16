# PROMS Q-codes (questions) -------------------------

library(usethis)
library(readxl)

# file is saved here in ironman repository
# "https://raw.github.com/tgerke/ironman/reference_files/master/TrueNTH%20Questionnaire%20Code%20Dictionary%20-%20IRONMAN_v2.0.xlsx"


# local ironman repository
ironman = "H:/GU/IRONMAN/Code/ironman"

proms_metadata_path = file.path(ironman,
                                "reference_files",
                                "TrueNTH Questionnaire Code Dictionary - IRONMAN_v2.0.xlsx")

# question codes exist in the even numbered sheets; read and row bind them
proms_q_codes <-
  purrr::map(
    seq(2, 20, by = 2),
    ~readxl::read_xlsx(proms_metadata_path, sheet = .x)
  ) %>%
  purrr::map_dfr(~.) %>%
  dplyr::rename(
    "question_code" = "Question Code",
    "question_text" = "Question Text"
  )


usethis::use_data(proms_q_codes, overwrite = TRUE)
