# Install dependencies for 'update_edi_275.R'

# CRAN libraries

install.packages('devtools')
install.packages('EML')
install.packages('stringr')
install.packages('stringi')
install.packages('reader')
install.packages('readr')
install.packages('xml2')
install.packages('httr')
install.packages('knitr')
install.packages('rmarkdown')

# GitHub libraries

library(devtools)
devtools::install_github('EDIorg/EDIutils')
devtools::install_github('clnsmth/EMLassemblyline') # Use the development version for now
