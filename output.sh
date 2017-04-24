#!/usr/bin/env bash
## Help Message
function output_text_help() {
  local MESSAGE;    MESSAGE="$1"
  local OUTPUT;     OUTPUT="$2"
  echo "  TEXT HELP
  ${MESSAGE}
  ENDTEXT" >> "${OUTPUT}"
}
export -f output_text_help
## Menu Header
function output_menu_header() {
  local TITLE;  TITLE="$1"
  local OUTPUT; OUTPUT="$2"
  echo "MENU TITLE ${TITLE}
INCLUDE pxelinux.cfg/template/back_button" > "${OUTPUT}"
}
export -f output_menu_header
## ISO Menu Entry
function output_menu_entry_include() {
  local TARGET;     TARGET="$1"
  local TITLE;      TITLE="$2"
  local OUTPUT;     OUTPUT="$3"
  echo "MENU INCLUDE ${TARGET} ${TITLE}" >> "${OUTPUT}"
}
export -f output_menu_entry_include
## Linux Menu Entry
function output_menu_entry_linux() {
  local TITLE;      TITLE="$1"
  local KERNEL;     KERNEL="$2"
  local INITRD;     INITRD="$3"
  local APPEND;     APPEND="$4"
  local OUTPUT;     OUTPUT="$5"
  echo "
LABEL ${TITLE// /-}
  MENU LABEL ${TITLE}
  KERNEL ${KERNEL}
  APPEND initrd=$INITRD ${APPEND}" >> "${OUTPUT}"
}
export -f output_menu_entry_linux
## ISO Menu Entry
function output_menu_entry_iso() {
  local CORE_DIR;   CORE_DIR="$1"
  local VERSION;    VERSION="$2"
  local ARCH;       ARCH="$3"
  local OPTION;     OPTION="$4"
  local FILETARGET; FILETARGET="$5"
  local TITLE;      TITLE="$6"
  local OUTPUT;     OUTPUT="$7"
  echo "
LABEL ${CORE_DIR}-${VERSION}-${OPTION//\ /_}-iso
  MENU LABEL ${TITLE} ${VERSION} - ISO (${ARCH}-${OPTION})
  LINUX /boot/isolinux/memdisk
  INITRD /${CORE_DIR}/${VERSION}/${FILETARGET}
  APPEND iso raw" >> "${OUTPUT}"
}
export -f output_menu_entry_iso
function add_iso_boot() {
  dump_method $*
  local url;        url="$1";       shift
  local title;      title="$1";     shift
  local version;    version="$1";   shift
  local arch;       arch="$1";      shift
  local option;     option="$1";    shift
  local dirname;    dirname="$1";   shift
  local filename;   filename="$1";  shift
  local output;     output="$1";    shift
  getfile "${url}/${filename}";
  if [ -f "${filename}" ]; then
    ## Generate menu entry
    output_menu_entry_iso "${dirname}" "${version}" "${arch}" "${option}" "${filename}" "${title}" "${output}";
    output_text_help "Boot ${title} ${version} ISO" "${output}";
  else
    return 404
  fi
}
export -f add_iso_boot
#function echo () {
#  dump_method $*
#  box_line $*
#}
#export -f echo