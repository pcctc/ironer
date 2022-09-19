
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Installation

You can install the current development version of {ironer} from
[GitHub](https://github.com/pcctc/ironer).

``` r
# install.packages("devtools")
devtools::install_github("pcctc/ironer")
```

# Introduction

The goal of {ironer} is to provide a convenience functions and
documentation for wrangling data from the IRONMAN registry
<https://ironmanregistry.org/>.

If anything is unclear or could use updating, please file an
[issue](https://github.com/tgerke/ironer/issues) in this repository, or
contact the PCCTC data science team at
<zzpdl_pcctc_data_science@mskcc.org>.

# Included

## Articles

1.  Data documentation & FAQ

2.  Medidata Data Dictionary

3.  PROMS Data Dictionary

4.  Line of therapy algorithm

## Functions

-   `assign_lot()` is the function used to assign line of therapy.
    Researchers may find this useful to apply to their own data set.
    Please review the Line of Therapy vignette for caveats and usage.

-   `assign_baseline_metastatic()` is a function used internally at
    PCCTC to create the derived baseline metastatic variables in the
    subject table (`is_metastatic_baseline`,
    `origin_metastatic_baseline`, `date_metastatic_baseline`). As this
    information is available in the curated data, we do not see this as
    of particular use to researchers. However those interested in how
    this assignment is derived may be interested to review the source
    code.

-   `read_medidata()` is intended for use with a folder of `.sas7bdat`
    SAS files. Standard data deliveries are no longer receiving the raw
    `.sas7bdat` files, but rather data curated specific to the
    investigator’s needs. Therefore, this function may no longer be of
    interest to most.

## Data

The data in the {ironer} package is in progress and subject to change.

-   `dictionary_medidata` Data dictionary of clinical data recorded in
    medidata. Subject to change. The data consists of multiple tables.

-   `dictionary_proms` is a data set of the data dictionary of Patient
    Reported Outcomes and Measures (PROMS) self-report survey data. The
    survey consists of multiple instruments. Some instruments also have
    multiple versions. Subject to change..

-   `site_to_country` is a data set of all PCCTC site IDs mapping from
    treatment site to country. Not all site IDs apply to Ironman. Note
    that as sites get added this data may need updating. In addition,
    curated data deliveries now contain country information in the
    medidata subject table.

-   `treatment_map` represents the treatment mappings from the original
    raw data to standardized & recoded treatment assignments. If a
    mapping needs to be corrected or added, please file an issue or
    contact PCCTC. Note that this mapping should already be in the
    `priorrx_derived` and `treatment_derived` tables.

-   `proms_q_codes` & `proms_q_opts` are from the original PROMs export
    in long format (that is, one row per subject, timepoint, and
    question.) These are probably no longer relevant in the new “wide”
    PROMs export (one row per subject and timepoint, multiple columns
    for questions) and the associated PROMs data dictionary.
