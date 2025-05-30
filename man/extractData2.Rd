% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extractData2.R
\name{extractData2}
\alias{extractData2}
\title{Extract Data 2}
\usage{
extractData2(
  GADSdat,
  convertMiss = TRUE,
  labels2character = NULL,
  labels2factor = NULL,
  labels2ordered = NULL,
  dropPartialLabels = TRUE
)
}
\arguments{
\item{GADSdat}{A \code{GADSdat} object.}

\item{convertMiss}{Should values tagged as missing values be recoded to \code{NA}?}

\item{labels2character}{For which variables should values be recoded to their labels? The resulting variables
are of type \code{character}.}

\item{labels2factor}{For which variables should values be recoded to their labels? The resulting variables
are of type \code{factor}.}

\item{labels2ordered}{For which variables should values be recoded to their labels? The resulting variables
are of type \code{ordered}.}

\item{dropPartialLabels}{Should value labels for partially labeled variables be dropped?
If \code{TRUE}, the partial labels will be dropped. If \code{FALSE}, the variable will be converted
to the class specified in \code{labels2character}, \code{labels2factor}, or \code{labels2ordered}.}
}
\value{
Returns a data frame.
}
\description{
Extract \code{data.frame} from a \code{GADSdat} object for analyses in \code{R}. Per default, missing codes are applied but
value labels are dropped. Alternatively, value labels can be selectively applied via
\code{labels2character}, \code{labels2factor}, and \code{labels2ordered}.
For extracting meta data see \code{\link{extractMeta}}.
}
\details{
A \code{GADSdat} object includes actual data (\code{GADSdat$dat}) and the corresponding meta data information
(\code{GADSdat$labels}). \code{extractData2} extracts the data and applies relevant meta data on value level
(missing tags, value labels),
so the data can be used for analyses in \code{R}. Variable labels are retained as \code{label} attributes on column level.

If \code{factor} are extracted via \code{labels2factor} or \code{labels2ordered}, an attempt is made to preserve the underlying integers.
If this is not possible, a warning is issued.
As \code{SPSS} has almost no limitations regarding the underlying values of labeled
integers and \code{R}'s \code{factor} format is very strict (no \code{0}, only integers increasing by \code{+ 1}),
this procedure can lead to frequent problems.

If multiple values of the same variable are assigned the same value label and the variable should be transformed to
\code{character}, \code{factor}, or \code{ordered}, a warning is issued and the transformation is correctly performed.
}
\examples{
# Extract Data for Analysis
dat <- extractData2(pisa)

# convert only some variables to character, all others remain numeric
dat <- extractData2(pisa, labels2character = c("schtype", "ganztag"))

# convert only some variables to factor, all others remain numeric
dat <- extractData2(pisa, labels2factor = c("schtype", "ganztag"))

# convert all labeled variables to factors
dat <- extractData2(pisa, labels2factor = namesGADS(pisa))

# convert somme variables to factor, some to character
dat <- extractData2(pisa, labels2character = c("schtype", "ganztag"),
                          labels2factor = c("migration"))

}
