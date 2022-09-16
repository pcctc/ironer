# PROMS Q-options (question options) -------------------------

library(usethis)
library(readxl)

# file is saved here in ironman repository
# "https://raw.github.com/tgerke/ironman/reference_files/master/TrueNTH%20Questionnaire%20Code%20Dictionary%20-%20IRONMAN_v2.0.xlsx"


# local ironman repository
ironman = "H:/GU/IRONMAN/Code/ironman"

proms_metadata_path = file.path(ironman,
                                "reference_files",
                                "TrueNTH Questionnaire Code Dictionary - IRONMAN_v2.0.xlsx")

# question options exist in odd numbered sheets; read and row bind them
# sheet 13 has erroneously named columns - these are handled separately
proms_q_opts <-
  purrr::map(
    seq(3, 21, by = 2)[-6],
    ~readxl::read_xlsx(proms_metadata_path, sheet = .x)) %>%
  purrr::map_dfr(~.) %>%
  dplyr::bind_rows(
    readxl::read_xlsx(
      proms_metadata_path, sheet = 13) %>%
      dplyr::rename(
        "Option Code" = "Question Code",
        "Option Text" = "Question Text"
      )
  ) %>%
  tidyr::separate(
    "Option Code",
    sep = "[.]",
    into = c("domain", "option", "option_order"),
    remove = FALSE
  ) %>%
  tidyr::unite("option_code", c("domain", "option"), sep = ".")


usethis::use_data(proms_q_opts, overwrite = TRUE)
