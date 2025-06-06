% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inspectMetaDifferences.R
\name{inspectMetaDifferences}
\alias{inspectMetaDifferences}
\title{Inspect meta data differences in a variable.}
\usage{
inspectMetaDifferences(
  GADSdat,
  varName,
  other_GADSdat = GADSdat,
  other_varName = varName
)
}
\arguments{
\item{GADSdat}{A \code{GADSdat} object.}

\item{varName}{A character vector of length 1 containing the variable name.}

\item{other_GADSdat}{A second \code{GADSdat} object. If omitted, it is assumed that both variables are part of the
first \code{GADSdat}.}

\item{other_varName}{A character vector of length 1 containing the other variable name.
If omitted, it is assumed that both variables have identical names (as supplied in \code{varName}).}
}
\value{
A list.
}
\description{
Inspect meta data differences within a single \code{GADSdat} or between two \code{GADSdat} objects
or \code{GADSdat} data bases regarding a specific variable.
}
\details{
Two \code{GADSdat} objects can be compared using \code{\link{equalGADS}}.
If meta data differences for specific variables in the two objects occur,
these variables can be further inspected using \code{inspectMetaDifferences}.
For data-level differences for a specific variable, see \code{\link{inspectDifferences}}.
}
\examples{
# create a second GADS with different meta data
pisa2 <- pisa
pisa2 <- changeVarLabels(pisa2, varName = "sameteach", varLabel = "Same math teacher")
pisa2 <- recodeGADS(pisa2, varName = "sameteach", oldValues = c(1, 2), newValues = c(0, 1))

# inspect via equalGADS()
equalGADS(pisa, pisa2)

# inspect via inspectMetaDifferences()
inspectMetaDifferences(GADSdat = pisa, varName = "sameteach", other_GADSdat = pisa2)

}
