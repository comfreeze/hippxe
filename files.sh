#!/usr/bin/env bash
## General Tools
function getrev() {
  local RESULT;
  echo "${SPACER} Reading revision ${1}"
  RESULT=$(echo ${1} | cut -d${2} -f${3-1})
  echo $RESULT
}
function getdirname() {
  local RESULT;
  echo "${SPACER} Parsing ${1}"
  RESULT=$($1 | cut -d \/ -f $(expr 1 + $(grep -o "/" <<< "$1" | wc -l)))
  echo $RESULT
}
function getfile() {
  local TARGET;  TARGET="${1}"
  echo "${SPACER} Fetching ${TARGET}"
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
## Expose custom functions
export -f getrev;
export -f getdirname;
export -f getfile;
export -f check_directory;