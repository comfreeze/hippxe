#!/bin/bash
#
# Script to refresh Sabayon images
# - This script downloads specified Sabayon ISO images.
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="Sabayon";
SUBTITLE="sabayon";
## Mirror Definition
ROOT_PATH="/sabayonlinux/iso/monthly";
## Architecture targets
AVAILABLE_ARCHES=(amd64);
TARGET_ARCHES=(amd64);
## Available Versions
KNOWN_VERSIONS=(16.07 16.11);
TARGET_VERSIONS=(16.07 16.11);
## Extended Options
EXTENDED_OPTIONS=(GNOME KDE LXQt MATE Minimal Server SpinBase Xfce)
## Option Selection
TARGET_OPTIONS=(GNOME KDE LXQt MATE Minimal Server SpinBase Xfce)
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
        for OPTION in ${TARGET_OPTIONS[@]}; do
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}";
            ## Compile the target filename
            FILETARGET="Sabayon_Linux_${OPTION}_${ARCH}_${FILE}.iso";
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