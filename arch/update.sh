#!/bin/bash
#
# Script to refresh Arch images - all channels
# - This script downloads specified Arch ISO images.
#
## Project
TITLE="Arch";
SUBTITLE="arch";
## Mirror Definition
ROOT_PATH="/archlinux/iso";
## Architecture targets
AVAILABLE_ARCHES=(amd64);
TARGET_ARCHES=(amd64);
## Available Versions
KNOWN_VERSIONS=(2016.12.01 2016.11.01 2016.10.01);
TARGET_VERSIONS=(2016.11.01 2016.12.01);
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
## Generate Menu Header
output_menu_header "${TITLE}" "${OUTPUT_MENU_FILE}";
## Ensure base directory exists
check_directory "${START_DIR}" "${CORE_DIR}";
## Update selected versions
for VERSION in ${TARGET_VERSIONS[@]}; do
    MAJOR_VERSION=$(getrev "${VERSION}" . 1);
#    box_line "Reading revision ${VERSION} - ${MAJOR_VERSION}"
    ## Update each selected architecture
    for ARCH in ${TARGET_ARCHES[@]}; do
        # Create directory if necessary
        check_directory "$(pwd)" "${VERSION}";
#        ## Update each target option
#        for OPTION in ${TARGET_OPTIONS[@]}; do
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/${VERSION}";
            ## Compile the target filename
            FILETARGET="archlinux-${VERSION}-dual.iso";
            ## Download the target file
            box_line "Fetching $(getdirname ${URL}/${FILETARGET})"
            getfile "${URL}/${FILETARGET}";
            if [ -f "${FILETARGET}" ]; then
                ## Generate menu entry
                output_menu_entry_iso "${CORE_DIR}" "${VERSION}" "${ARCH}" "NA" "${FILETARGET}" "${TITLE}" "${OUTPUT_MENU_FILE}";
                output_text_help "Boot ${TITLE} ${VERSION} ISO" "${OUTPUT_MENU_FILE}";
            fi
#        done
        cd ..
    done
done
## Return to start directory
cd ${START_DIR}