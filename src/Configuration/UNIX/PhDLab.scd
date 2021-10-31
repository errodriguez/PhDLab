#! /usr/bin/env bash
#
# PhDLab.scd v1.0.1
#
# Main symbols and settings for a Unix BASH environment.
# 
## IPN-CIC:Eduardo René Rodrígue Ávila:PhD Research:July 2017
###############################################################################

#===============================================================================
#- GLOBAL VARIABLES AND FLAGS
#===============================================================================

#+ BASH
shopt -s extglob

#+ Freeling.
export FREELINGSHARE=/usr/local/share/freeling
export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib


#+ PhD project specific settings.

export PHDAUT="Eduardo René Rodríguez Ávila"
export PHDVER="1.0"
export PHDSYS=MAC
export PHDLAB=$PWD
export PHDSRC=$PHDLAB/src
export PHDCFG=$PHDSRC/Configuration
export PHDENV=$PHDCFG/UNIX
export PHDLIB=$PHDSRC/Library
export PHDTLS=$PHDSRC/Tools
export PHDSCR=$PHDLIB/Scriptlets
export PHDSEC=$PHDLIB/Keychain

#export PHDPRO=$PHDLAB/Production
#export PHDDAT=$PHDPRO/DATA
#export PHDPIP=$PHDLAB/Pipeline
#export PHDTSK=$PHDPIP/Tasks
#export PHDPCS=$PHDPIP/Processes
#export PHDDIC=$PHDLIB/Dictionaries

#export PHDLAB_PS1FGS=""
#export PHDLAB_PS1CLR=""
#export PHDLAB_PS1PWD=""
#export PHDLAB_PS1IND=""

#==============================================================================
#- FUNCTIONS DECLARATION
#==============================================================================

#- Generic functions are sourced from messages.scd
source $PHDSCR/messages.scd

#===============================================================================
#- SCRIPT'S BODY
#===============================================================================

#- 1.- System type and directories structure settings. 

case $PHDSYS in
      #+ Mac systems require sysvbanner port.
      #+ ls colours 
      MAC) SYSTEM="OS X- or macOS"
           BANNER=banner
           export LANG="es_ES.utf-8"
           . $PHDENV/Colourisers/lscolors.scd
           . $PHDENV/Prompts/ps1-01.scd
           ;;
      VBX) SYSTEM="VirtualBox"
           export ESC="\[\e"
           . $PHDENV/Colourisers/ansicodes.scd
           . $PHDENV/Prompts/ps1-01.scd
           eval $(dircolors -b $PHDENV/Colourisers/ls_colors.clrs)
           BANNER=banner
           if ! mountpoint -q $PHDLAB
              then Message 242
                   return 242
           fi 
           ;;
      UNX) SYSTEM=Unix
           BANNER=banner
           export ESC="\[\e"
           COLOURISERS=$PHDENV/Colourisers
           . $COLOURISERS/ansicodes.scd
           . $PHDENV/Prompts/ps1-02.scd
           eval $(dircolors -b $COLOURISERS/ls_colors.clrs)
           ;;
      COS) ${SYSTEM:=CentOS}
           BANNER=banner
           COLOR_SCHEME=1
           COLOURISERS=$PHDENV/Colourisers
           export ESC="\[\e"
           . $COLOURISERS/ansicodes.scd
           case $(COLOR_SCHEME) in
                1) . $COLOURISERS/lscolors.scd
                   ;;
                2) eval $(dircolors -b $COLOURISERS/ls_colors.clrs)
                   ;;
                3) eval $(dircolors -b $COLOURISERS/moonshine.clrs)
                   ;;
                4) eval $(dircolors -b $COLOURISERS/solarized.clrs)
                   ;;
                5) eval $(dircolors -b $COLOURISERS/centos.clrs)
                   ;;
           esac
           . $PHDENV/Prompts/ps1-01.scd
           ;;
        *) Message 241
           return 241
           ;;
esac

cd $PHDLAB
clear
echo
$BANNER PhDLab

Message "Settings for a $SYSTEM-type system."
. $PHDENV/aliases.scd

###############################################################################
