#!/bin/bash
#
# Script to refresh Ubuntu images
# - This script downloads specified Ubuntu ISO images
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="Ubuntu";
SUBTITLE="ubuntu";
## Mirror Definition
ROOT_PATH="/ubuntu-iso";
## Architecture targets
AVAILABLE_ARCHES=(amd64);
TARGET_ARCHES=(amd64);
## Available Versions
KNOWN_VERSIONS=(12.04.5 14.04.5 15.04 16.04.1 16.04.2 16.10 17.04);
TARGET_VERSIONS=(12.04.5 14.04.5 15.04 16.04.1 16.04.2 16.10 17.04);
## Extended Options
EXTENDED_OPTIONS=(desktop server alternate)
## Option Selection
TARGET_OPTIONS=(desktop server alternate)
## Directory Specifications
CORE_DIR="${SUBTITLE}";
## Save current directory
START_DIR=$(pwd);
## Output Generation
OUTPUT_MENU_FILE="${START_DIR}/${CORE_DIR}/default.menu";
## Generate Menu Header
output_menu_header "${TITLE}" "${OUTPUT_MENU_FILE}";
## Ensure base directory exists
check_directory "${START_DIR}" "${CORE_DIR}";
## Update selected versions
for VERSION in ${TARGET_VERSIONS[@]}; do
    MAJOR_VERSION=$(getrev "${VERSION}" . 1);
    box_start "$( box_title "${VERSION}" )"
#    box_line "Reading revision ${VERSION} - ${MAJOR_VERSION}"
    ## Update each selected architecture
    for ARCH in ${TARGET_ARCHES[@]}; do
        # Create directory if necessary
        check_directory "$(pwd)" "${VERSION}";
#        ## Update each target option
        for OPTION in ${TARGET_OPTIONS[@]}; do
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/${VERSION}";
            ## Compile the target filename
            FILETARGET="ubuntu-${VERSION}-${OPTION}-${ARCH}.iso";
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