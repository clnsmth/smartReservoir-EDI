
# An example script demonstrating automated updates of data package edi_275
#
# The following tasks are performed by this script:
# 1. Identify newest model output file
# 2. Extract temporal attributes of newest file
# 3. Update the EML metadata file for the newest model output
# 4. Update edi_275 in EDI




# Parameterize this workflow --------------------------------------------------

# Identifier of EDI data package to update (e.g. 'edi.151'). Don't include a 
# revision number, one is automatically prescribed later. NOTE: A prior version 
# of this data package must exist in the EDI Data Repository. This is a 
# "revision" after all :) ... To upload the initial version of a data package, 
# use the EDI Data Portal https://portal.edirepository.org/nis/home.jsp) or 
# replace the EDIutils::api_update_data_package function (~ line 301) with 
# EDIutils::api_create_data_package

package.id <- 'edi.275'

# Name of project server that will be appended to user.serv (e.g. server.name = @some.server.org)

server.name <- '@regan.edirepository.org' 

# Path to data package edi_151 files on project server

server.path <- '/data/edi_275'




# Begin workflow --------------------------------------------------------------

# Messages are used throughout this script to report on workflow status.

message(paste0('UPDATING DATA PACKAGE ', package.id))

# Enter user name, password, and affiliation for your EDI user account

pasta.user.name <- readline('Enter EDI user name: ')
pasta.user.pass <- readline('Enter EDI user password: ')
pasta.affiliation <- readline('Enter EDI user affiliation (LTER or EDI): ')

# Environment of EDI Data Repository to create the revision in.

pasta.environment <- 'staging'




# Extract metadata elements to update -----------------------------------------

new_file_name <- 'test_H_2018710_2018711_F_16_2019125_12_47_EDI.nc'

new_file_description <- 'place holder'

forecast_period <- 'place holder'

new_temporal_coverage <- c(
  '2019-01-01',
  '2019-01-02'
)




# Update the EML metadata file for the aggregated data ------------------------

# Get new package revision number. Check the EDI Repository for the most recent
# revision number and add 1.

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

# Create EML metadata file

EMLassemblyline::make_eml(
  path = paste0(server.path,'/metadata_templates'),
  data.path = paste0(server.path,'/data'),
  eml.path = paste0(server.path,'/eml'),
  dataset.title = paste0('Smart Reservoir Forecast (', forecast_period, ')'),
  other.entity = new_file_name,
  other.entity.description = new_file_description,
  data.files.url = paste0(server.path,'/data'),
  temporal.coverage = new_temporal_coverage,
  geographic.coordinates = c('37.309589', '-79.836009', '37.30266', '-79.839249'),
  geographic.description = 'Falling Creek Reservoir is located in Vinton, Virginia, USA',
  maintenance.description = 'Ongoing',
  user.id = c('smartreservoir', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = new_package_id
)




# Upload the new EML file and aggregated data to EDI --------------------------

EDIutils::api_update_data_package(
  path = paste0(
    server.path,
    '/eml/', 
    new_package_id, 
    '.xml'
  ),
  package.id = new_package_id,
  environment = pasta.environment,
  user.id = pasta.user.name,
  user.pass = pasta.user.pass,
  affiliation = pasta.affiliation
)
