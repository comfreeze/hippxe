#!/bin/bash
#
# Script to refresh Damn Small Linux images
# - This script downloads specified Damn Small Linux ISO Images.
#
## Project
TITLE="Damn Small Linux";
SUBTITLE="damnsmalllinux";
## Mirror Definition
PROTOCOL="http"
BASE_HOST="distro.ibiblio.org"
ROOT_PATH="/damnsmall";
## Architecture targets
AVAILABLE_ARCHES=(x86_64);
TARGET_ARCHES=(x86_64);
## Available Versions
KNOWN_VERSIONS=(4.4.10);
TARGET_VERSIONS=(4.4.10);
## Extended Options
EXTENDED_OPTIONS=(${NULL} -initrd -syslinux)
## Option Selection
TARGET_OPTIONS=(${NULL} -initrd -syslinux)
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
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/current";
            ## Compile the target filename
            FILETARGET="dsl-${VERSION}${FILE}.iso";
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