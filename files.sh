#!/usr/bin/env bash
## General Tools
function getrev() {
    local RESULT;
    RESULT=$(echo ${1} | cut -d${2} -f${3-1})
    echo ${RESULT}
}
## Grab the last string after /
function getdirname() {
    local TARGET;   TARGET=$1;
    local RESULT;
    RESULT=$(echo "${TARGET}" | cut -d \/ -f $(expr 1 + $(grep -o "/" <<< "${TARGET}" | wc -l)))
    echo ${RESULT}
}
## Download remote file
function getfile() {
    local TARGET;   TARGET="$1"
    wget -q -N "${TARGET}"
}
## Mirror a remote directory
function getremotedir() {
    local TARGET;   TARGET="$1"
    local EXCLUDES; EXCLUDES="$2"
    local ex;
    for EXCLUDE in ${EXCLUDES[@]}; do
        ex="$ex -R ${EXCLUDE}";
    done
    wget -q -N -mk -w 3 -r -np -nH --cut-dirs=10 ${ex} "${URL}"
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
## Manipulation Helpers
function find_replace() {
    local TARGET;       TARGET=$1;
    local REPLACEMENT;  REPLACEMENT=$2;
    find . -type f -exec sed -i -e "s/${TARGET//\//\\\/}/${REPLACEMENT//\//\\\/}/g" {} \;
}
## Expose custom functions
export -f getrev;
export -f getdirname;
export -f getfile;
export -f getremotedir;
export -f check_directory;
export -f find_replace;