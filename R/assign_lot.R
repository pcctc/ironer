#' Assign lines of therapy
#'
#' This algorithm assigns treatments to the same line when they occur
#' within 30 days of an initial treatment in a line. Treatments
#' occurring greater than 30 days from line initiation begin a new line.
#'
#' @param .data Data frame with treatment information
#' @param treatment Column containing treatment names
#' @param dt_trt_observed Column containing treatment start date
#' @param dt_treatment_end Column containing treatment end date
#'
#' @return Data frame with assigned line of therapy and regimen information
#' @export
#'
assign_lot <- function(
  .data, treatment = treatment,
  dt_trt_observed = dt_trt_observed, dt_treatment_end = dt_treatment_end
) {
  .data <- .data %>%
    dplyr::mutate(
      lot = dplyr::case_when(
        {{ dt_trt_observed }} - min({{ dt_trt_observed }}) < 31 ~ 1,
        TRUE ~ NA_real_
      )
    )

  .data <- .data %>%
    dplyr::group_by(.data$lot) %>%
    dplyr::mutate(regimen = paste({{ treatment }}, sep = ", ")) %>%
    dplyr::ungroup()

  i <- 2
  while(sum(is.na(.data$lot))) {
    dt_last_lot <- .data %>%
      dplyr::filter(.data$lot == max(.data$lot, na.rm = TRUE)) %>%
      dplyr::mutate(
        max_dt = dplyr::if_else(
          is.na({{ dt_treatment_end }}) | is.na({{ dt_trt_observed }}),
          dplyr::coalesce({{ dt_treatment_end }}, {{ dt_trt_observed }}),
          max({{ dt_treatment_end }}, {{ dt_trt_observed }})
        )
      ) %>%
      dplyr::slice(1) %>%
      dplyr::pull(.data$max_dt)

    dt_next_lot <- .data %>%
      dplyr::filter(is.na(.data$lot)) %>%
      dplyr::mutate(
        min_dt = min({{ dt_trt_observed }})
      ) %>%
      dplyr::slice(1) %>%
      dplyr::pull(.data$min_dt)

    .data <- .data %>%
      dplyr::mutate(
        lot = dplyr::case_when(
          !is.na(.data$lot) ~ .data$lot,
          {{ dt_trt_observed }} < dt_next_lot + 30 ~ i,
          TRUE ~ NA_real_
        )
      )

    n_unique_regimens <- .data %>%
      dplyr::filter(.data$lot %in% i:(i-1)) %>%
      dplyr::summarize(dplyr::n_distinct({{ treatment }})) %>%
      dplyr::pull()

    if (n_unique_regimens == 1) {
      .data <- .data %>%
        dplyr::mutate(
          lot = dplyr::if_else(.data$lot == i, i - 1, .data$lot)
        )
    } else(
      i <- i + 1
    )
  }

  .data <- .data %>%
    dplyr::group_by(.data$lot) %>%
    dplyr::arrange({{ treatment }}) %>%
    dplyr::mutate(
      regimen = paste(unique({{ treatment }}), collapse = ", "),
      dt_lot_start = min({{ dt_trt_observed }}),
      dt_lot_last_obs = max({{ dt_treatment_end }}, {{ dt_trt_observed }}, na.rm = TRUE)
    ) %>%
    dplyr::ungroup()

  .data
}
