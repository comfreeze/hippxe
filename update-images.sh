#!/usr/bin/env bash
## Import tools
source "files.sh"
source "lines.sh"
source "colors.sh"
source "output.sh"
## Parent script for managing PXE pool of images
export TITLE="Untitled"
export SUBTITLE="Undefined"
## Architecture targets
export AVAILABLE_ARCHES=()
export TARGET_ARCHES=()
## Available Versions
export KNOWN_VERSIONS=()
export TARGET_VERSIONS=()
export VERSION_SEPARATOR="."
## Target Selection
export TARGET=$1
## Extended Options
export EXTENDED_OPTIONS=()
export TARGET_OPTIONS=()
## Mirror Definitions
export PROTOCOL="https"
export BASE_HOST="mirror.umd.edu"
export ROOT_PATH="/"
## Directory Definitions
export CORE_DIR=""
export DIRNAME=""
export START_DIR=""
## Output Generation
export OUTPUT_MENU_FILE=""
## General Excludes
export EXCLUDES=("boot" "pxelinux.cfg" "gparted" "memtest86" "systemrescuecd")
export NULL=$(printf "%b" "\u0f")
export SPACE=' '
export SPACER=''
## Content
export _ROOT_DIR=$(pwd)
## Style configuration
export THEME_1ST=$(echo -e "${FG_GRN}")
export THEME_2ND=$(echo -e "${FG_WHT}")
export THEME_3RD=$(echo -e "${FG_BLU}")
export THEME_4TH=$(echo -e "${FG_CYN}")
export THEME_WRN=$(echo -e "${FG_YLW}")
export THEME_ERR=$(echo -e "${FG_RED}")
export THEME_SPACER=$(printf "%b" ${UR_DR})
export THEME_BOX_DEFAULT_WIDTH=85
#
# Recursively update directory if it contains
# an update.sh script.
#
function process_dir() {
    local ITEM;     ITEM="$1";
    if [ -d "${ITEM}" ]; then
        box_start ${ITEM} ${ALIGN_LEFT}
        if [ -f "${ITEM}/update.sh" ]; then
            box_line "Update starting"
            "${ITEM}/update.sh"
            box_line "Update complete"
        else
            box_line "Update script not found"
        fi
        box_end ${ITEM}
    fi
}
## Start output
box_start "${_ROOT_DIR}"
if [ -z ${TARGET} ]; then
    output_menu_header "Images" "${_ROOT_DIR}/images.menu"
    for ITEM in *; do
        if [[ ! ${EXCLUDES[*]} =~ "${ITEM}" ]]; then
            process_dir "${ITEM}"
            if [ -f "${ITEM}/default.menu" ]; then
                output_menu_entry_include "${ITEM}/default.menu" "${ITEM}" "${_ROOT_DIR}/images.menu"
            fi
        fi
    done
else
    for ITEM in ${TARGET[*]}; do
        process_dir "${ITEM}"
    done
fi
cd ${_ROOT_DIR}
box_end ${_ROOT_DIR}
echo $RESET
echo $(printf "$FG_YLW")