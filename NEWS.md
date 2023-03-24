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
