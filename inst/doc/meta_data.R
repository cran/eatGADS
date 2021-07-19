## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----meta raw, echo = FALSE-----------------------------------------------------------------------
options(width = 100)
library(eatGADS)
gads <- pisa
extractMeta(gads, vars = c("gender"))

## ----setup, eval = FALSE--------------------------------------------------------------------------
#  library(eatGADS)
#  gads <- pisa

## ----overview-------------------------------------------------------------------------------------
extractMeta(gads, vars = c("hisei", "schtype"))

## ----names----------------------------------------------------------------------------------------
# Changing variable names
extractMeta(gads, vars = "hisei")
gads_labeled <- changeVarNames(GADSdat = gads, oldNames = "hisei", newNames = "hisei_new")
extractMeta(gads_labeled, vars = "hisei_new")

## ----varlabels------------------------------------------------------------------------------------
# Changing variable labels 
extractMeta(gads_labeled, vars = "hisei_new")
gads_labeled <- changeVarLabels(GADSdat = gads_labeled, varName = "hisei_new", 
                                varLabel = "Parental occupational status (highest)")
extractMeta(gads_labeled, vars = "hisei_new")

## ----format---------------------------------------------------------------------------------------
# Changing SPSS format
extractMeta(gads_labeled, "hisei_new")
gads_labeled <- changeSPSSformat(GADSdat = gads_labeled, varName = "hisei_new", 
                                 format = "F10.2")
extractMeta(gads_labeled, "hisei_new")

## ----vallabels------------------------------------------------------------------------------------
# Adding value labels
extractMeta(gads_labeled, "hisei_new")
gads_labeled <- changeValLabels(GADSdat = gads_labeled, varName = "hisei_new", 
                                value = c(-94, -99), valLabel = c("miss1", "miss2"))
extractMeta(gads_labeled, "hisei_new")

# Changing value labels
gads_labeled <- changeValLabels(GADSdat = gads_labeled, varName = "hisei_new", 
                                value = c(-94, -99), 
                                valLabel = c("missing: Question omitted",
                                             "missing: Not administered"))
extractMeta(gads_labeled, "hisei_new")

## ----remove---------------------------------------------------------------------------------------
# Removing value labels
extractMeta(gads_labeled, "schtype")
gads_labeled <- removeValLabels(GADSdat = gads_labeled, varName = "schtype", 
                                value = 1:3)
extractMeta(gads_labeled, "schtype")

## ----missings-------------------------------------------------------------------------------------
# Defining missings
extractMeta(gads_labeled, "hisei_new")
gads_labeled <- changeMissings(GADSdat = gads_labeled, varName = "hisei_new", 
                               value = c(-94, -99), missings = c("miss", "miss"))
extractMeta(gads_labeled, "hisei_new")

## ----checkMissings--------------------------------------------------------------------------------
# Creating a new value label for a missing value but leaving the missing code as valid
gads_labeled <- changeValLabels(GADSdat = gads_labeled, varName = "gender", 
                                value = -94, valLabel = "missing: Question omitted")
# Creating a new missing code but leaving the value label empty
gads_labeled <- changeMissings(GADSdat = gads_labeled, varName = "gender", 
                                value = -99, missings = "miss")

# Checking value label and missing code allignment
gads_labeled <- checkMissings(gads_labeled, missingLabel = "missing") 

## ----reuse----------------------------------------------------------------------------------------
extractMeta(gads_labeled, "age")
gads_labeled <- reuseMeta(GADSdat = gads_labeled, varName = "age",
                          other_GADSdat = gads_labeled, other_varName = "hisei_new",
                          missingLabels = "only", addValueLabels = TRUE)
extractMeta(gads_labeled, "age")

## ----select---------------------------------------------------------------------------------------
# Selecting variables
gads_motint <- extractVars(gads_labeled, 
                           vars = c("int_a", "int_b", "int_c", "int_d", "instmot_a"))
namesGADS(gads_motint)

gads_int <- removeVars(gads_motint, vars = "instmot_a") 
namesGADS(gads_int)

## ----recoding-------------------------------------------------------------------------------------
# Original data and meta data
gads_labeled$dat$gender[1:10]
extractMeta(gads_labeled, "gender")
# Recoding 
gads_labeled <- recodeGADS(GADSdat = gads_labeled, varName = "gender", 
                           oldValues = c(1, 2), newValues = c(10, 20))
# New data and meta data
gads_labeled$dat$gender[1:10]
extractMeta(gads_labeled, "gender")

## ----recoding old NA------------------------------------------------------------------------------
# Recoding of NA values 
gads_labeled$dat$int_a[1:10]
gads_labeled <- recodeGADS(GADSdat = gads_labeled, varName = "int_a", 
                           oldValues = NA, newValues = -94)
gads_labeled$dat$int_a[1:10]

## ----recode2NA------------------------------------------------------------------------------------
# Recoding of values as Missing/NA
gads_labeled$dat$schtype[1:10]
gads_labeled <- recode2NA(gads_labeled, recodeVars = c("hisei_new", "schtype"), 
                          value = "3")
gads_labeled$dat$schtype[1:10]

## ----add variables--------------------------------------------------------------------------------
# Extract the data
newDat <- gads_labeled$dat
# Adding a variable
newDat$classsize_kat <- ifelse(newDat$classsize > 15, 
                                         yes = "big", no = "small") 
# Updating meta data
gads_labeled2 <- updateMeta(gads_labeled, newDat = newDat)
extractMeta(gads_labeled2, "classsize_kat")

## ----getChangeMeta--------------------------------------------------------------------------------
# variable level
meta_var <- getChangeMeta(GADSdat = pisa, level = "variable")

## ----write excel var, eval = FALSE----------------------------------------------------------------
#  # write to excel
#  eatAnalysis::write_xlsx(meta_var, row.names = FALSE, "variable_changes.xlsx")

## ----read excel var, eval = FALSE-----------------------------------------------------------------
#  # write to excel
#  meta_var_changed <- readxl::read_excel("variable_changes.xlsx", col_types = rep("text", 8))

## ----var changes under the hood, eval = TRUE, echo = FALSE, results='hide'------------------------
meta_var_changed <- meta_var
meta_var_changed[4, "varName_new"] <- "schoolType"
meta_var_changed[1, "varLabel_new"] <- "Student Identifier Variable"
meta_var_changed[2, "format_new"] <- "F10.0"

## ----applyChangeMeta------------------------------------------------------------------------------
gads2 <- applyChangeMeta(meta_var_changed, GADSdat = pisa)
extractMeta(gads2, vars = c("idstud", "idschool", "schoolType"))

## ----valuelevel-----------------------------------------------------------------------------------
# value level
meta_val <- getChangeMeta(GADSdat = pisa, level = "value")

## ----write excel val, eval = FALSE----------------------------------------------------------------
#  # write to excel
#  eatAnalysis::write_xlsx(meta_val, row.names = FALSE, "value_changes.xlsx")

## ----read excel val, eval = FALSE-----------------------------------------------------------------
#  # write to excel
#  meta_val_changed <- readxl::read_excel("value_changes.xlsx",
#                                         col_types = c("text", rep(c("numeric", "text", "text"), 2)))

## ----val changes under the hood, eval = TRUE, echo = FALSE, results='hide'------------------------
meta_val_changed <- meta_val
meta_val_changed[4, "valLabel_new"] <- "Acamedic Track"
meta_val_changed[7:8, "value_new"] <- c(10, 20)

## ----applyvalue-----------------------------------------------------------------------------------
gads3 <- applyChangeMeta(meta_val_changed, GADSdat = pisa)
extractMeta(gads3, vars = c("schtype", "sameteach"))

