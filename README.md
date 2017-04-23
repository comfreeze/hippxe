HIPPXE
===
*Version*: ***1.0***

This is a collection of `bash` scripts to provide a quick method of populating a series of core images to a PXE server and generating the related menus required.

*NOTE*: Most of the raw binary assets referenced in this tooling must be downloaded at least once to be useful.

Organization
---
The key directory elements are:
 * *boot/isolinux*
   * Core ISO/SYS/PXELinux binaries (Required)
 * *pxelinux.cfg*
   * Core PXE menu directory
   * *template*
     * Available templates to include
   * *pxe.conf*
     * Primary theme
   * *logo.png*
   * *default*
     * Main PXE boot file, other systems should copy this as a base template for ID specific configurations
 * *memtest86*
   * Common memory testing toolkit
   * Binaries included
 * *output.sh*
   * Output generation helper (Required)
 * *update-images.sh*
   * Core interface for updating PXE assets
   * Downloads ISO's and other binaries required
   * Provides individual options to avoid full bulk download

Other directories beyond these are more specific and may be tailored to preference.

Tools
---
***update-images.sh***

This tool references several sibling libraries to achieve it's goals, and makes a few assumptions about the construction of the filesystem.
The tool itself does not assume any directories exist outside those specified in the `EXCLUDES` directive in the raw file (customize to suit).

This script searches the current directory for more directories, and, where found, checks for the existence of an `update.sh` file.
If this file is present, it is then executed and it's output appended to the screen.

All the existing `update.sh` scripts provided stemmed for an iterative process of the original exploration of this project and provide a fairly uniform definition that can be followed for all distribution targets.
These core elements are **ARCH**, **VERSION**, and sometimes **OPTION**.

**ARCH** and **VERSION** should be relatively self-explanatory, but **OPTION** applies to any additional dimentionality included in mirror definitions.
For example, some distributions provide individual images by window manager, or intended application.

***output.sh***

The primary use of this library is generation of PXE output and should be relatively portable for use with other tooling as needed.


 