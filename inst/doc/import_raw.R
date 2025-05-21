## ----include = FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----installation, eval = FALSE-------------------------------------------------------------------
# devtools::install_github("beckerbenj/eatGADS")

## ----library, message = FALSE---------------------------------------------------------------------
# loading the package
library(eatGADS)

## ----import_spss, eval = FALSE--------------------------------------------------------------------
# # importing an SPSS file
# gads <- import_spss("path/example.sav")

## ----import data into r, eval = FALSE-------------------------------------------------------------
# # importing text files
# input_txt <- read.table("path/example.txt", stringsAsFactors = FALSE)
# # importing German csv files (; separated)
# input_csv <- read.csv2("path/example.csv", stringsAsFactors = FALSE)
# # importing Excel files
# input_xlsx <- readxl::read_excel("path/example.xlsx")

## ----import_raw-----------------------------------------------------------------------------------
# Example data set
df <- data.frame(ID = 1:4, sex = c(0, 0, 1, 1), 
                 forename = c("Tim", "Bill", "Ann", "Chris"), stringsAsFactors = FALSE)
# Example variable labels
varLabels <- data.frame(varName = c("ID", "sex", "forename"), 
                        varLabel = c("Person Identifier", "Sex as self reported", 
                                     "first name as reported by teacher"), 
                        stringsAsFactors = FALSE)
# Example value labels
valLabels <- data.frame(varName = rep("sex", 3), 
                        value = c(0, 1, -99), 
                        valLabel = c("male", "female", "missing - omission"), 
                        missings = c("valid", "valid", "miss"), stringsAsFactors = FALSE)

df
varLabels
valLabels

# import 
gads <- import_raw(df = df, varLabels = varLabels, valLabels = valLabels)

## ----print gads-----------------------------------------------------------------------------------
# Inpsect resulting object 
gads 

## ----save gads, eval = FALSE----------------------------------------------------------------------
# # Inpsect resulting object
# saveRDS(gads, "path/gads.RDS")

## ----extractMeta----------------------------------------------------------------------------------
# Inpsect resulting object 
extractMeta(gads, vars = c("sex"))
extractMeta(gads)

## ----extractData, message = FALSE-----------------------------------------------------------------
# Extract data without applying labels
dat1 <- extractData(gads, convertMiss = TRUE, convertLabels = "numeric")
dat1

dat2 <- extractData(gads, convertMiss = TRUE, convertLabels = "character")
dat2


## ----modify wrappers------------------------------------------------------------------------------
### wrapper functions
# Modify variable labels
gads2 <- changeVarLabels(gads, varName = c("ID"), varLabel = c("Test taker ID"))
extractMeta(gads2, vars = "ID")

# Modify variable name
gads3 <- changeVarNames(gads, oldNames = c("ID"), newNames = c("idstud"))
extractMeta(gads3, vars = "idstud")
extractData(gads3)

# recode GADS
gads4 <- recodeGADS(gads, varName = "sex", oldValues = c(0, 1, -99), newValues = c(1, 2, 99))
extractMeta(gads4, vars = "sex")
extractData(gads4, convertLabels = "numeric")


## ----modify changeTable---------------------------------------------------------------------------
# extract changeTable
varChanges <- getChangeMeta(gads, level = "variable")
# modify changeTable
varChanges[varChanges$varName == "ID", "varLabel_new"] <- "Test taker ID"
# Apply changes
gads5 <- applyChangeMeta(varChanges, gads)
extractMeta(gads5, vars = "ID")

## ----write spss, eval = FALSE---------------------------------------------------------------------
# write_spss(gads, "path/example_out.sav")

## ----export to haven, eval = TRUE-----------------------------------------------------------------
haven_dat <- export_tibble(gads)
haven_dat
lapply(haven_dat, attributes)

