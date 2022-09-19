#' Site to Country mapping
#'
#' A data set of all PCCTC site IDs mapping from treatment site to country.
#' Not all IDs apply to Ironman.
#' Note that as sites get added this data may need updating; if so, please
#' file an issue or contact PCCTC. In addition,
#' curated data deliveries now contain country information
#' in the medidata subject table.
#'
#' In addition, when identifying the site of a subject, it is best practice
#' to use actual site fields, rather than extracting from subject id. The site
#' identifier used in the subject id represents the site at the time of enrollment,
#' and subjects may change sites over time. The curent site is reflected in the
#' site fields, where as the enrollment site is reflected in the subject id.
#'
#' @format A data frame with 180 rows and 3 variables:
#' \describe{
#'   \item{site_id}{Numeric site id}
#'   \item{site_code}{Character site code with two digit padded zero}
#'   \item{site_name}{Full site name}
#'   \item{site_name_short}{Short site name}
#'   \item{site_name_true_nth}{Site name recorded in True North / PROMS}
#'   \item{site_country}{Country of site}
#' }
#' @source "PCCTC internal documentation"
"site_to_country"



#' PROMS question codes
#'
#' A dataset containing the variable names and corresponding question text for all PROMS.
#' The variables are as follows:
#'
#' @format A data frame with 462 rows and 2 variables:
#' \describe{
#'   \item{question_code}{Variable name of PROM question}
#'   \item{question_text}{Full text of PROM question}
#' }
#' @source "TrueNTH Questionnaire Code Dictionary - IRONMAN_v2.0.xlsx"
"proms_q_codes"


#' PROMS question options
#'
#' A dataset containing the levels and possible answers of all PROM questions.
#' The variables are as follows:
#'
#' @format A data frame with 1099 rows and 4 variables:
#' \describe{
#'   \item{Option Code}{ID for PROM answer}
#'   \item{option_code}{Variable name of PROM question}
#'   \item{option_order}{Ordering of PROM answers within a question}
#'   \item{Option Text}{PROM text response}
#' }
#' @source "TrueNTH Questionnaire Code Dictionary - IRONMAN_v2.0.xlsx"
"proms_q_opts"



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
#'   \item{Table.description}{Medidata table description}
#'   \item{Variable}{Variable name in medidata table}
#'   \item{Variable.label}{If available, a descriptive label for the variable}
#'   \item{R.column.type}{How the variable is stored in R}
#'   \item{DRS.Prompt.text}{Design Request Specification: Prompt text in the electronic data capture}
#'   \item{DRS.Format}{Design Request Specification: Variable capture SAS format specification electronic data capture}
#'   \item{DRS.Entry.type}{Design Request Specification: Variable field type in electronic data capture}
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


