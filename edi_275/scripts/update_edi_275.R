
# This script demonstrates automated updates of an EDI data package (edi.275)
#
# The following tasks are performed by this script:
# 1. Identify newest data file
# 2. Extract temporal attributes from the newest data file
# 3. Update the EML metadata for the newest data file
# 4. Upload the revised data and metadata to EDI




# Parameterize this workflow --------------------------------------------------

# Load dependencies

library(EMLassemblyline)
library(EML)
library(stringr)
library(stringi)
library(reader)
library(readr)
library(xml2)
library(httr)
library(knitr)
library(rmarkdown)
library(EDIutils)

# Identifier of EDI data package to update (e.g. 'edi.275'). Don't include a 
# revision number, one is automatically prescribed later. NOTE: A prior version 
# of this data package must exist in the EDI Data Repository. This is a 
# "revision" after all :) ... To upload the initial version of a data package, 
# use the EDI Data Portal https://portal.edirepository.org/nis/home.jsp) or 
# replace the EDIutils::api_update_data_package function (~ line 301) with 
# EDIutils::api_create_data_package

package.id <- 'edi.275'

# Path to server hosted directories 'data', 'eml', 'metadata_template', and '
# scripts'

server.path <- '/home/csmith/data/edi_275'

# Publicly readable URL corresponding to 'server.path'

server.url <- 'https://regan.edirepository.org/data/edi_275'




# Begin workflow --------------------------------------------------------------

# Messages are used throughout this script to report on workflow status.

message(paste0('UPDATING DATA PACKAGE ', package.id))

# Enter user name, password, and affiliation for your EDI user account

pasta.user.name <- readline('Enter EDI user name: ')
pasta.user.pass <- readline('Enter EDI user password: ')
pasta.affiliation <- readline('Enter EDI user affiliation (LTER or EDI): ')

# Environment of EDI Data Repository to create the revision in. Use 'staging'
# for testing, and 'production' for final publications.

pasta.environment <- 'staging'




# Identify new file and extract corresponding metadata ------------------------
# The following variables should be automatically defined.

# Name of new file to archive

new_file_name <- 'test_H_2018710_2018711_F_16_2019125_12_47_EDI.nc'

# Description of new file to archive

new_file_description <- 'place holder'

# Temporal coverage of data to archive

new_temporal_coverage <- c(
  '2019-01-01',
  '2019-01-02'
)

# Text to add to the data package title describing the temporal coverage

forecast_period <- 'place holder'




# Update the EML metadata file for the aggregated data ------------------------

# Get new package revision number. Check the EDI Repository for the most recent
# revision and add 1.

revision <- EDIutils::api_list_data_package_revisions(
  scope = stringr::str_remove(
    package.id,
    '\\.[:digit:]*$'
  ),
  identifier = stringr::str_extract(
    package.id,
    '[:digit:]*$'
  ),
  filter = 'newest',
  environment = pasta.environment
)

revision <- as.character(as.numeric(revision) + 1)

new_package_id <- paste0(package.id, '.', revision)

# Create the EML metadata file

EMLassemblyline::make_eml(
  path = paste0(server.path,'/metadata_templates'),
  data.path = paste0(server.path,'/data'),
  eml.path = paste0(server.path,'/eml'),
  dataset.title = paste0('Smart Reservoir Forecast (', forecast_period, ')'),
  other.entity = new_file_name,
  other.entity.description = new_file_description,
  data.url = paste0(server.url,'/data'),
  temporal.coverage = new_temporal_coverage,
  geographic.coordinates = c('37.309589', '-79.836009', '37.30266', '-79.839249'),
  geographic.description = 'Falling Creek Reservoir is located in Vinton, Virginia, USA',
  maintenance.description = 'Ongoing',
  user.id = c('smartreservoir', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = new_package_id
)




# Upload the new data and EML to EDI ------------------------------------------

message('Uploading to EDI')

EDIutils::api_update_data_package(
  path = paste0(
    server.path,
    '/eml'
  ),
  package.id = new_package_id,
  environment = pasta.environment,
  user.id = pasta.user.name,
  user.pass = pasta.user.pass,
  affiliation = pasta.affiliation
)
