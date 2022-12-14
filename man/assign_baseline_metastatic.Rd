% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/assign_baseline_metastatic.R
\name{assign_baseline_metastatic}
\alias{assign_baseline_metastatic}
\title{Create baseline metastatic flags for IRONMAN participants}
\usage{
assign_baseline_metastatic(medidata_list)
}
\arguments{
\item{medidata_list}{a list with clinical medidata from IRONMAN}
}
\value{
A list with various details for baseline metastatic disease classification.
The primary deliverable is the metastatic_flags table; the remaining tables
are supplied for internal QC purposes.
}
\description{
This function will return whether baseline metastatic disease is present
and site, when feasible. Be aware that this function is specific to
the IRONMAN study. The general principles should apply to other studies,
but the function expects certain Medidata field names.
}
