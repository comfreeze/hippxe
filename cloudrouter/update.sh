#!/bin/bash
#
# Script to refresh Ubuntu images
# - This script downloads specified Ubuntu ISO images
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="CloudRouter";
SUBTITLE="cloudrouter";
## Mirror Definition
PROTOCOL="https"
BASE_HOST="repo.cloudrouter.org";
ROOT_PATH="/images";
## Architecture targets
AVAILABLE_ARCHES=(CentOS-7 Centos-7 Fedora-23 Fedora-24);
TARGET_ARCHES=(CentOS-7 Centos-7 Fedora-24);
## Available Versions
KNOWN_VERSIONS=(3.0 4.0);
TARGET_VERSIONS=(3.0 4.0);
## Extended Options
EXTENDED_OPTIONS=("!" "-Live");
## Option Selection
TARGET_OPTIONS=("!" "-Live");
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
    MAJOR_VERSION=$(echo ${VERSION} | cut -d. -f1);
    box_start "$( box_title "${VERSION}" )"
    ## Update each selected architecture
    for ARCH in ${TARGET_ARCHES[@]}; do
      PLATFORM=$(echo ${ARCH} | cut -d- -f1);
      PLATFORM_LOWER=$(echo ${PLATFORM} | tr '[:upper:]' '[:lower:]');
      PLATFORM_VERSION=$(echo ${ARCH} | cut -d- -f2);
      # Create directory if necessary
      check_directory "$(pwd)" "${VERSION}";
      ## Update each target option
      for OPTION in ${TARGET_OPTIONS[@]}; do
        URL="${PROTOCOL}://${BASE_HOST}/${MAJOR_VERSION}/${PLATFORM_LOWER}/${PLATFORM_VERSION}${ROOT_PATH}/";
        ## Compile the target filename
        FILETARGET="${TITLE}${OPTION//!/}-${VERSION}-${PLATFORM}.iso";
        ## Download the target file
        box_line "Fetching ${URL}${FILETARGET}"
        add_iso_boot "${URL}" "${TITLE}" "${VERSION}" "${ARCH}" "${OPTION}" "${CORE_DIR}" "${FILETARGET}" "${OUTPUT_MENU_FILE}";
      done
      cd ..
    done
    box_end "$( box_title "${VERSION}" )" "${ALIGN_RIGHT}"
  done
  ## Return to start directory
  cd ${START_DIR}
}
generate_menu