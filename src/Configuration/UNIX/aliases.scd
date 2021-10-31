#! /bin/env bash
#
# aliases.scd v1.0.0
#
# Aliases are not expanded in a non-interactive shell, unless the
# expand_aliases shell option is set using shopt. In order to make available
# all aliases definition for any shell script it is necesary to "source"
# the alias definitions into the scripts that requires them after issuing an:
#
#      $ shopt -s expand_aliases
# 
# 
## IPN-CIC:Eduardo René Rodríguez Ávila:PhD Research:July 2017
###############################################################################

#==============================================================================
#- GLOBAL VARIABLES AND FLAGS
#==============================================================================

alias vars='{ ( env | grep ^PHD | sort -t= -k2 ); alias vars tree3 ; } | more'
alias tree3='tree -L 3 -d'
alias lab='cd $PHDLAB'

###############################################################################
