#!/bin/bash
#
# Script to refresh Mint Linux images
# - This script downloads specified Mint ISO images.
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="Mint";
SUBTITLE="mint";
## Mirror Definition
ROOT_PATH="/linuxmint/images/stable";
## Architecture targets
AVAILABLE_ARCHES=(64bit);
TARGET_ARCHES=(64bit);
## Available Versions
KNOWN_VERSIONS=(7 8 9 10 11 12 13 14 15 16 17 17.1 17.2 17.3 18 18.1);
TARGET_VERSIONS=(15 16 17.3 18.1);
## Extended Options
EXTENDED_OPTIONS=(cinnamon kde mate xfce cinnamon-dvd kde-dvd mate-dvd xfce-dvd cinnamon-nocodec kde-nocodec mate-nocodec xfce-nocodec cinnamon-oem kde-oem mate-oem xfce-oem);
## Option Selection
TARGET_OPTIONS=(cinnamon kde mate xfce);
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
    MAJOR_VERSION=$(echo ${VERSION} | cut -d- -f1);
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
            FILETARGET="linuxmint-${VERSION}-${OPTION}-${ARCH}.iso";
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