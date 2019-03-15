# edi_275

Example configuration of this workflow using `Ubuntu Server 18.04`:

* Copy `edi_275` to the server.
* Set read permissions to public for files in `/edi_275/data` and `/edi_275/EML`.
* Install Ubuntu dependencies listed in `/edi_275/scripts/install_ubuntu_dependencies.md`.
* Install base R on the server with read and write access to `/edi_275`.
* Install R package dependencies listed in `/edi_275/scripts/install_r_dependencies.R`.
* Edit the workflow parameters of `/edi_275/scripts/update_edi_275.R` for your specific configuration.
* Execute `edi_275/scripts/update_edi_275.R` from the servers R environment to see the workflow in action.

### Contents

* __/data__ Data to be archived
* __/EML__ EML metadata files output by the `EMLassemblyline` R package
* __/metadata_templates__ Input files to the `EMLassemblyline` R package
* __/scripts__ Scripts to execute this workflow
