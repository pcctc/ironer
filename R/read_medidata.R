#' Read all .sas7bdat IRONMAN files from a directory
#'
#' Data exports (e.g. from Medidata) are most often provided
#' as a directory with many .sas7bdat files. This is a
#' convenience function to read all such files in a given
#' directory and return as a named list of tibbles.
#'
#' @param path A directory path typically created with fs::path()
#' or here::here() which contains the .sas7dbat files to read.
#' @param clean If TRUE (default), use janitor::clean_names() to
#' clean column names.
#' @param skip A character string, when detected in the file name,
#' that will cause matching files not to be read.
#'
#' @return A named list of tibbles, where the names correspond to
#' the name of the sas7bdat source file for each list element.
#' @export
#'
#' @examples
#' \dontrun{
#' medidata <- read_medidata(
#'   fs::path(
#'     "~/Documents/gh-repos-mskcc/c16-170-ironman/data",
#'     "20210601/c16_170_IRONMAN_731_20210601_171659"
#'   ),
#'   skip = "y|m|r|o|g|p|c" #reads only 9 of the files
#' )
#'
#' # view 3 columns from each tibble
#' medidata %>%
#'   purrr::map(~ .x %>% dplyr::select(project, site, instance_name))
#'   }
read_medidata <- function(path, clean = TRUE, skip = "_raw") {
  files <- dir(path, pattern = "*.sas7bdat")

  # skip reading selected files
  files <- files[!grepl(skip, files)]

  if (clean == TRUE) {
    sas_data <- file.path(path, files) %>%
      rlang::set_names(
        stringr::str_replace(files, ".sas7bdat", "")
      ) %>%
      purrr::map(~ haven::read_sas(.x) %>% janitor::clean_names())
  }
  else {
    sas_data <- file.path(path, files) %>%
      rlang::set_names(
        stringr::str_replace(files, ".sas7bdat", "")
      ) %>%
      purrr::map(~ haven::read_sas(.x))
  }

  return(sas_data)
}
