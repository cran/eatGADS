## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(eatGADS)

## ----import spss--------------------------------------------------------------
sav_path <- system.file("extdata", "pisa.zsav", package = "eatGADS")
gads_obj <- import_spss(sav_path)

## ----class--------------------------------------------------------------------
class(gads_obj)
names(gads_obj)

## ----names_and_meta-----------------------------------------------------------
namesGADS(gads_obj)
extractMeta(gads_obj, vars = c("schtype", "idschool"))

## ----extractdata--------------------------------------------------------------
## convert labeled variables to characters
dat1 <- extractData(gads_obj, convertLabels = "character")
dat1[1:5, 1:10]

## leave labeled variables as numeric
dat2 <- extractData(gads_obj, convertLabels = "numeric")
dat2[1:5, 1:10]

## leave labeled variables as numeric but convert some variables to character
dat3 <- extractData(gads_obj, convertLabels = "character", 
                    convertVariables = c("gender", "language"))
dat3[1:5, 1:10]

