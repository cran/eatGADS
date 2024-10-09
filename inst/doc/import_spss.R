## ----include = FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup----------------------------------------------------------------------------------------
library(eatGADS)

## ----import spss----------------------------------------------------------------------------------
sav_path <- system.file("extdata", "pisa.zsav", package = "eatGADS")
gads_obj <- import_spss(sav_path)

## ----class----------------------------------------------------------------------------------------
class(gads_obj)
names(gads_obj)

## ----names_and_meta-------------------------------------------------------------------------------
namesGADS(gads_obj)
extractMeta(gads_obj, vars = c("schtype", "idschool"))

## ----extractdata----------------------------------------------------------------------------------
## convert all labeled variables to character
dat1 <- extractData2(gads_obj, labels2character = namesGADS(gads_obj))
dat1[1:5, 1:10]

## leave labeled variables as numeric
dat2 <- extractData2(gads_obj)
dat2[1:5, 1:10]

## leave labeled variables as numeric but convert some variables to character and some to factor
dat3 <- extractData2(gads_obj, labels2character = c("gender", "language"),
                     labels2factor = c("schtype", "sameteach"))
dat3[1:5, 1:10]

