
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ironer

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/pcctc/ironer/branch/main/graph/badge.svg)](https://app.codecov.io/gh/pcctc/ironer?branch=main)
[![R-CMD-check](https://github.com/pcctc/ironer/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pcctc/ironer/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# Introduction

The goal of {ironer} is to provide a convenience functions and
documentation for wrangling data from the IRONMAN registry
<https://ironmanregistry.org/>.

If anything is unclear or could use updating, please file an
[issue](https://github.com/pcctc/ironer/issues) in this repository, or
contact the PCCTC data science team at
<zzpdl_pcctc_data_science@mskcc.org>.

# Ironman Overview

Please see the peer-reviewed journal publication:

<a href="https://ascopubs.org/doi/pdf/10.1200/GO.22.00154?role=tab"
target="_blank">IRONMAN: A Novel International Registry of Men With
Advanced Prostate Cancer</a>

Lorelei A. Mucci, Jacob Vinson, Theresa Gold, Travis Gerke, Julie
Filipenko, Rebecca M. Green, Simon G. Anderson, Simone Badal, Anders
Bjartell, Kim N. Chi, Ian D. Davis, Deborah Enting, André P. Fay, John
Lazarus, Joaquin Mateo, Ray McDermott, Folakemi T. Odedina, David Olmos,
Aurelius Omlin, Ademola A. Popoola, Camille Ragin, Robin Roberts, Kjell
M. Russnes, Charles Waihenya, Konrad H. Stopsack, Terry Hyslop, Paul
Villanti, Philip W. Kantoff, Daniel J. George, and on behalf of the
IRONMAN Global Team

JCO Global Oncology 2022 :8

# Installation

You can install the current development version of {ironer} from
[GitHub](https://github.com/pcctc/ironer).

``` r
# install.packages("devtools")
devtools::install_github("pcctc/ironer")
```

# Included

## Articles

1.  Medidata data documentation

2.  PROMS data documentation

3.  Line of therapy algorithm

4.  Treatment mapping

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

## Data

The data in the {ironer} package is in progress and subject to change.

-   `dictionary_medidata` Data dictionary of clinical data recorded in
    medidata. Subject to change. The data consists of multiple tables.

-   `dictionary_proms` is a data set of the data dictionary of Patient
    Reported Outcomes and Measures (PROMS) self-report survey data. The
    survey consists of multiple instruments. Some instruments also have
    multiple versions. Subject to change..

-   `treatment_map` represents the treatment mappings from the original
    raw data to standardized & recoded treatment assignments. If a
    mapping needs to be corrected or added, please file an issue or
    contact PCCTC. Note that this mapping should already be in the
    `priorrx_derived` and `treatment_derived` tables.
