#!/bin/bash
#
# Script to refresh CoreOS images - all channels
# - This script downloads specified Ubuntu ISO images
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="Ubuntu Installer";
SUBTITLE="ubuntu-installer";
## Mirror Definition
PROTOCOL="http"
BASE_HOST="archive.ubuntu.com"
ROOT_PATH="/ubuntu/dists";
## Architecture targets
AVAILABLE_ARCHES=(amd64);
TARGET_ARCHES=(amd64);
## Available Versions
KNOWN_VERSIONS=(precise trusty vivid wily xenial yakkety zesty);
TARGET_VERSIONS=(precise trusty vivid wily xenial yakkety zesty);
## Extended Options
EXTENDED_OPTIONS=()
## Option Selection
TARGET_OPTIONS=()
## Directory Specifications
CORE_DIR="${SUBTITLE}";
VMLINUZ="linux"
PXEIMAGE="initrd.gz"
## Save current directory
START_DIR=$(pwd);
## Output Generation
OUTPUT_MENU_FILE="${START_DIR}/${CORE_DIR}/default.menu";
## Specific download exclusions
DL_EXCLUDES=( \
 pxelinux.0 \
 pxelinux.cfg \
 index.html \
 index.html\?C=M\;O=A \
 index.html\?C=M\;O=D \
 index.html\?C=N\;O=A \
 index.html\?C=N\;O=D \
 index.html\?C=S\;O=A \
 index.html\?C=S\;O=D \
 index.html\?\
)
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
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/${VERSION}/main/installer-${ARCH}/current/images/netboot/ubuntu-installer/${ARCH}";
            ## Compile the target filename
#            FILETARGET="ubuntu-${VERSION}-${OPTION}-${ARCH}.iso";
            ## Download the target file
            box_line "Fetching ${TITLE} - ${VERSION} Netboot Installer"
            getremotedir "${URL}/" "${DL_EXCLUDES[*]}";
            if [ -f "${FILETARGET}" ]; then
                KERNEL="${CORE_DIR}/${VERSION}/${VMLINUZ}"
                INITRD="${CORE_DIR}/${VERSION}/${PXEIMAGE}"
                ## Generate menu entry
                output_menu_entry_linux "${TITLE} ${VERSION}" "${KERNEL}" "${INITRD}" "${APPEND}" "${OUTPUT_MENU_FILE}";
                output_text_help "Boot ${TITLE} ${VERSION}" "${OUTPUT_MENU_FILE}";
                find_replace "ubuntu-installer/${ARCH}" "${NEW_BASE}"
                find_replace "timeout 0" ""
            fi
#        done
        cd ..
    done
done
## Return to start directory
cd ${START_DIR}