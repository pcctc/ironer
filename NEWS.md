# ironer 0.0.3 [2022-11-14]

* Medidata data

  + add `prsurg` (Prior Cancer Related Surgery) and `surg` (Cancer Surgery) tables to standard data delivery (this contains mostly free text responses).


* PROMS data

  + fix encoding of multiple choice survey responses (some were
  coded numerically, some coded character - ensure all are coded as
  character).

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
