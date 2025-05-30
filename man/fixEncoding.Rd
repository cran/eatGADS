% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fixEncoding.R
\name{fixEncoding}
\alias{fixEncoding}
\title{Remove special characters.}
\usage{
fixEncoding(x, input = c("other", "ASCII", "windows1250", "BRISE"))
}
\arguments{
\item{x}{A character vector or \code{GADSdat} object.}

\item{input}{Which encoding was used in \code{\link{import_spss}}.}
}
\value{
The modified character vector or \code{GADSdat} object.
}
\description{
Remove special characters from a character vector or a \code{GADSdat} object.
Also suitable to fix encoding problems of a character vector or a \code{GADSdat} object. See details for available options.
}
\details{
The option \code{"other"} replaces correctly encoded special signs.
The option \code{"ASCII"} works for strings which were encoded presumably using \code{UTF-8} and imported using \code{ASCII} encoding.
The option \code{"windows1250"} works for strings which were encoded presumably using \code{UTF-8}
and imported using \code{windows-1250} encoding.
The option \code{"BRISE"} covers a unique case used at the \code{FDZ at IQB}.

If entries are all upper case, special characters are also transformed to all upper case (e.g., \code{"AE"} instead
of \code{"Ae"}).
}
\examples{
fixEncoding(c("\U00C4pfel", "\U00C4PFEL", paste0("\U00DC", "ben"), paste0("\U00DC", "BEN")))

}
