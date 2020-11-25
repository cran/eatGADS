## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(eatGADS)
db_path <- system.file("extdata", "pisa.db", package = "eatGADS")
db_path

## ----structure----------------------------------------------------------------
nam <- namesGADS(db_path)
nam

## ----extractMeta--------------------------------------------------------------
# Meta data for one variable
extractMeta(db_path, "age")

## ----extractMeta all----------------------------------------------------------
extractMeta(db_path, nam$PVs)

## ----extractMeta description--------------------------------------------------
# Meta data for manually chosen multiple variables
extractMeta(db_path, c("idstud", "schtype"))

## ----getGADS------------------------------------------------------------------
gads1 <- getGADS(filePath = db_path, vSelect = c("idstud", "schtype"))
class(gads1)
extractMeta(gads1)

## ----extractdata--------------------------------------------------------------
## convert labeled variables to characters
dat1 <- extractData(gads1, convertLabels = "character")
head(dat1)

## leave labeled variables as numeric
dat2 <- extractData(gads1, convertLabels = "numeric")
head(dat2)

## ----noImp hierarchy levels---------------------------------------------------
gads1 <- getGADS(db_path, vSelect = c("schtype", "g8g9"))
dat1 <- extractData(gads1)
dim(dat1)
head(dat1)

## ----PVs hierarchy levels-----------------------------------------------------
gads2 <- getGADS(db_path, vSelect = c("schtype", "value"))
dat2 <- extractData(gads2)
dim(dat2)
head(dat2)

## ----getTrendGADS, eval=FALSE-------------------------------------------------
#  gads_trend <- getTrendGADS(filePath1 = db_path,
#                             filePath2 = db_path2,
#                             lePath = le_path,
#                             vSelect = c("idstud", "schtype"),
#                             years = c(2012, 2013), fast = FALSE)
#  dat_trend <- extractData(gads_trend)

