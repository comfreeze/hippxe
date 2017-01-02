#!/usr/bin/env bash
## General Tools
function getrev() {
    local RESULT;
    RESULT=$(echo ${1} | cut -d${2} -f${3-1})
    echo ${RESULT}
}
function getdirname() {
    local TARGET; TARGET=$1;
    local RESULT;
    RESULT=$(echo "${TARGET}" | cut -d \/ -f $(expr 1 + $(grep -o "/" <<< "${TARGET}" | wc -l)))
    echo ${RESULT}
}
function getfile() {
    local TARGET;  TARGET="$1"
    wget -q -N "${TARGET}"
}
## Output Tools
## Create or change to directory
function check_directory() {
    local ROOT;   ROOT="$1"
    local TARGET; TARGET="$2"
    local DIR;    DIR=$(getdirname ${ROOT})
#    box_line "Parsing ${DIR}"
    if [ ! "${TARGET}" == "${DIR}" ]; then
        if [ ! -d "${TARGET}" ]; then
#            box_line "Creating ${TARGET}"
            mkdir -p "${TARGET}"
            chmod a+r "${TARGET}"
        fi
#        box_line "Entering ${TARGET}"
        cd "${TARGET}"
    fi
}
## Expose custom functions
export -f getrev;
export -f getdirname;
export -f getfile;
export -f check_directory;