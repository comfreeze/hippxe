#!/bin/bash
#
# Script to refresh Calculate images
# - This script downloads specified Calculate ISO images.
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="Calculate";
SUBTITLE="calculate";
## Mirror Definition
ROOT_PATH="/calculate/release";
## Architecture targets
AVAILABLE_ARCHES=(x86_64 i686);
TARGET_ARCHES=(x86_64);
## Available Versions
KNOWN_VERSIONS=(15.17);
TARGET_VERSIONS=(15.17);
## Extended Options
EXTENDED_OPTIONS=(cds cld cldm cldx cls cmc css)
## Option Selection
TARGET_OPTIONS=(cds cld cldm cldx cls cmc css)
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
        ## Update each target option
        for OPTION in ${TARGET_OPTIONS[@]}; do
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}/${VERSION}";
            ## Compile the target filename
            FILETARGET="${OPTION}-${VERSION}-${ARCH}.iso";
            ## Download the target file
            box_line "Fetching ${FILETARGET}"
            getfile "${URL}/${FILETARGET}";
            if [ -f "${FILETARGET}" ]; then
                case ${OPTION} in
                    "cld")  OPTION="Desktop KDE";       ;;
                    "cldm") OPTION="Desktop MATE";      ;;
                    "cldx") OPTION="Desktop XFCE";      ;;
                    "cds")  OPTION="Directory Server";  ;;
                    "cmc")  OPTION="Media Center";      ;;
                    "cls")  OPTION="Scratch";           ;;
                    "css")  OPTION="Scratch Server";    ;;
                esac
                ## Generate menu entry
                output_menu_entry_iso "${CORE_DIR}" "${VERSION}" "${ARCH}" "${OPTION}" "${FILETARGET}" "${TITLE}" "${OUTPUT_MENU_FILE}";
                output_text_help "Boot ${TITLE} ${VERSION} ${OPTION} ISO" "${OUTPUT_MENU_FILE}";
            fi
        done
        cd ..
    done
done
## Return to start directory
cd ${START_DIR}