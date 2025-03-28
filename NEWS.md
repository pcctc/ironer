# ironer 0.1.2 [2025-02-26]

* Comprehensive Ironman Treatment Tutorial added
  
  + blinded data set added and used in tutorial 


# ironer 0.1.1 [2025-01-30]

* README

  + `priorrx` (prior treatments) `treatment` (cancer treatments) consolidated into
  a single form `ca_cm` (cancer treatments). 
  
* Data Dictionary

  + Added the `sf` table
  
* Line of therapy
  
  + `priorrx` (prior treatments) `treatment` (cancer treatments) consolidated into
  a single form `ca_cm` (cancer treatments). 
  
  + Adjusted text throughout article to account for the form migration

* Overall

  + made minor text adjustments across site





# ironer 0.1.0 [2024-06-20]

* Medidata data

  + `priorrx` (prior treatments) `treatment` (cancer treatments) consolidated into
  a single form `ca_cm` (cancer treatments). 
  
  + `priorrx`, `priorrx_derived`, `treatment`, and `treatment_derived` removed
  
  + `ca_cm` and `ca_cm_derived` added
  
  + additionally, `pf` (sequencing reports) and `gf` (genomics findings) added
  


# ironer 0.0.9 [2023-10-18]

* Medidata documentation

  + Add physician questionnaires and information regarding corresponding protocols.
  
  + Update Medidata dictionary to match latest data commons export.

# ironer 0.0.8 [2023-08-11]

* README

   + Added additional publications.

# ironer 0.0.7 [2023-04-20]

* PROMS data

   + In `YYYY-MM-DD_proms.csv` exports, the `dbl` (numeric) fields `eortc_29`, 
   `eortc_30`, `ironmisc_12`, `ironmisc_13`, `ironmisc_v5_15`, and `ironmisc_v5_16`
   were corrected to not export character values of `NA` in the .csv; instead,
   missing values now appear as blank.

# ironer 0.0.6 [2023-04-17]


* Medidata data

   + For the derived indication of baseline metastatic, additional logic was
   included to **not** count unknown histology in additional biopsies (rule 7, `mhaddbx`) 
   as baseline metastatic. This affected 6 subjects.

# ironer 0.0.5 [2023-03-24]

* Medidata data

   + add `basedoneyn`, `mon12_yn`, and `cyclex_yn` to general data deliveries.

* Documentation

   + Update FAQ for genetic testing.
 
   + Add date imputation explanation.

# ironer 0.0.4 [2022-12-05]

* updated `treatment_map` by cleaning some therapies that were mapping to multiple treatments due to capitalization discrepancies.

# ironer 0.0.3 [2022-11-14]

* Medidata data

  + added `prsurg` (Prior Cancer Related Surgery) and `surg` (Cancer Surgery) tables to standard data delivery (this contains mostly free text responses).



# ironer 0.0.2 [2022-09-30]

* Medidata data

   + remove `brthdate` variables from `dm` table
   
   + clarify in variable label that `age` in `dm` table is age at consent
   
   + add race & ethnicity variables captured in PROMS to `subject` table
   
   + update classification of baseline metastatic in `subject` table to include a
   seventh rule based on additional biopsies
   
   
* Medidata dictionary: 

   + update dictionary according to changes listed in data above

   + Remove `drs_format` & `drs_entry_type` columns;
   rename `drs_prompt_text` to `prompt text`

* PROMS data

  + Due to requirements for SAS variable names, all periods in variable
  names have been replaced with underscores
  
  
* PROMS dictionary

  + Update dictionary according to changes listed in data above


# ironer 0.0.1 [2022-09-23]

* Initial release of documentation.
