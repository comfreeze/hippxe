#!/bin/bash
#
# Script to refresh Ubuntu images
# - This script downloads specified Ubuntu ISO images
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="VyOS";
SUBTITLE="vyos";
## Mirror Definition
BASE_HOST="packages.vyos.net";
ROOT_PATH="/iso/release";
## Architecture targets
AVAILABLE_ARCHES=(amd64 i586);
TARGET_ARCHES=(amd64 i586);
## Available Versions
KNOWN_VERSIONS=(1.0.0 1.0.1 1.0.2 1.0.3 1.0.4 1.0.5 1.1.0 1.1.1 1.1.2 1.1.3 1.1.4 1.1.5 1.1.6 1.1.7);
TARGET_VERSIONS=(1.0.5 1.1.6 1.1.7);
## Extended Options
EXTENDED_OPTIONS=(virt)
## Option Selection
TARGET_OPTIONS=(virt)
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
    box_start "${VERSION}"
    ## Update each selected architecture
    for ARCH in ${TARGET_ARCHES[@]}; do
      # Create directory if necessary
      check_directory "$(pwd)" "${VERSION}";
      # Grab base arch images
      URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/${VERSION}";
      ## Compile the target filename
      FILETARGET="${SUBTITLE}-${VERSION}-${ARCH}.iso";
      ## Download the target file
      box_line "Fetching ${FILETARGET}"
      getfile "${URL}/${FILETARGET}";
      if [ -f "${FILETARGET}" ]; then
        ## Generate menu entry
        output_menu_entry_iso "${CORE_DIR}" "${VERSION}" "${ARCH}" "-" "${FILETARGET}" "${TITLE}" "${OUTPUT_MENU_FILE}";
        output_text_help "Boot ${TITLE} ${VERSION} ISO" "${OUTPUT_MENU_FILE}";
      fi
      ## Update each target option
      for OPTION in ${TARGET_OPTIONS[@]}; do
        URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/${VERSION}";
        ## Compile the target filename
        FILETARGET="${SUBTITLE}-${VERSION}-${ARCH}-${OPTION}.iso";
        ## Download the target file
        box_line "Fetching ${FILETARGET}"
        getfile "${URL}/${FILETARGET}";
        if [ -f "${FILETARGET}" ]; then
          ## Generate menu entry
          output_menu_entry_iso "${CORE_DIR}" "${VERSION}" "${ARCH}" "${OPTION}" "${FILETARGET}" "${TITLE}" "${OUTPUT_MENU_FILE}";
          output_text_help "Boot ${TITLE} ${VERSION} ISO" "${OUTPUT_MENU_FILE}";
        fi
      done
      cd ..
    done
    box_end "${VERSION}" "${ALIGN_RIGHT}"
  done
  ## Return to start directory
  cd ${START_DIR}
}
generate_menu