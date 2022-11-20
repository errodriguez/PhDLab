#!/usr/bin/env bash
#
# setup.sh v1.0.0
#
# Configuration needed (main symbols and settings) for a Unix BASH environment.
# Lines to put in .bash_profile files.
# 
###############################################################################

# Usage.- Display how the script must be invoked and options available.
# Optional parameters name and value are required in pairs; a dummy value can
# be included with an empty string ("").
function Usage {
  echo "Usage: "$0" [-h] [VBX | MAC | UNX]"
  echo "   -h    Show usage."
}

OPTIONS="h"

#===============================================================================
#- ENVIRONMENT IDENTIFICATION
#===============================================================================
PHDENV=$(dirname $(dirname $PWD))

if [[ $1 != "" ]]
   then PHDSYS=$1
   else PHDSYS=$(uname)
fi

#===============================================================================
#- PROCEDURE
#===============================================================================

#- + Options are parsed from the script's invocation. Identified values are
#+ storage in the VALUE array usintg the associated key as index. Flags are
#+ set.

while getopts $OPTIONS opt
do
    case "$opt" in
         h) Usage #- - Ask for help will stop the script.
            exit 1
            ;;
   	 ?) Usage
	    exit 251
            ;;
    esac
done

if [[ ! $(grep "# PhDLab" $HOME/.bash_profile) ]]
   then
	   echo "# PhDLab"
case $PHDSYS in
     # For a VirtualBox machine with a Unix-type operating system using shared
     # folders.
     VBX) echo "export PHDSYS=VBX"
          echo "export PHDLAB=/media/sf_PhDLab"
          echo "export PHDENV=/media/sf_PhDLab/src/Configuration/UNIX"
          echo "export PHDSCR=/media/sf_PhDLab/src/Library/Scriptlets"
          ;;

     # For a Mac (with OS X or macOS) implementation.
     MAC | darwin)
          echo "export PHDSYS=MAC"
          echo "export PHDLAB=$PHDENV"
          echo "export PHDENV=$PHDENV/src/Configuration/UNIX"
          echo "export PHDSCR=$PHDENV/src/Library/Scriptlets"
          ;;

    # For a Unix-type implementation.
    UNX | Linux) 
          echo "export PHDSYS=UNX"
          echo "export PHDLAB=$PHDENV"
          echo "export PHDENV=$PHDENV/src/Configuration/UNIX"
          echo "export PHDSCR=$PHDENV/src/Library/Scriptlets"
          ;;
    # Generic
       *) echo "export PHDSYS=UNX"
          echo "export PHDLAB=$PHDENV"
          echo "export PHDENV=$PHDENV/src/Configuration/UNIX"
          echo "export PHDSCR=$PHDENV/src/Library/Scriptlets"
          ;;
esac
echo "# PhDLab"
fi >> $HOME/.bash_profile
###############################################################################
