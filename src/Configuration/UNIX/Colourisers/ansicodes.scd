#! /bin/env bash
#
# ansicodes.scd v1.0.0
#
# ANSI codes for directory listings colourisation. Based on codes and varibles
# names from https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#
## IPN-CIC:Eduardo René Rodríguez Ávila:PhD Research:July 2007
################################################################################

#===============================================================================
#- GLOBAL VARIABLES AND FLAGS
#===============================================================================

#- Colour settings consists in variable declaration to hold ANSI escape
#& sequences.

#+ Reset sequence (default terminal colour).
NoColor="$ESC[0m\]"

#+ Seven regular colours.
Black="$ESC[0;30m\]"
Red="$ESC[0;31m\]"
Green="$ESC[0;32m\]"
Yellow="$ESC[0;33m\]"
Blue="$ESC[0;34m\]"
Purple="$ESC[0;35m\]"
Cyan="$ESC[0;36m\]"
White="$ESC[0;37m\]"

#+ Bold sequences ("_B" appended to variable names).
Black_B="$ESC[1;30m\]"
Red_B="$ESC[1;31m\]"
Green_B="$ESC[1;32m\]"
Yellow_B="$ESC[1;33m\]"
Blue_B="$ESC[1;34m\]"
Purple_B="$ESC[1;35m\]"
Cyan_B="$ESC[1;36m\]"
White_B="$ESC[1;37m\]"

#+ Underlined sequences ("_U" appended to variable names).
Black_U="$ESC[4;30m\]"
Red_U="$ESC[4;31m\]"
Green_U="$ESC[4;32m\]"
Yellow_U="$ESC[4;33m\]"
Blue_U="$ESC[4;34m\]"
Purple_U="$ESC[4;35m\]"
Cyan_U="$ESC[4;36m\]"
White_U="$ESC[4;37m\]"

#+ High intensity sequences ("_I" appended to variable names).
Black_I="$ESC[0;90m\]"
Red_I="$ESC[0;91m\]"
Green_I="$ESC[0;92m\]"
Yellow_I="$ESC[0;93m\]"
Blue_I="$ESC[0;94m\]"
Purple_I="$ESC[0;95m\]"
Cyan_I="$ESC[0;96m\]"
White_I="$ESC[0;97m\]"

#+ Bold high intensity sequences ("_BI" appended to variable names).
Black_BI="$ESC[1;90m\]"
Red_BI="$ESC[1;91m\]"
Green_BI="$ESC[1;92m\]"
Yellow_BI="$ESC[1;93m\]"
Blue_BI="$ESC[1;94m\]"
Purple_BI="$ESC[1;95m\]"
Cyan_BI="$ESC[1;96m\]"
White_BI="$ESC[1;97m\]"

#+ Background colours ("_G" appended to variable names).
Black_G="$ESC[40m\]"
Red_G="$ESC[41m\]"
Green_G="$ESC[42m\]"
Yellow_G="$ESC[43m\]"
Blue_G="$ESC[44m\]"
Purple_G="$ESC[45m\]"
Cyan_G="$ESC[46m\]"
White_G="$ESC[47m\]"

#+ High intensity backgrounds ("_GI" appended to variable names).
Black_GI="$ESC[0;100m\]"
Red_GI="$ESC[0;101m\]"
Green_GI="$ESC[0;102m\]"
Yellow_GI="$ESC[0;103m\]"
Blue_GI="$ESC[0;104m\]"
Purple_GI="$ESC[0;105m\]"
Cyan_GI="$ESC[0;106m\]"
White_GI="$ESC[0;107m\]"
