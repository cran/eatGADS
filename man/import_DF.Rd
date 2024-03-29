% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_DF.R
\name{import_DF}
\alias{import_DF}
\title{Import R \code{data.frame}}
\usage{
import_DF(df, checkVarNames = TRUE)
}
\arguments{
\item{df}{A \code{data.frame}.}

\item{checkVarNames}{Should variable names be checked for violations of \code{SQLite} and \code{R} naming rules?}
}
\value{
Returns a list with the actual data \code{dat} and a data frame with all meta information in long format \code{labels}.
}
\description{
Function to import a \code{data.frame} object for use in \code{eatGADS} while extracting value labels from factors.
}
\details{
Factors are integers with labeled variable levels. \code{import_DF} extracts these labels and stores them in a separate meta data data.frame.
See \code{\link{import_spss}} for detailed information.
}
\examples{
dat <- import_DF(iris, checkVarNames = FALSE)

# Inspect Meta data
extractMeta(dat)

# Extract Data
dat <- extractData(dat, convertLabels = "character")

}
