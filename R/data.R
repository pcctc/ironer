#' Treatment mapping
#'
#' A dataset containing treatment mapping specific to PCCTC studies, intended
#' to be updated regularly. If a mapping needs to be corrected or added,
#' please file an issue or contact PCCTC. Note that this mapping should already
#' be in the `priorrx_derived` and `treatment_derived` tables.
#'
#' @format A data frame with 5 variables:
#' \describe{
#'   \item{treatment_category}{Assigned treatment category}
#'   \item{treatment_recode}{Assigned treatment standardized coding}
#'   \item{treatment}{Treatment as submitted to the study}
#'   \item{treatment_lower}{Treatment as submitted to the study lower case}
#'   \item{is_taxel}{Indicates if treatment is a `taxel` (one of Cabazitaxel, Docetaxel, Paclitaxel, Tesetaxel)}
#'   \item{is_nha}{Indicates if treatment is a novel hormone agent (one of Abiraterone, Enzalutamide, Darolutamide, Apalutamide)}
#' }
#' @examples
#' print(treatment_map)
"treatment_map"




#' Medidata dictionary
#'
#' Data dictionary of clinical data recorded in medidata. Subject to change.
#' The data consists of multiple tables.
#'
#' @format A data frame with 8 variables:
#' \describe{
#'   \item{Table}{Medidata table}
#'   \item{Table description}{Medidata table description}
#'   \item{Variable}{Variable name in medidata table}
#'   \item{Variable label}{If available, a descriptive label for the variable}
#'   \item{R column type}{How the variable is stored in R}
#'   \item{Prompt text}{Prompt text in the electronic data capture}
#' }
#' @examples
#' head(dictionary_medidata)
"dictionary_medidata"

#' PROMS dictionary
#'
#' Data dictionary of Patient Reported Outcomes and Measures (PROMS) self-report survey data. Subject to change.
#'
#' @format A data frame with 8 variables:
#' \describe{
#'   \item{instrument}{Survey instrument}
#'   \item{instrument_description}{Survey instrument description}
#'   \item{variable_type}{Type of survey question (one of multiple choice, select all that apply, write-in, etc.)}
#'   \item{variable}{Variable name that references instrument and question}
#'   \item{label}{Variable label with question text}
#'   \item{values_original}{Reponse values as original programmed}
#'   \item{values_clean}{Response values cleaned with lower case and extra spaces removed}
#'   \item{col_type}{How the variable is stored in R}
#' }
#' @examples
#' head(dictionary_proms)
"dictionary_proms"


