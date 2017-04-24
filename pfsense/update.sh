#!/bin/bash
#
# Script to refresh Ubuntu images
# - This script downloads specified Ubuntu ISO images
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="pfSense";
SUBTITLE="pfsense";
## Mirror Definition - http://nyifiles.pfsense.org/mirror/downloads/
PROTOCOL="http"
BASE_HOST="nyifiles.pfsense.org";
ROOT_PATH="/mirror/downloads";
## Architecture targets
AVAILABLE_ARCHES=(amd64 i386);
TARGET_ARCHES=(amd64 i386);
## Available Versions
KNOWN_VERSIONS=(2.3.2 2.3.3);
TARGET_VERSIONS=(2.3.2 2.3.3);
## Extended Options
EXTENDED_OPTIONS=()
## Option Selection
TARGET_OPTIONS=()
## Directory Specifications
CORE_DIR="${SUBTITLE}";
## Save current directory
START_DIR=$(pwd);
## Output Generation
OUTPUT_MENU_FILE="${START_DIR}/${CORE_DIR}/default.menu";
function generate_menu() {
  dump_method $*
  ## Generate Menu Header
  output_menu_header "${TITLE}" "${OUTPUT_MENU_FILE}";
  ## Ensure base directory exists
  check_directory "${START_DIR}" "${CORE_DIR}";
  ## Update selected versions
  for VERSION in ${TARGET_VERSIONS[@]}; do
    box_start "$( box_title "${VERSION}" )"
    ## Update each selected architecture
    for ARCH in ${TARGET_ARCHES[@]}; do
      # Create directory if necessary
      check_directory "$(pwd)" "${VERSION}";
      # Grab base arch images
      URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/";
      ## Compile the target filename
      FILETARGET="${TITLE}-CE-${VERSION}-RELEASE-${ARCH}.iso.gz";
      ## Download the target file
      box_line "Fetching ${URL}${FILETARGET}"
      add_iso_boot "${URL}" "${TITLE}" "${VERSION}" "${ARCH}" "-" "${CORE_DIR}" "${FILETARGET}" "${OUTPUT_MENU_FILE}";
      cd ..
    done
    box_end "$( box_title "${VERSION}" )" "${ALIGN_RIGHT}"
  done
  ## Return to start directory
  cd ${START_DIR}
}
generate_menu