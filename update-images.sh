#!/usr/bin/env bash

#
# CONFIG
###################
USAGE_TITLE="PXE Images Toolkit"
TITLE="Untitled"
SUBTITLE="Undefined"
## Architecture targets
AVAILABLE_ARCHES=()
TARGET_ARCHES=()
## Available Versions
KNOWN_VERSIONS=()
TARGET_VERSIONS=()
VERSION_SEPARATOR="."
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
EXCLUDES=("boot" "lib" "pxelinux.cfg" "gparted" "memtest86" "systemrescuecd")
NULL=$(printf "%b" "\u0f")
SPACE=' '
SPACER=''
## Content
_ROOT_DIR=$(pwd)
## Style configuration
THEME_1ST=$(echo -e "${FG_GRN}")
THEME_2ND=$(echo -e "${FG_WHT}")
THEME_3RD=$(echo -e "${FG_BLU}")
THEME_4TH=$(echo -e "${FG_CYN}")
THEME_WRN=$(echo -e "${FG_YLW}")
THEME_ERR=$(echo -e "${FG_RED}")
THEME_SPACER=$(printf "%b" ${UR_DR})
THEME_BOX_DEFAULT_WIDTH=85
## Menu Filenames
MENU_IMAGES="images.menu"
MENU_DEFAULT="default.menu"
## Custom Executables
SCRIPT_UPDATE="update.sh"
## Executables
WGET="$( which wget )"
CURL="$( which curl )"
_REF_FORMAT="name|alias"

#
# USE REQUIRE (Bashful)
###################
source $( dirname -- "$0" )/lib/require.sh $*

#
# COMMANDS
###################
COMMANDS=(
  WGET
  CURL
)

#
# LIBRARIES
###################
require filesystem
require boxes
require output

#
# CUSTOM METHODS
###################
action_update () {
  dump_method $*
  local TARGET; TARGET="$1";  shift
  box_start "${_ROOT_DIR}"
  if [ -z ${TARGET} ]; then
    output_menu_header "Images" "${_ROOT_DIR}/${MENU_IMAGES}"
    for ITEM in *; do
      if [[ ! ${EXCLUDES[*]} =~ "${ITEM}" ]]; then
        process_dir "${ITEM}"
        if [ -f "${ITEM}/${MENU_DEFAULT}" ]; then
          output_menu_entry_include "${ITEM}/${MENU_DEFAULT}" "${ITEM}" "${_ROOT_DIR}/${MENU_IMAGES}"
        fi
      fi
    done
  else
    for ITEM in ${TARGET[*]}; do
      process_dir "${ITEM}"
    done
  fi
  cd ${_ROOT_DIR}
  box_end ${_ROOT_DIR} ${ALIGN_RIGHT}
  echo ${RESET}
}
usage_update ()     { echo "u|update ${_REF_FORMAT}"; }
describe_update ()  { echo "Update one or more image sets (ie. distributions)."; }
help_update ()      { cat << EOF

Description:
  $( describe_update)  Helper tooling for generating/updating family of PXE images.
EOF
}
#
# PARAMETERS
###################
# Overwrite Faking
param_fake ()           { prepend_options COMMANDS "echo "; }

#
# LOGIC
###################
## Parent script for managing PXE pool of images
#
# Recursively update directory if it contains
# an update.sh script.
#
function process_dir() {
  local ITEM;     ITEM="$1";
  if [ -d "${ITEM}" ]; then
    box_start ${ITEM} ${ALIGN_LEFT}
    if [ -f "${ITEM}/${SCRIPT_UPDATE}" ]; then
      box_line "Update starting"
      box_line "${ITEM}/${SCRIPT_UPDATE}"
      source ${ITEM}/${SCRIPT_UPDATE}
      box_line "Update complete"
    else
      box_line "Update script not found"
    fi
    box_end ${ITEM} ${ALIGN_RIGHT}
  fi
}

#
# EXECUTION
###################
run $*