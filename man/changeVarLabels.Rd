% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/changeVarLabels.R
\name{changeVarLabels}
\alias{changeVarLabels}
\title{Change the variable label.}
\usage{
changeVarLabels(GADSdat, varName, varLabel)
}
\arguments{
\item{GADSdat}{\code{GADSdat} object imported via \code{eatGADS}.}

\item{varName}{Character string of variable names.}

\item{varLabel}{Character string of the new variable labels.}
}
\value{
Returns the \code{GADSdat} object with changed meta data.
}
\description{
Change the variable label of a variable as part of a \code{GADSdat} or \code{all_GADSdat} object.
}
\details{
Applied to a \code{GADSdat} or \code{all_GADSdat} object, this function is a wrapper of \code{\link{getChangeMeta}} and
\code{\link{applyChangeMeta}}.
}
\examples{
# Change one variable label
pisa2 <- changeVarLabels(pisa, varName = "repeated",
                        varLabel = c("Has a grade been repeated?"))

}
