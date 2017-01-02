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
## Version Selection
VERSIONS=${1-${TARGET_VERSIONS[@]}}
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
EXCLUDES=("boot" "pxelinux.cfg")
NULL=$(printf "%b" "\u0f")
SPACE=$(printf "%b" "\u2002")
SPACER=$(printf "%b " ${UR_DR})
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
#
# Recursively update directory if it contains
# an update.sh script.
#
_ROOT_DIR=$(pwd)
## Import tools
source "files.sh"
source "lines.sh"
source "output.sh"
## Start output
box_start ${_ROOT_DIR}
for ITEM in *; do
#  SPACER=$(printf "%b " ${UR_DR});
  if [ -d "${ITEM}" ] && [[ ! ${EXCLUDES[*]} =~ "${ITEM}" ]]; then
    box_start ${ITEM}
#    printf "%s%b%b %s\n" ${SPACER} ${RR_DCR} ${LR_RT} ${ITEM}
    if [ -f "${ITEM}/update.sh" ]; then
      box_line "update.sh was found"
      box_line "update.sh running"
#      printf "%s%b%s %s\n" ${SPACER} ${RR_UR_DR} $(repeat_char ${LR_RR} 4) "update.sh"
      #"${ITEM}/update.sh"
      box_line "update.sh complete"
    fi
    box_end ${ITEM} "right"
#    printf "%s%b%b %s\n" ${SPACER} ${RR_UCR} ${LR_RT} ${ITEM}
  fi
done
cd ${_ROOT_DIR}
box_end ${_ROOT_DIR}
