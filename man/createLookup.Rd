% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createLookup.R
\name{createLookup}
\alias{createLookup}
\title{Extract values for recoding.}
\usage{
createLookup(GADSdat, recodeVars, sort_by = NULL, addCols = c("value_new"))
}
\arguments{
\item{GADSdat}{A \code{GADSdat} object.}

\item{recodeVars}{Character vector of variable names which should be recoded.}

\item{sort_by}{By which column (\code{variable} and/or \code{value}) should the long format \code{data.frame} be sorted? If \code{NULL}, no sorting is performed.}

\item{addCols}{Character vector of additional column names for recoding purposes.}
}
\value{
Returns a data frame in long format with the following variables:
\item{variable}{Variables as specified in \code{recodeVars}}
\item{value}{Unique values of the variables specified in \code{recodeVars}}
\item{value_new}{This is the default for \code{addCols}. If different additional column names are supplied, this column is missing.}
}
\description{
Extract unique values from one or multiple variables of a \code{GADSdat} object for recoding (e.g. via an Excel spreadsheet).
}
\details{
If recoding of one or multiple variables is more complex, a lookup table can be created for later application via
\code{\link{applyLookup}} or \code{\link{applyLookup_expandVar}}. The function allows the extraction of the values
of multiple variables and sorting of these unique values via \code{variable} and/or \code{values}.
If \code{addCols} are specified the lookup table has to be formatted via \code{\link{collapseColumns}},
before it can be applied to recode data.
}
\examples{
# create example GADS
dat <- data.frame(ID = 1:4, var1 = c(NA, "Eng", "Aus", "Aus2"),
                  var2 = c(NA, "French", "Ger", "Ita"),
                  stringsAsFactors = FALSE)
gads <- import_DF(dat)

# create Lookup table for recoding
lookup <- createLookup(gads, recodeVars = c("var1", "var2"), sort_by = c("value", "variable"))

# create Lookup table for recoding by multiple recoders
lookup2 <- createLookup(gads, recodeVars = c("var1", "var2"), sort_by = c("value", "variable"),
                        addCols = c("value_recoder1", "value_recoder2"))

}
