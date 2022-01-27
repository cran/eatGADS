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

## ----trendPaths---------------------------------------------------------------
trend_path1 <- system.file("extdata", "trend_gads_2020.db", package = "eatGADS")
trend_path2 <- system.file("extdata", "trend_gads_2015.db", package = "eatGADS")
trend_path3 <- system.file("extdata", "trend_gads_2010.db", package = "eatGADS")

## ----getTrendGADS-------------------------------------------------------------
gads_trend <- getTrendGADS(filePaths = c(trend_path1, trend_path2, trend_path3), 
                           vSelect = c("idstud", "dimension", "score"), 
                           years = c(2020, 2015, 2010), fast = FALSE)
dat_trend <- extractData(gads_trend)
head(dat_trend)

