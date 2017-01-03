#!/bin/bash
#
# Script to refresh Turnkey images
# - This script downloads specified Turnkey ISO images.
# - REF URL: http://archive.ubuntu.com/ubuntu/dists/zesty/main/installer-amd64/current/images/netboot/
#
## Project
TITLE="Turnkey";
SUBTITLE="turnkey";
## Mirror Definition
ROOT_PATH="/turnkeylinux/images/iso";
## Architecture targets
AVAILABLE_ARCHES=(amd64 i386);
TARGET_ARCHES=(amd64);
## Available Versions
KNOWN_VERSIONS=(13.0-wheezy 13.0.1-wheezy 14.1-jessie);
TARGET_VERSIONS=(14.1-jessie);
## Extended Options
EXTENDED_OPTIONS=(ansible asp-net-apache b2evolution bitkey bugzilla cakephp canvas codeigniter collabtive concrete5 core couchdb django dokuwiki domain-controller drupal7 d107 elgg espocrm etherpad ezpublish fileserver foodsoft gallery ghost gitlab gnusocial icescrum jenkins joomla3 lamp laravel lighttpd limesurvey lxc magento mahara mambo mantis mattermost mediaserver mediawiki mibew moinmoin mongodb moodle mysql nginx-php-fastcgi nodejs observium odoo omeka openldap openvpn orangehrm oscommerce otrs owncloud phpbb phplist phreebooks piwik pligg plone postgresql prestashop processmaker projectpier punbb rails redmine revision-control roundup sahana-eden silverstripe simpleinvoices simplemachines sitracker sugarcrm suitecrm symfony tkldev tomatocart tomcat tomcat-apache torrentserver trac tracks twiki typo3 ushahidi vanilla vtiger web2py wordpress xoops yiiframework zencart zurmo);
## Option Selection
TARGET_OPTIONS=(ansible core couchdb django dokuwiki gitlab icescrum jenkins mattermost mediawiki mysql nginx-php-fastcgi nodejs openldap openvpn postgresql redmine trac wordpress);
## Directory Specifications
CORE_DIR="${SUBTITLE}";
## Save current directory
START_DIR=$(pwd);
## Output Generation
OUTPUT_MENU_FILE="${START_DIR}/${CORE_DIR}/default.menu";
## Generate Menu Header
output_menu_header "${TITLE}" "${OUTPUT_MENU_FILE}";
## Ensure base directory exists
check_directory "${START_DIR}" "${CORE_DIR}";
## Update selected versions
for VERSION in ${TARGET_VERSIONS[@]}; do
    MAJOR_VERSION=$(getrev "${VERSION}" . 1);
    ## Update each selected architecture
    for ARCH in ${TARGET_ARCHES[@]}; do
        # Create directory if necessary
        check_directory "$(pwd)" "${VERSION}";
        ## Update each target option
        for OPTION in ${TARGET_OPTIONS[@]}; do
            URL="${PROTOCOL}://${BASE_HOST}${ROOT_PATH}";
            ## Compile the target filename
            FILETARGET="turnkey-${OPTION}-${VERSION}-${ARCH}.iso";
            ## Download the target file
            box_line "Fetching $(getdirname ${URL}/${FILETARGET})"
            getfile "${URL}/${FILETARGET}";
            if [ -f "${FILETARGET}" ]; then
                ## Generate menu entry
                output_menu_entry_iso "${CORE_DIR}" "${VERSION}" "${ARCH}" "${OPTION}" "${FILETARGET}" "${TITLE}" "${OUTPUT_MENU_FILE}";
                output_text_help "Boot ${TITLE} ${VERSION} ISO" "${OUTPUT_MENU_FILE}";
            fi
        done
        cd ..
    done
done
## Return to start directory
cd ${START_DIR}