#!/bin/bash
#
# Script to refresh CoreOS images - all channels
# - This script downloads stable, beta and alpha channels of the CoreOS PXE iamges.
#
## Project
TITLE="CoreOS";
SUBTITLE="coreos";
## Architecture targets
AVAILABLE_ARCHES=(amd64)
TARGET_ARCHES=(amd64)
## Available Versions
KNOWN_VERSIONS=(current)
TARGET_VERSIONS=(current)
VERSION_SEPARATOR="."
## Version Selection
VERSIONS=${1-${TARGET_VERSIONS[@]}}
## Extended Options
EXTENDED_OPTIONS=(stable beta alpha)
TARGET_OPTIONS=(stable beta alpha)
APPEND=("cloud-config-url=https://s3-us-west-1.amazonaws.com/configs.comfreeze.net/pxe-cloud-config.yml")
## Mirror Definitions
BASE_HOST="release.core-os.net"
ROOT_PATH="/"
## Directory Definitions
CORE_DIR="${SUBTITLE}"
VMLINUZ="coreos_production_pxe.vmlinuz"
PXEIMAGE="coreos_production_pxe_image.cpio.gz"
FILES=(${VMLINUZ} ${PXEIMAGE})
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
    for ARCH in ${TARGET_ARCHES[@]}; do
        for OPTION in ${TARGET_OPTIONS[@]}; do
            # Create directory if necessary
            check_directory "$(pwd)" "${OPTION}";
            URL="${PROTOCOL}://${OPTION}.${BASE_HOST}/${ARCH}-usr/${VERSION}"
            for FILE in ${FILES[@]}; do
                box_line "Fetching ${FILE}"
                getfile "${URL}/${FILE}"
                getfile "${URL}/${FILE}.sig"
            done
            if [ -f "${VMLINUZ}" ] && [ -f "${PXEIMAGE}" ]; then
                KERNEL="${CORE_DIR}/${OPTION}/${VMLINUZ}"
                INITRD="${CORE_DIR}/${OPTION}/${PXEIMAGE}"
                ## Generate menu entry
                output_menu_entry_linux "${TITLE} ${OPTION} ^Default" "${KERNEL}" "${INITRD}" "${APPEND}" "${OUTPUT_MENU_FILE}"
                output_text_help "Boot ${TITLE} ${OPTION} Default" "${OUTPUT_MENU_FILE}";
                output_menu_entry_linux "${TITLE} ${OPTION} B^TRFS" "${KERNEL}" "${INITRD}" "rootfstype=btrfs ${APPEND}" "${OUTPUT_MENU_FILE}"
                output_text_help "Boot ${TITLE} ${OPTION} BTRFS" "${OUTPUT_MENU_FILE}";
                output_menu_entry_linux "${TITLE} ${OPTION} ^Install" "${KERNEL}" "${INITRD}" "root=/dev/sda1 ${APPEND}" "${OUTPUT_MENU_FILE}"
                output_text_help "Boot ${TITLE} ${OPTION} Installation" "${OUTPUT_MENU_FILE}";
            fi
            cd ..
        done
    done
done