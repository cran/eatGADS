% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getChangeMeta.R
\name{getChangeMeta}
\alias{getChangeMeta}
\title{Extract table for Meta Data Changes.}
\usage{
getChangeMeta(GADSdat, level = "variable")
}
\arguments{
\item{GADSdat}{\code{GADSdat} object imported via \code{eatGADS}.}

\item{level}{\code{'variable'} or \code{'value'}.}
}
\value{
Returns the meta data sheet for all variables including the corresponding change columns.
}
\description{
Function to obtain a data frame from a \code{GADSdat} object for for changes to meta data on variable or on value level.
}
\details{
Changes on variable level include variable names (\code{varName}), variable labels (\code{varLabel}),
SPSS format ((\code{format})) and display width (\code{display_width}).
Changes on value level include values (\code{value}), value labels (\code{valLabel}) and
missing codes (\code{missings}).
}
\examples{
# For changes on variable level
varChangeTable <- getChangeMeta(pisa, level = "variable")

# For changes on value level
valChangeTable <- getChangeMeta(pisa, level = "value")

}
