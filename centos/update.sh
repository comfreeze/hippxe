#!/bin/bash
#
# Script to refresh CentOS images
# - This script downloads specified CentOS ISO images.
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="CentOS";
SUBTITLE="centos";
## Mirror Definition
ROOT_PATH="/centos";
## Architecture targets
AVAILABLE_ARCHES=(x86_64 i686);
TARGET_ARCHES=(x86_64);
## Available Versions
KNOWN_VERSIONS=(2 2.1 3 3.1 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 5.10 5.11 6 6.0 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 7 7.0.1406 7.1.1503 7.2.1511 7.3.1611);
TARGET_VERSIONS=(7.2.1511 7.3.1611);
## Extended Options
EXTENDED_OPTIONS=(DVD Everything LiveGNOME LiveKDE Minimal NetInstall)
## Option Selection
TARGET_OPTIONS=(DVD Everything LiveGNOME LiveKDE Minimal NetInstall)
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
    MAJOR_VERSION=$(echo ${VERSION} | cut -d. -f1);
    MINOR_VERSION=$(echo ${VERSION} | cut -d. -f3);
#    box_line "Reading revision ${VERSION} - ${MAJOR_VERSION}"
    ## Update each selected architecture
    for ARCH in ${TARGET_ARCHES[@]}; do
        # Create directory if necessary
        check_directory "$(pwd)" "${VERSION}";
#        ## Update each target option
        for OPTION in ${TARGET_OPTIONS[@]}; do
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/${VERSION}/isos/${ARCH}";
            ## Compile the target filename
            FILETARGET="CentOS-${MAJOR_VERSION}-${ARCH}-${OPTION}-${MINOR_VERSION}.iso";
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
done
## Return to start directory
cd ${START_DIR}