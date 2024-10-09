## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(eatGADS)

## ----import spss--------------------------------------------------------------
sav_path <- system.file("extdata", "pisa.zsav", package = "eatGADS")
dat <- import_spss(sav_path)

## ----split GADS---------------------------------------------------------------
pvs <- grep("pv", namesGADS(dat), value = T)
splitted_gads <- splitGADS(dat, nameList = list(noImp = namesGADS(dat)[!namesGADS(dat) %in% pvs],
                    PVs = c("idstud", pvs)))
# new Structure
namesGADS(splitted_gads)

# Extract GADSdat objects
noImp_gads <- extractGADSdat(splitted_gads, "noImp")
pvs_gads <- extractGADSdat(splitted_gads, "PVs")

## ----reshape PVs--------------------------------------------------------------
# Extract raw data from pv gads
pvs_wide <- pvs_gads$dat

# Wide format
head(pvs_wide)

pvs_long1 <- tidyr::pivot_longer(pvs_wide, cols = all_of(pvs))
pvs_long2 <- tidyr::separate(pvs_long1, col = "name", sep = "_", into = c("dimension", "imp"))
pvs_long2$imp <- as.numeric(gsub("pv", "", pvs_long2$imp))

# Finale long format
head(as.data.frame(pvs_long2))

## ----updateMeta---------------------------------------------------------------
pvs_gads2 <- updateMeta(pvs_gads, newDat = as.data.frame(pvs_long2))
extractMeta(pvs_gads2)

# 
pvs_gads2 <- changeVarLabels(pvs_gads2, varName = c("dimension", "imp", "value"),
                varLabel = c("Achievement dimension (math, reading, science)",
                             "Number of imputation of plausible values",
                             "Plausible Value"))
extractMeta(pvs_gads2)

## ----prepare data base--------------------------------------------------------
merged_gads <- mergeLabels(noImp = noImp_gads, PVs = pvs_gads2)

pkList <- list(noImp = "idstud",
               PVs = c("idstud", "imp", "dimension"))
fkList <- list(noImp = list(References = NULL, Keys = NULL),
               PVs = list(References = "noImp", Keys = "idstud"))

## ----create data base---------------------------------------------------------
temp_path <- paste0(tempfile(), ".db")

createGADS(merged_gads, pkList = pkList, fkList = fkList,
           filePath = temp_path)

