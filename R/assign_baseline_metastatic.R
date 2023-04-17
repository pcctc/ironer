#' Create baseline metastatic flags for IRONMAN participants
#'
#' This function will return whether baseline metastatic disease is present
#' and site, when feasible. Be aware that this function is specific to
#' the IRONMAN study. The general principles should apply to other studies,
#' but the function expects certain Medidata field names.
#'
#' @param medidata_list a list with clinical medidata from IRONMAN
#'
#' @return A list with various details for baseline metastatic disease classification.
#' The primary deliverable is the metastatic_flags table; the remaining tables
#' are supplied for internal QC purposes.
#' @export
assign_baseline_metastatic <- function(medidata_list) {

    # rule 1 -----------------------------------------------------------------------
    # medical history clinical staging
    # M0  not metastatic
    # M1  metastatic
    # M1a distant lymph
    # M1b bone
    # M1c other organs
    # MX  unknown metastatic / same as UNK
    # variables are different staging rules

    # confirm which variables to check and what values it takes one
    rule_1 <- medidata_list$mhclinstg %>%
      dplyr::mutate(
        dplyr::across(
          c(dplyr::starts_with("clinstg_mstage_u"), -dplyr::ends_with("_std")),
          ~ stringr::str_detect(.x, stringr::regex("M1|M1a|M1b|M1c")),
          .names = "is_mets_{.col}"
        ),
        clinstg_date_int_clean = dplyr::case_when(
          year(lubridate::as_date(clinstg_date_int)) == 1900 ~ NA_Date_,
          TRUE ~ lubridate::as_date(clinstg_date_int)
        ),
        num_mets_rule_1 = rowSums(dplyr::across(dplyr::starts_with("is_mets")), na.rm = TRUE),
        is_mets_rule_1 = dplyr::if_else(.data$num_mets_rule_1 > 0, 1, 0),
        origin_mets_rule_1 = dplyr::if_else(.data$is_mets_rule_1 == 1, "Clinical M stage", NA_character_),
        date_rule_1 = dplyr::case_when(
          is_mets_rule_1 == 1 ~ clinstg_date_int_clean
        )
      ) %>%
      dplyr::select(subject, is_mets_rule_1, origin_mets_rule_1, date_rule_1, clinstg_date_int_clean, c(dplyr::starts_with("clinstg_mstage_u"), -dplyr::ends_with("_std")), dplyr::starts_with("is_mets")) %>%
      labelled::set_variable_labels(
        clinstg_date_int_clean = "Clean clinstg_date_int with 1900 dates removed",
        date_rule_1 = "clinstg_date_int_clean ",
        is_mets_rule_1 = "1 if indicated by any of M1, M1a, M1b, M1c stage",
        origin_mets_rule_1 = "Origin of metastatic classification by rule 1 (mhclinstg: Medical History/Clinical Stage (TNM) at Diagnosis)"
      )

    # rule 2 -----------------------------------------------------------------------
    # create a flag that identifies any of "M1|M1a|M1b|M1c" dplyr::across prpros variables
    # clinstg_mstage_uicc02, clinstg_mstage_uicc09, clinstg_mstage_uicc92,
    # clinstg_mstage_uicc97, clinstg_mstage_unk, clinstg_mstage_uicc16
    rule_2 <- medidata_list$prpros %>%
      dplyr::mutate(
        dplyr::across(
          c(dplyr::starts_with("rpdtl_mstage_u"), -dplyr::ends_with("_std")),
          ~ stringr::str_detect(.x, stringr::regex("M1|M1a|M1b|M1c")),
          .names = "is_mets_{.col}"
        ),
        num_mets_rule_2 = rowSums(dplyr::across(dplyr::starts_with("is_mets")), na.rm = TRUE),
        is_mets_rule_2 = dplyr::if_else(.data$num_mets_rule_2 > 0, 1, 0),
        origin_mets_rule_2 = dplyr::if_else(is_mets_rule_2 == 1, "Pathological M stage", NA_character_),
        date_rule_2 = dplyr::case_when(
          is_mets_rule_2 == 1 ~ prprosdt_int
        )
      ) %>%
      dplyr::select(subject, is_mets_rule_2, origin_mets_rule_2, date_rule_2, c(dplyr::starts_with("rpdtl_mstage_u"), -dplyr::ends_with("_std")), dplyr::starts_with("is_mets")) %>%
      labelled::set_variable_labels(
        date_rule_2 = "prprosdt_int: Date of Prior Prostatectomy",
        is_mets_rule_2 = "1 if indicated by any of M1, M1a, M1b, M1c stage",
        origin_mets_rule_2 = "Origin of metastatic classification by rule 2 (prpros: Medical History/Prior Prostatectomy)"
      )



    # rule 3 ---------------------------------------------------------------------
    # this rule in particular could use regular QC
    # create a flag for diagnostic biopsy in any metastatic anatomic sites
    rule_3 <- medidata_list$mhdiagbx %>%
      dplyr::mutate(
        diagbx_site_clean = diagbx_site %>% stringr::str_to_lower() %>% stringr::str_squish(),
        is_site_mets =  stringr::str_detect(
          diagbx_site_clean,
          stringr::regex(
            paste("Prostate", "Pelvic lymph", "Pelvic LN", "Unknown", "Pelvis", "prostatic", sep = "|"),
            ignore_case = TRUE
          ),
          negate = TRUE
        ),
        is_histology_mets = stringr::str_detect(
          diagbx_histology,
          stringr::regex("benign|negative", ignore_case = TRUE),
          negate = TRUE),
        is_mets_rule_3 = dplyr::case_when(
          is.na(.data$diagbx_site) ~ 0,
          is_site_mets & is_histology_mets ~ 1,
          TRUE ~ 0
        ),
        origin_mets_rule_3 = dplyr::if_else(.data$is_mets_rule_3 == 1,
                                            glue::glue("Diagnostic biopsy: {diagbx_site}"),
                                            NA_character_),
        date_rule_3 = dplyr::case_when(
          is_mets_rule_3 == 1 ~ diagbx_date_int
        )
      ) %>%
      dplyr::select(subject, is_mets_rule_3, origin_mets_rule_3, date_rule_3, is_site_mets, is_histology_mets ,diagbx_site, diagbx_site_clean, diagbx_histology) %>%
      labelled::set_variable_labels(
        diagbx_site_clean = "diagbx_site lower case and without leading/trailing spaces",
        date_rule_3 = "diagbx_date_int: Diagnostic Biopsy Date",
        is_mets_rule_3 = "1 if indicated by diagbx_site",
        origin_mets_rule_3 = "Origin of metastatic classification by rule 3 (mhdiagbx: Medical History/Diagnostic Biopsy)"
      )

    # rule 4 -----------------------------------------------------------------------
    # metastatic disease sites
    # for current status, look at other folders
    # create a flag that identifies "Yes" dplyr::across cs variables at baseline
    # csskull, csthor, csspine, cspelvis, csext, csliver, cslung, csdn, csoth/csother2
    rule_4_init <- medidata_list$cs %>%
      dplyr::filter(.data$instance_name == "Baseline 0") %>%
      dplyr::mutate(
        dplyr::across(
          c(dplyr::starts_with("cs"), -dplyr::starts_with("csdat"),
            -dplyr::ends_with("std"), -.data$csother2),
          ~ str_detect(.x, regex("Yes", ignore_case = TRUE)),
          .names = "is_mets_{.col}"
        ),
        num_mets_rule_4 = rowSums(dplyr::across(dplyr::starts_with("is_mets")), na.rm = TRUE),
        is_mets_rule_4 = dplyr::if_else(.data$num_mets_rule_4 > 0, 1, 0),
        date_rule_4 = case_when(
          is_mets_rule_4 == 1 ~ csdat_int
        )
      ) %>%
      dplyr::select(.data$subject, is_mets_rule_4, date_rule_4, c(dplyr::starts_with("cs"), -dplyr::starts_with("csdat"),
                                                                  -dplyr::ends_with("std"), -.data$csother2),
                    dplyr::starts_with("is_mets"), .data$csother2)

    rule_4 <- rule_4_init %>%
      dplyr::group_by(.data$subject) %>%
      tidyr::pivot_longer(cols = c(dplyr::starts_with("is_mets"), -.data$is_mets_rule_4)) %>%
      dplyr::filter(.data$value == TRUE) %>%
      dplyr::mutate(
        name = stringr::str_replace(.data$name, "is_mets_cs", ""),
        origin_mets = paste(.data$name, collapse = ", "),
        origin_mets_rule_4 = paste("CS metastatic site(s): ", .data$origin_mets)
      ) %>%
      dplyr::slice(1) %>%
      dplyr::ungroup() %>%
      dplyr::select(.data$subject, .data$origin_mets_rule_4) %>%
      dplyr::right_join(rule_4_init, by = "subject") %>%
      labelled::set_variable_labels(
        date_rule_4 = "csdat_int: Date of assessment",
        is_mets_rule_4 = "1 if metastatic disease site indicated",
        origin_mets_rule_4 = "Origin of metastatic classification by rule 4 (cs: Metastatic Disease Sites)"
      )



    # rule 5 -----------------------------------------------------------------------
    # physician QRE
    # join the 3 physician questionnaire tables
    # call mets when sites are marked from each pq as:
    # new_pq: bone, lymph node, visceral, or soft tissue
    rule_5 <- medidata_list$new_pq %>%
      dplyr::filter(.data$instance_name == "Baseline 0") %>%
      dplyr::select(
        .data$subject, date_rule_5 = newpq_date_int, .data$newpq_2b, .data$newpq_2c, .data$newpq_2d, .data$newpq_2e
      ) %>%
      dplyr::mutate(
        newpq_2b = dplyr::if_else(.data$newpq_2b == 1, "Bone", NA_character_),
        newpq_2c = dplyr::if_else(.data$newpq_2c == 1, "Lymph node", NA_character_),
        newpq_2d = dplyr::if_else(.data$newpq_2d == 1, "Visceral", NA_character_),
        newpq_2e = dplyr::if_else(.data$newpq_2e == 1, "Soft tissue", NA_character_),
      ) %>%
      dplyr::full_join(
        medidata_list$new_pq_v4 %>%
          janitor::clean_names() %>%
          dplyr::filter(.data$instance_name == "Baseline 0") %>%
          dplyr::select(
            .data$subject, .data$newpq12b_v4, .data$newpq12c_v4, .data$newpq12d_v4, .data$newpq12e_v4
          ) %>%
          dplyr::mutate(
            newpq12b_v4 = dplyr::if_else(.data$newpq12b_v4 == 1, "Lymph node", NA_character_),
            newpq12c_v4 = dplyr::if_else(.data$newpq12c_v4 == 1, "Bone", NA_character_),
            newpq12d_v4 = dplyr::if_else(.data$newpq12d_v4 == 1, "Visceral", NA_character_),
            newpq12e_v4 = dplyr::if_else(.data$newpq12e_v4 == 1, "Soft tissue", NA_character_),
          ),
        by = "subject"
      ) %>%
      dplyr::full_join(
        medidata_list$new_pq_v5 %>%
          janitor::clean_names() %>%
          dplyr::filter(.data$instance_name == "Baseline 0") %>%
          dplyr::select(
            .data$subject, .data$newpq12b_v5, .data$newpq12c_v5, .data$newpq12d_v5, .data$newpq12e_v5
          ) %>%
          dplyr::mutate(
            newpq12b_v5 = dplyr::if_else(.data$newpq12b_v5 == 1, "Lymph node", NA_character_),
            newpq12c_v5 = dplyr::if_else(.data$newpq12c_v5 == 1, "Bone", NA_character_),
            newpq12d_v5 = dplyr::if_else(.data$newpq12d_v5 == 1, "Visceral", NA_character_),
            newpq12e_v5 = dplyr::if_else(.data$newpq12e_v5 == 1, "Soft tissue", NA_character_),
          ),
        by = "subject"
      ) %>%
      tidyr::unite(
        origin_mets,
        dplyr::starts_with("newpq"),
        sep = ", ",
        remove = FALSE,
        na.rm = TRUE
      ) %>%
      dplyr::mutate(
        is_mets_rule_5 = dplyr::if_else(.data$origin_mets != "", 1, 0),
        origin_mets_rule_5 = dplyr::if_else(
          .data$origin_mets == "",
          "",
          paste("PQ:", .data$origin_mets)
        ),
        date_rule_5 = case_when(
          is_mets_rule_5 == 1 ~ date_rule_5
        )
      ) %>%
      dplyr::select(subject, is_mets_rule_5, origin_mets_rule_5, date_rule_5, everything(), -origin_mets) %>%
      labelled::set_variable_labels(
        date_rule_5 = "newpq_date_int: Date New Treatment (protocol v3) physician qre submitted ",
        is_mets_rule_5 = "1 if indicated bone, lymph node, visceral, or soft tissue metastasis  in physician qre",
        origin_mets_rule_5 = "Origin of metastatic classification by rule 5 (new_pq, new_pq_v4, new_pq_v5: New Treatment physician qre)"
      )

    # newpq_date_int represents date QRE completed, so would know occurred prior to this date
    # dates not available from new_pq_v4, new_pq_v5
    # not sure this is a good idea to bring in, will keep for now

    # new rule 6 -------------------------------------------------------------------
    # mhdx diagnosis dates - these can be updated any time, not necessarily reflective of baseline
    # PULL IN mhspcdat_int & mcrpcdat_int
    # informed consent + 30 days constitutes baseline date - anything before
    rule_6 <- medidata_list$mhdx %>%
      dplyr::select(subject, mhspcdat_int, mcrpcdat_int) %>%
      dplyr::left_join(
        dplyr::select(medidata_list$ic, subject, cnstdate_int), by = "subject"
      ) %>%
      dplyr::mutate_at(dplyr::vars(mhspcdat_int, mcrpcdat_int, cnstdate_int), lubridate::as_date) %>%
      dplyr::mutate(
        baseline_window = cnstdate_int + 30,
        mhspcdat_int_clean = dplyr::case_when(
          year(mhspcdat_int) == 1900 ~ NA_Date_,
          TRUE ~ mhspcdat_int
        ),
        mcrpcdat_int_clean = dplyr::case_when(
          year(mcrpcdat_int) == 1900 ~ NA_Date_,
          TRUE ~ mcrpcdat_int
        )) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        min_date =
          case_when(
            is.na(mhspcdat_int_clean) & is.na(mcrpcdat_int_clean) ~ NA_Date_,
            TRUE ~ suppressWarnings({min(mhspcdat_int_clean, mcrpcdat_int_clean, na.rm = TRUE)})
            ),
        date_rule_6 = dplyr::case_when(
          min_date < baseline_window ~ min_date,
          TRUE ~ NA_Date_
        )) %>%
      ungroup() %>%
      mutate(
        is_mets_rule_6 = dplyr::case_when(
          is.na(date_rule_6) ~ 0,
          date_rule_6 < baseline_window ~ 1,
          date_rule_6 >= baseline_window ~ 0
        ),
        origin_mets_rule_6 = dplyr::case_when(
          is_mets_rule_6 == 1 ~ "Disease State Dates"
        )) %>%
      dplyr::select(subject, is_mets_rule_6, origin_mets_rule_6, date_rule_6, everything()) %>%
      labelled::set_variable_labels(
        cnstdate_int = "Consent Date",
        mhspcdat_int = "mHSPC - metastatic Date",
        mcrpcdat_int = "CRPC - non-metastatic Date",
        mhspcdat_int_clean = "CLEAN mHSPC - metastatic Date (1900s removed)",
        mcrpcdat_int_clean = "CLEAN CRPC - metastatic Date (1900s removed)",
        baseline_window = "Consent date + 30 days",
        date_rule_6 = "Minimum of clean mHSPC & CRPC dates",
        is_mets_rule_6 = "1 if date_rule_6 occurs prior to baseline_window",
        origin_mets_rule_6 = "Origin of metastatic classification by rule 6 (mhdx: Disease State Dates)"
      )

    # rule 7 ---------------------------------------------------------------------
    # Medical History/Additional Biopsies (mhaddbx)
    # this rule in particular could use regular QC
    # create a flag for diagnostic biopsy in any metastatic anatomic sites
    # this is similar to rule 3: mhdiagbx
    rule_7 <- medidata_list$mhaddbx  %>%
      dplyr::left_join(
        dplyr::select(medidata_list$ic, subject, cnstdate_int), by = "subject"
      ) %>%
      dplyr::mutate(
        baseline_window = cnstdate_int + 30,
        in_baseline = addbxdate_int < baseline_window
      ) |>
      dplyr::filter(in_baseline) |>
      dplyr::mutate(
        addbx_site_clean = addbx_site %>% stringr::str_to_lower() %>% stringr::str_squish(),
        is_site_mets =  stringr::str_detect(
          addbx_site_clean,
          stringr::regex(
            paste("Prostate", "Pelvic lymph", "Pelvic LN", "Unknown", "Pelvis", "prostatic", sep = "|"),
            ignore_case = TRUE
          ),
          negate = TRUE
        ),
        is_histology_mets = stringr::str_detect(
          addbx_histology,
          stringr::regex("benign|negative|unknown", ignore_case = TRUE),
          negate = TRUE),
        is_mets_rule_7 = dplyr::case_when(
          is.na(.data$addbx_site) ~ 0,
          is_site_mets & is_histology_mets ~ 1,
          TRUE ~ 0
        ),
        date_rule_7_init = dplyr::case_when(
          is_mets_rule_7 == 1 ~ addbxdate_int
        )
      ) %>%
      dplyr::arrange(subject, addbxdate_int) |>
      # for this group, only keep those indicated as baseline metastatic
      dplyr::filter(is_mets_rule_7 == 1) |>
      dplyr::group_by(subject, is_mets_rule_7, is_site_mets, is_histology_mets) |>
      dplyr::summarize(
        date_rule_7 = min(date_rule_7_init),
        origin_mets_rule_7_init = paste(addbx_site, collapse = "; "),
        addbx_histology = paste(addbx_histology, collapse = "; "),
      ) |>
      dplyr::ungroup() |>
      dplyr::mutate(origin_mets_rule_7 = paste0("Additional biopsy: ", origin_mets_rule_7_init)) |>
      dplyr::select(subject, is_mets_rule_7, origin_mets_rule_7, date_rule_7, is_site_mets, is_histology_mets, addbx_histology) %>%
      labelled::set_variable_labels(
        date_rule_7 = "addbxdate_int: Earliest date of metastatic additional biopsy prior to consent",
        is_mets_rule_7 = "1 if indicated by addbx_site",
        origin_mets_rule_7 = "Origin of metastatic classification by rule 7 (mhaddbx: Medical History/Additional Biopsies)",
        addbx_histology = "Histology biopsy"
      )


    # check for duplicate subjects ---------------------------------------------
    dups <- tibble::lst(
      rule_1, rule_2, rule_3, rule_4, rule_5, rule_6, rule_7
      ) |>
      map(croquet::find_duplicates, subject)


    # rule 1 duplicates warning ----
    if(nrow(dups$rule_1) > 0) {
      cli::cli_alert_info(c(
        "Rule 1 (mhclinstg) has {nrow(dups$rule_1)} duplicate subject record{?s}\n",
        "{dups$rule_1$subject}"))
    }

    # rule 2 duplicates warning ----
    if(nrow(dups$rule_2) > 0) {
      cli::cli_alert_info(c(
        "Rule 2 (prpros) has {nrow(dups$rule_2)} duplicate subject record{?s}\n",
        "{dups$rule_2$subject}"))
    }

    # rule 3 duplicates warning ----
    if(nrow(dups$rule_3) > 0) {
      cli::cli_alert_info(c(
        "Rule 3 (mhdiagbx) has {nrow(dups$rule_3)} duplicate subject record{?s}\n",
        "{dups$rule_3$subject}"))
    }


    # rule 4 duplicates warning ----
    if(nrow(dups$rule_4) > 0) {
      cli::cli_alert_info(c(
        "Rule 4 (cs) has {nrow(dups$rule_4)} duplicate subject record{?s}\n",
        "{dups$rule_4$subject}"))
    }


    # rule 5 duplicates warning ----
    if(nrow(dups$rule_5) > 0) {
      cli::cli_alert_info(c(
        "Rule 5 (physician questionnaire) has {nrow(dups$rule_5)} duplicate subject record{?s}\n",
        "{dups$rule_5$subject}"))
    }

    # rule 6 duplicates warning ----
    if(nrow(dups$rule_6) > 0) {
      cli::cli_alert_info(c(
        "Rule 6 (Disease State Dates) has {nrow(dups$rule_6)} duplicate subject record{?s}\n",
        "{dups$rule_6$subject}"))
    }

    # rule 7 duplicates warning ----
    if(nrow(dups$rule_7) > 0) {
      cli::cli_alert_info(c(
        "Rule 7 (Additional biopsies) has {nrow(dups$rule_7)} duplicate subject record{?s}\n",
        "{dups$rule_7$subject}"))
    }



    # combine all rules ------------------------------------------------------------
    metastatic_flags_all <- rule_1 %>%
      dplyr::select(subject, is_mets_rule_1, origin_mets_rule_1, date_rule_1) %>%
      dplyr::full_join(rule_2 %>% select(subject, is_mets_rule_2, origin_mets_rule_2, date_rule_2) , by = "subject") %>%
      dplyr::full_join(rule_3 %>% select(subject, is_mets_rule_3, origin_mets_rule_3, date_rule_3), by = "subject") %>%
      dplyr::full_join(rule_4 %>% select(subject, is_mets_rule_4, origin_mets_rule_4, date_rule_4), by = "subject") %>%
      dplyr::full_join(rule_5 %>% select(subject, is_mets_rule_5, origin_mets_rule_5, date_rule_5), by = "subject") %>%
      dplyr::full_join(rule_6 %>% select(subject, is_mets_rule_6, origin_mets_rule_6, date_rule_6), by = "subject") %>%
      dplyr::full_join(rule_7 %>% select(subject, is_mets_rule_7, origin_mets_rule_7, date_rule_7), by = "subject") %>%
      # in case of duplicate records per subject, retail last record -----------
      dplyr::group_by(subject) |>
      dplyr::mutate(last_obs = dplyr::row_number() == dplyr::n()) |>
      dplyr::ungroup() |>
      dplyr::filter(last_obs) |>
      dplyr::mutate(dplyr::across(dplyr::matches("date_rule"), lubridate::as_date)) %>%
      dplyr::mutate(dplyr::across(dplyr::matches("origin_mets"), na_if, "")) %>%
      dplyr::mutate(
        num_metastatic = rowSums(
          dplyr::across(c(dplyr::starts_with("is_mets"), dplyr::ends_with("rule"))),
          na.rm = TRUE
        ),
        is_metastatic_baseline = dplyr::case_when(
          is.na(num_metastatic) ~ 0,
          num_metastatic == 0 ~ 0,
          num_metastatic > 0 ~ 1,
        )) %>%
      tidyr::unite(
        origin_metastatic_baseline,
        dplyr::starts_with("origin_mets"),
        sep = "; ",
        remove = FALSE,
        na.rm = TRUE
      ) %>%
      # identify if dates are missing
      dplyr::mutate_at(dplyr::vars(dplyr::matches("date_rule_")),
                       list("missing" = ~ is.na(.))
      ) %>%
      # count number of missing dates
      dplyr::mutate(
        num_date_miss = rowSums(
          dplyr::across(dplyr::ends_with("missing")),
          na.rm = TRUE
        )) %>%
      rowwise() %>%
      # if all 7 dates missing assign to proper date missing, otherwise return to min
      mutate(date_metastatic_baseline = case_when(
        num_date_miss == 7 ~ NA_Date_,
        TRUE ~ suppressWarnings({min(date_rule_1, date_rule_2, date_rule_3, date_rule_4, date_rule_5, date_rule_6, date_rule_7, na.rm = TRUE) %>% as_date()})
      )) %>%
      ungroup() %>%
      # one more for good measure
      dplyr::mutate(dplyr::across(dplyr::matches("origin"), na_if, "")) %>%
      dplyr::select(subject, is_metastatic_baseline, origin_metastatic_baseline, date_metastatic_baseline, everything(),
                    -num_metastatic, -num_date_miss, -dplyr::ends_with("missing")) %>%
      labelled::set_variable_labels(
        is_metastatic_baseline = "Derived: Indicates if subject is metastatic at baseline (1 = metastatic, 0 = non-metastatic)",
        origin_metastatic_baseline = "Derived: Source of baseline metastatic designation",
        date_metastatic_baseline = "Derived: Earliest known date of baseline metastatic designation"
      )

    metastatic_flags <- metastatic_flags_all %>%
      select(subject, is_metastatic_baseline, origin_metastatic_baseline, date_metastatic_baseline)


    out <- tibble::lst(
      metastatic_flags, metastatic_flags_all, rule_1, rule_2, rule_3, rule_4, rule_5, rule_6, rule_7
    )

    return(out)




  }

