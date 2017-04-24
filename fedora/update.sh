#!/bin/bash
#
# Script to refresh Fedora images
# - This script downloads specified Fedora ISO images.
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="Fedora";
SUBTITLE="fedora";
## Mirror Definition
ROOT_PATH="/fedora/linux/releases";
## Architecture targets
AVAILABLE_ARCHES=(x86_64 i686 i386);
TARGET_ARCHES=(x86_64);
## Available Versions
KNOWN_VERSIONS=(20 21 22 23 23-10 24 24-1.2 25 25-1.3 26_Alpha-1.7);
TARGET_VERSIONS=(23 23-10 24 24-1.2 25 25-1.3);
## Extended Options
EXTENDED_OPTIONS=(Everything-netinst Server-dvd Server-DVD Server-netinst Live-Workstation Workstation-netinst Workstation-Live);
## Option Selection
TARGET_OPTIONS=(Everything-netinst Server-netinst Workstation-netinst Workstation-Live);
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
            PRIMARY_OPTION=$(echo ${OPTION} | cut -d-  -f1)
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/${MAJOR_VERSION}/${PRIMARY_OPTION}/${ARCH}/iso";
            ## Compile the target filename
            FILETARGET="Fedora-${OPTION}-${ARCH}-${VERSION}.iso";
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