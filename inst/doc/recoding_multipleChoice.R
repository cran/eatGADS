## ---- include = FALSE-----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  error = FALSE
)

## ----setup----------------------------------------------------------------------------------------
library(eatGADS)
data_path <- system.file("extdata", "multipleChoice.sav", package = "eatGADS")
gads <- import_spss(data_path)

# Show example data set
gads

## ----recode2NA------------------------------------------------------------------------------------
gads <- recode2NA(gads, value = "")

## ----lookup---------------------------------------------------------------------------------------
lookup <- createLookup(GADSdat = gads, recodeVars = "stringvar", sort_by = 'value', 
                       addCols = c("language", "language2", "language3"))

lookup

## ----lookup export, eval=FALSE--------------------------------------------------------------------
#  # write look up table to Excel
#  eatAnalysis::write_xlsx(lookup, "lookup_forcedChoice.xlsx")

## ----lookup import export, eval=FALSE-------------------------------------------------------------
#  # write look up table to Excel
#  eatAnalysis::write_xlsx(lookup, "lookup_multipleChoice.xlsx")
#  
#  ### perform recodes in Excel sheet!
#  
#  # read look up table back to R
#  lookup <- readxl::read_xlsx("lookup_multipleChoice.xlsx")
#  lookup

## ----editing lookup, echo = FALSE-----------------------------------------------------------------
lookup$language <- c(NA, NA, "English", "German", "German", 
                     "Polish", -96, "English", "German", "Polish")
lookup$language2 <- c(NA, NA, "Polish", NA, NA, 
                      "Italian", -96, "Italian", "Polish", NA)
lookup$language3 <- c(NA, NA, "Italian", NA, NA, 
                      "German", -96, NA, NA, NA)
lookup

## ----integrate the Lookup table-------------------------------------------------------------------
gads_string <- applyLookup_expandVar(GADSdat = gads, lookup = lookup)

gads_string$dat

## ----label missings from Lookup table-------------------------------------------------------------
for(nam in paste0("stringvar_", 1:3)) {
  gads_string <- changeValLabels(gads_string, varName = nam, 
                                 value = -96, valLabel = "Missing: Not codeable")
  gads_string <- changeMissings(gads_string, varName = nam, 
                                value = -96, missings = "miss")
}

gads_string$labels

## ----named character vector-----------------------------------------------------------------------
value_string <- c(lookup$language, lookup$language2, lookup$language3)
named_char_vec <- matchValues_varLabels(GADSdat = gads_string, 
                                        mc_vars = c("mcvar1", "mcother"), 
                                        values = value_string, 
                                        label_by_hand = c("other"="mcother"))
named_char_vec

## ----collapse-------------------------------------------------------------------------------------
gads_string2 <- collapseMultiMC_Text(GADSdat = gads_string, mc_vars = named_char_vec, 
                                     text_vars = c("stringvar_1", "stringvar_2", "stringvar_3"), 
                                     mc_var_4text = "mcother", var_suffix = "_r", 
                                     label_suffix = "(recoded)",
                                     invalid_miss_code = -98, 
                                     invalid_miss_label = "Missing: By intention",
                                     notext_miss_code = -99, 
                                     notext_miss_label = "Missing: By intention")

gads_string2$dat

## ----remove2NAchar--------------------------------------------------------------------------------
gads_string3 <- remove2NAchar(GADSdat = gads_string2, 
                              vars = c("stringvar_1_r", "stringvar_2_r", "stringvar_3_r"), 
                              max_num = 2, na_value = -97, 
                              na_label = "missing: excessive answers")

gads_string3$dat

## ----multiChar2fac--------------------------------------------------------------------------------
gads_numeric <- multiChar2fac(GADSdat = gads_string3, vars = c("stringvar_1_r", "stringvar_2_r"), 
                              var_suffix = "_r", label_suffix = "(recoded)")

gads_numeric$dat

gads_final <- gads_numeric
extractMeta(gads_final)[, c("varName", "value", "valLabel", "missings")]

## ----remove vars----------------------------------------------------------------------------------
gads_final2 <- removeVars(gads_final, vars = c("stringvar_1", "stringvar_2", "stringvar_3",
                                               "stringvar_1_r", "stringvar_2_r"))

