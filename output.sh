#!/usr/bin/env bash
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
## Expose custom functions
export -f output_menu_header
export -f output_text_help
export -f output_menu_entry_iso
export -f repeat_char