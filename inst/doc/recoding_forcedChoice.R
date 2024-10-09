## ----include = FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup----------------------------------------------------------------------------------------
library(eatGADS)
data_path <- system.file("extdata", "forcedChoice.sav", package = "eatGADS")
gads <- import_spss(data_path)

# Show example data set
gads

## ----recode2NA------------------------------------------------------------------------------------
gads <- recode2NA(gads, value = "")

## ----lookup---------------------------------------------------------------------------------------
lookup <- createLookup(GADSdat = gads, recodeVars = "stringvar", sort_by = 'value', 
                       addCols = c("new", "new2"))

lookup

## ----lookup export, eval=FALSE--------------------------------------------------------------------
#  # write lookup table to Excel
#  eatAnalysis::write_xlsx(lookup, "lookup_forcedChoice.xlsx")

## ----lookup reimport, eval=FALSE------------------------------------------------------------------
#  # read lookup table back to R
#  lookup <- readxl::read_xlsx("lookup_forcedChoice.xlsx")
#  lookup

## ----fill in values, echo=FALSE-------------------------------------------------------------------
lookup$new <- c("missing", "England", NA, "Germany", "Germany", NA, "Italy")
lookup$new2 <- c("miss", "England", "England", NA, "Germany", "Italy", "Italy")
lookup

## ----collapse the columns-------------------------------------------------------------------------
lookup_formatted <- collapseColumns(lookup = lookup, recodeVars = c("new", "new2"), 
                                    prioritize = "new")
lookup_formatted

## ----integrate the Lookup table-------------------------------------------------------------------
gads_string <- applyLookup(GADSdat = gads, lookup = lookup_formatted, suffix = "_r")

gads_string$dat

## ----collapse the data----------------------------------------------------------------------------
gads_final <- collapseMC_Text(GADSdat = gads_string, mc_var = "mcvar", 
                              text_var = "stringvar_r", mc_code4text = "other", 
                              var_suffix = "_r", label_suffix = "(recoded)")

gads_final$dat
extractMeta(gads_final, "mcvar_r")

## ----checkMissings--------------------------------------------------------------------------------
gads_final <- checkMissings(GADSdat = gads_final, missingLabel = "missing", 
                            addMissingCode = TRUE, addMissingLabel = FALSE)
extractMeta(gads_final, "mcvar_r")

## ----removing unnecessary variables---------------------------------------------------------------
gads_final <- removeVars(GADSdat = gads_final, vars = c("mcvar", "stringvar_r"))
gads_final$dat

## ----setup miss-----------------------------------------------------------------------------------
data_path_miss <- system.file("extdata", "forcedChoice_missings.sav", package = "eatGADS")
gads_miss <- import_spss(data_path_miss)
gads_miss <- recode2NA(gads_miss, value = "")

# Show example data set
gads_miss

## ----missing treatment----------------------------------------------------------------------------
# summarize numerical, labeled variable and character variable
gads <- collapseMC_Text(gads_miss, "mc", "string", mc_code4text = "other", "_r", "recoded")
gads$dat

