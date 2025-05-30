% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inspectDifferences.R
\name{inspectDifferences}
\alias{inspectDifferences}
\title{Inspect differences in a variable.}
\usage{
inspectDifferences(
  GADSdat,
  varName,
  other_GADSdat = GADSdat,
  other_varName = varName,
  id
)
}
\arguments{
\item{GADSdat}{A \code{GADSdat} object.}

\item{varName}{A character vector of length 1 containing the variable name.}

\item{other_GADSdat}{A second \code{GADSdat} object. If omitted, it is assumed that both variables are part of the
first \code{GADSdat}.}

\item{other_varName}{A character vector of length 1 containing the other variable name.
If omitted, it is assumed that both variables have identical names (as supplied in \code{varName}).}

\item{id}{A character vector of length 1 containing the unique identifier column of both \code{GADSdat}.}
}
\value{
A list.
}
\description{
Inspect differences within a single \code{GADSdat} or between two \code{GADSdat} objects for a specific variable.
}
\details{
Two \code{GADSdat} objects can be compared using \code{\link{equalGADS}}.
If differences in the data for specific variables in the two objects occur,
these variables can be further inspected using \code{inspectDifferences}.
Differences on meta data-level can be inspected via \code{\link{inspectMetaDifferences}}.
}
\examples{
# create a second GADS with different data
pisa2 <- pisa
pisa2$dat$age[400:nrow(pisa$dat)] <- sample(pisa2$dat$age[400:nrow(pisa$dat)])

# inspect via equalGADS()
equalGADS(pisa, pisa2)

# inspect via inspectDifferences()
inspectDifferences(GADSdat = pisa, varName = "age", other_GADSdat = pisa2, id = "idstud")

}
