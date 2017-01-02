#!/usr/bin/env bash
## Parent script for managing PXE pool of images
TITLE="Untitled"
SUBTITLE="Undefined"
## Architecture targets
AVAILABLE_ARCHES=()
TARGET_ARCHES=()
## Available Versions
KNOWN_VERSIONS=()
TARGET_VERSIONS=()
VERSION_SEPARATOR="."
## Target Selection
TARGET=$1
## Extended Options
EXTENDED_OPTIONS=()
TARGET_OPTIONS=()
## Mirror Definitions
PROTOCOL="https"
BASE_HOST="mirror.umd.edu"
ROOT_PATH="/"
## Directory Definitions
CORE_DIR=""
DIRNAME=""
START_DIR=""
## Output Generation
OUTPUT_MENU_FILE=""
## General Excludes
EXCLUDES=("boot" "pxelinux.cfg" "gparted" "memtest86" "systemrescuecd")
NULL=$(printf "%b" "\u0f")
SPACE=$(printf "%b" "\u2002")
SPACER=$(printf "%b " ${UR_DR})
## Content
_ROOT_DIR=$(pwd)
## Expose custom variables
export TITLE
export SUBTITLE
export AVAILABLE_ARCHES
export TARGET_ARCHES
export KNOWN_VERSIONS
export TARGET_VERSIONS
export VERSION_SEPARATOR
export VERSIONS
export EXTENDED_OPTIONS
export TARGET_OPTIONS
export PROTOCOL
export BASE_HOST
export ROOT_PATH
export CORE_DIR
export DIRNAME
export START_DIR
export OUTPUT_MENU_FILE
export NULL
export SPACE
export SPACER
export _ROOT_DIR
#
# Recursively update directory if it contains
# an update.sh script.
#
function process_dir() {
    local ITEM;     ITEM="$1";
    if [ -d "${ITEM}" ]; then
        box_start ${ITEM}
        if [ -f "${ITEM}/update.sh" ]; then
            box_line "Update starting"
            "${ITEM}/update.sh"
            box_line "Update complete"
        else
            box_line "Update script not found"
        fi
        if [ -f "${ITEM}/default.menu" ]; then
            output_menu_entry_include "${ITEM}/default.menu" "${ITEM}" "${_ROOT_DIR}/images.menu"
        fi
        box_end ${ITEM} "right"
    fi
}
## Import tools
source "files.sh"
source "lines.sh"
source "output.sh"
## Start output
output_menu_header "Images" "${_ROOT_DIR}/images.menu"
box_start ${_ROOT_DIR}
if [ -z ${TARGET} ]; then
    for ITEM in *; do
        if [[ ! ${EXCLUDES[*]} =~ "${ITEM}" ]]; then
            process_dir "${ITEM}"
        fi
    done
else
    for ITEM in ${TARGET[*]}; do
        process_dir "${ITEM}"
    done
fi
cd ${_ROOT_DIR}
box_end ${_ROOT_DIR}
