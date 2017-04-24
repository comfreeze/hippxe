#!/bin/bash
#
# Script to refresh Ubuntu images
# - This script downloads specified Ubuntu ISO images
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="OpenWRT";
SUBTITLE="openwrt";
## Mirror Definition
PROTOCOL="https"
BASE_HOST="downloads.openwrt.org";
ROOT_PATH="/generic";
## Architecture targets
AVAILABLE_ARCHES=(x86);
TARGET_ARCHES=(x86);
## Available Versions
KNOWN_VERSIONS=(attitude_adjustment-12.09 barrier_breaker-14.07 chaos_calmer-15.05 chaos_calmer-15.05.1);
TARGET_VERSIONS=(attitude_adjustment-12.09 barrier_breaker-14.07 chaos_calmer-15.05 chaos_calmer-15.05.1);
## Extended Options
EXTENDED_OPTIONS=(rootfs.tar.gz Generic-rootfs.tar.gz combined-ext4.img.gz combined-jffs2-128k.img.gz combined-jffs2-64k.img.gz squashfs.img combined-squashfs.img rootfs-ext4.img.gz rootfs-jffs2-128k.img.gz rootfs-jffs2-64k.img.gz rootfs-squashfs.img)
## Option Selection
TARGET_OPTIONS=(rootfs.tar.gz Generic-rootfs.tar.gz combined-ext4.img.gz combined-jffs2-128k.img.gz combined-jffs2-64k.img.gz squashfs.img combined-squashfs.img rootfs-ext4.img.gz rootfs-jffs2-128k.img.gz rootfs-jffs2-64k.img.gz rootfs-squashfs.img)
## Directory Specifications
CORE_DIR="${SUBTITLE}";
## Save current directory
START_DIR=$(pwd);
## Output Generation
OUTPUT_MENU_FILE="${START_DIR}/${CORE_DIR}/default.menu";
function generate_menu() {
  dump_method $*
  ## Generate Menu Header
  output_menu_header "${TITLE}" "${OUTPUT_MENU_FILE}";
  ## Ensure base directory exists
  check_directory "${START_DIR}" "${CORE_DIR}";
  ## Update selected versions
  for VERSION in ${TARGET_VERSIONS[@]}; do
    VERSION_NAME=$( echo "${VERSION}" | cut -d- -f1 )
    VERSION_NUMBER=$( echo "${VERSION}" | cut -d- -f2 )
    MAJOR_VERSION=$( echo "${VERSION_NUMBER}" | cut -d. -f1 )
    box_start "$( box_title "${VERSION}" )"
    ## Update each selected architecture
    for ARCH in ${TARGET_ARCHES[@]}; do
      # Create directory if necessary
      check_directory "$(pwd)" "${VERSION}";
      # Grab base arch images
      URL="${PROTOCOL}://${BASE_HOST}/${VERSION_NAME}/${VERSION_NUMBER}/${ARCH}${ROOT_PATH}";
      FILETARGET="${SUBTITLE}-${ARCH}-generic-vmlinuz";
      box_line "Fetching ${URL}/${FILETARGET}"
      getfile "${URL}/${FILETARGET}";
      KERNEL="${CORE_DIR}/${VERSION}/${FILETARGET}"
      SUFFIX=""
      if [[ ! -f "${FILETARGET}" ]]; then
        FILETARGET="${SUBTITLE}-${VERSION_NUMBER}-${ARCH}-generic-vmlinuz";
        box_line "Fetching ${URL}/${FILETARGET}"
        getfile "${URL}/${FILETARGET}";
        KERNEL="${CORE_DIR}/${VERSION}/${FILETARGET}"
        SUFFIX="-${VERSION_NUMBER}"
      fi
      ## Update each target option
      for OPTION in ${TARGET_OPTIONS[@]}; do
        ## Compile the target filename
        FILETARGET="${SUBTITLE}${SUFFIX}-${ARCH}-generic-${OPTION}";
        box_line "Fetching ${URL}/${FILETARGET}"
        getfile "${URL}/${FILETARGET}";
        INITRD="${CORE_DIR}/${VERSION}/${FILETARGET}"
        ## Generate menu entry
        if [[ -f "${FILETARGET}" ]]; then
          output_menu_entry_linux "${TITLE} ${VERSION}" "${KERNEL}" "${INITRD}" "${APPEND}" "${OUTPUT_MENU_FILE}";
          output_text_help "Boot ${TITLE} ${VERSION} ${OPTION}" "${OUTPUT_MENU_FILE}";
        fi
      done
      cd ..
    done
    box_end "$( box_title "${VERSION}" )" "${ALIGN_RIGHT}"
  done
  ## Return to start directory
  cd ${START_DIR}
}
generate_menu