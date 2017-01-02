#!/usr/bin/env bash
## Color References
RESET=`tput sgr0`
# Foreground -------------- Background
FG_BLK=`tput setaf 0`;      BG_BLK=`tput setab 0`;
FG_RED=`tput setaf 1`;      BG_RED=`tput setab 1`;
FG_GRN=`tput setaf 2`;      BG_GRN=`tput setab 2`;
FG_YLW=`tput setaf 3`;      BG_YLW=`tput setab 3`;
FG_BLU=`tput setaf 4`;      BG_BLU=`tput setab 4`;
FG_MAG=`tput setaf 5`;      BG_MAG=`tput setab 5`;
FG_CYN=`tput setaf 6`;      BG_CYN=`tput setab 6`;
FG_WHT=`tput setaf 7`;      BG_WHT=`tput setab 7`;
# Text Effects
FX_BOLD_ON=`tput bold`;     FX_BOLD_OFF=`tput dim`;
FX_ULNE_ON=`tput smul`;     FX_ULNE_OFF=`tput rmul`;
FX_STDT_ON=`tput smso`;     FX_STDT_OFF=`tput rmso`;
FX_REVERSE=`tput rev`
