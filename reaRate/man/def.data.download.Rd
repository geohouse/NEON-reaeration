% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/def.data.download.R
\name{def.data.download}
\alias{def.data.download}
\title{Formats reaeration data for rate calculations}
\usage{
def.data.download(
  dataDir = paste0(getwd(), "/NEON_reaeration.zip"),
  site = "all",
  fieldQ = TRUE
)
}
\arguments{
\item{dataDir}{User identifies the directory that contains the zipped data or sets to
"API" to pull data from the NEON API [string]}

\item{site}{User identifies the site(s), defaults to "all" [string]}

\item{fieldQ}{specifies whether or not field discharge data should be included [boolean]}
}
\value{
This function returns one data frame formatted for use with def.format.reaeration.R
}
\description{
This function downloads and stacks the data by table in preparation
for other downstream functions
}
\examples{
#where the data .zip file is in the working directory and has the default name,
#reaFormatted <- def.format.reaeration()
#where the data.zip file is in the downloads folder and has default name,
#reaFormatted <-
#def.format.reaeration(dataDir = path.expand("~/Downloads/NEON_reaeration.zip"))
#where the data.zip file is in the downloads folder and has a specified name,
#reaFormatted <- def.format.reaeration(dataDir = path.expand("~/Downloads/non-standard-name.zip"))
#Using the example data in this package
#dataDirectory <- paste(path.package("reaRate"),"inst\\extdata", sep = "\\")
#reaFormatted <- def.format.reaeration(dataDir = dataDirectory)
}
\references{
License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007
}
\seealso{
def.calc.tracerTime.R for calculating the stream travel time,
def.plot.reaQcurve.R for plotting reaeration rate versus stream flow
}
\author{
Kaelin M. Cawley \email{kcawley@battelleecology.org} \cr
}
\keyword{gas}
\keyword{number}
\keyword{reaeration,}
\keyword{rivers,}
\keyword{schmidt}
\keyword{streams,}
\keyword{surface}
\keyword{transfer}
\keyword{velocity,}
\keyword{water,}
