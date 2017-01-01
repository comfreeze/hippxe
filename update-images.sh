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
## General Tools
function getrev() {
  local RESULT;
  echo "Reading revision ${1}"
  RESULT=$(echo ${1} | cut -d${2} -f${3-1})
  echo $RESULT
}
function getdirname() {
  local RESULT;
  echo "Parsing ${1}"
  RESULT=$($1 | cut -d \/ -f $(expr 1 + $(grep -o "/" <<< "$1" | wc -l)))
  echo $RESULT
}
function getfile() {
  local TARGET;  TARGET="${1}"
  echo "Fetching ${TARGET}"
  wget -N "${TARGET}"
}
## Output Tools
## Create or change to directory
function check_directory() {
  local ROOT;   ROOT="${1}"
  local TARGET; TARGET="${2}"
  local DIR;    DIR=$(getdirname ${ROOT})
  if [ ! "${TARGET}" == "${DIR}" ]; then
    if [ ! -d "${ROOT}" ]; then
      echo "Creating ${ROOT}"
      mkdir -p "${ROOT}"
      chmod a+r "${ROOT}"
    else
      echo "Entering ${ROOT}"
    fi
    cd "${ROOT}"
  fi
}
## Help Message
function output_text_help() {
  local MESSAGE;    MESSAGE="$1"
  local OUTPUT;     OUTPUT="$2"
  echo "
  TEXT HELP
  ${MESSAGE}
  ENDTEXT"
}
## Menu Header
function output_menu_header() {
  local TITLE;  TITLE=$1
  local OUTPUT; OUTPUT=$2
  echo "MENU TITLE ${TITLE}
INCLUDE pxelinux.cfg/template/back_button"
}
## ISO Menu Entry
function output_menu_entry_iso() {
  local CORE_DIR;   CORE_DIR=$1
  local VERSION;    VERSION=$2
  local ARCH;       ARCH=$3
  local OPTION;     OPTION=$4
  local FILETARGET; FILETARGET=$5
  local TITLE;      TITLE=$6
  echo "
LABEL ${CORE_DIR}-${VERSION}-${OPTION//\ /_}-iso
  MENU LABEL ${TITLE} ${VERSION} - ISO (${ARCH}-${OPTION})
  KERNEL boot/isolinux/memdisk
  APPEND iso initrd=${CORE_DIR}/${VERSION}/${FILETARGET} raw"
}
## Repeat Helper
function repeat_char() {
  local CHAR;  CHAR=${1-'\u2550'};
  local COUNT; COUNT=${2-1};
  local t;     t=$(printf "%-${COUNT}b" "${CHAR}");
  local c;     c=$(printf "%b" ${CHAR});
  echo "${t// /${c}}"
}
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
## Expose custom functions
export -f getrev
export -f getdirname
export -f getfile
export -f check_directory
export -f output_menu_header
export -f output_text_help
export -f output_menu_entry_iso
#
# Recursively update directory if it contains
# an update.sh script.
#
_ROOT_DIR=$(pwd)
## Import tools
source "${_ROOT_DIR}/lines.sh"
SPACER=$(printf "%b" ${UR_DR});
printf "%b%b %s\n" ${RR_DCR} ${LR_RT} ${_ROOT_DIR}
for ITEM in *; do
  if [ -d "${ITEM}" ] && [[ ! ${EXCLUDES[*]} =~ "${ITEM}" ]]; then
    printf "%s%b%b %s\n" ${SPACER} ${RR_DCR} ${LR_RT} ${ITEM}
    if [ -f "${ITEM}/update.sh" ]; then
      printf "%s%b%s %s\n" ${SPACER} ${RR_UR_DR} $(repeat_char ${LR_RR} 4) "update.sh"
      #"${ITEM}/update.sh"
    fi
    printf "%s%b%b %s\n" ${SPACER} ${RR_UCR} ${LR_RT} ${ITEM}
  fi
done
cd ${_ROOT_DIR}
printf "%b%b %s\n" ${RR_UCR} ${LR_RT} ${_ROOT_DIR}

