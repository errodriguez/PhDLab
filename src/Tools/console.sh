#! /usr/bin/env bash
#
# console.sh v1.0.0
#
# A tool to interact with Twitter API.
#
# Returns a JSON array.
#
##IPN-CIC:Eduardo René Rodríguez Ávila:PhD Research:July 2017.
################################################################################

#===============================================================================
#- SETTING GLOBAL VARIABLES AND FLAGS.
#===============================================================================

#- Script's main variables and constants.
#+ OPTIONS.- Script's command line options.
#+ VERBOSE.- Show everything.
#+ QUIET  .- Supressed process messages and status information.

OPTIONS="hsv"
VERBOSE=""
QUIET=""
METHOD=""
SERVICE="USER"
RESOURCE=""
PARAM1="count"
VALUE1=""
ACCOUNT=""
STATUS=0
OASTR=""

#+ Function Usage.- Display how the script must be invoked and which options 
#& are available.
function Usage {
  echo "Usage: "$(basename $0)" [OPTIONS]* ACCOUNT [COUNT]"
  echo ""
  echo "OPTIONS:"
  echo "       -v    Verbose."
  echo "       -s    Silent."
  echo "       -h    Show options and arguments."
  echo ""
  echo "PARAMETERS"
  echo "       ACCOUNT  Twitter account to be retrieved."
  echo "       COUNT    Specifies the number of Tweets to try and retrieve,"
  echo "                up to a maximum of 200 per distinct request."
}

#===========================================================================
#= SCRIPT BODY
#===========================================================================

#
#+ 1.- Script invocation validation
#
 
#+ Options are parsed from the script's invocation.
while getopts $OPTIONS opt 
do
      case "$opt" in
           h) Usage
              exit 1
              ;;
           s) QUIET="--silent"
              ;;
           v) VERBOSE="--verbose"
              ;;
           #+ Anything that is not an script option will rise an error.
   	       ?) Usage
	          exit 249;
              ;;
      esac
done

shift $((OPTIND-1))
case $#  in
     1) ACCOUNT=$1
        VALUE1=200   # API limit
        ;;
     2) ACCOUNT=$1
	    VALUE1=$2
        ;;
   0|*) Usage
        exit 249
esac

#=============================================================================

#
#+ 2.- API service settings.
#

if SUBOUT=$($PHDLIB/API/RESTv1_1.sh $SERVICE)
   then read METHOD RESOURCE <<< $(echo $SUBOUT)
   else STATUS=$?
        Message $STATUS
        exit $STATUS
fi

# 
#+ 3.- The call is made to the API resource.
  
OASTR=$($PHDSCR/OAuth.sh $ACCOUNT $METHOD $RESOURCE $PARAM1 $VALUE1)
STATUS=$?

if ! [ $STATUS ]
   then exit $STATUS
fi

echo $OASTR
echo $OASTR | xargs curl $VERBOSE $QUIET
echo

STATUS=$?
if ! [ $STATUS ]
   then echo "... error $STATUS at REST API call."
fi

exit $STATUS 
################################################################################
