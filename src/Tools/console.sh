#! /usr/bin/env bash
#
# console.sh v1.1.0
#
# A tool to interact with Twitter API.
#
# Returns a JSON array.
#
# 2021 Nov:Restoration effort::Mexico City  
# 2017 Jul:Eduardo René Rodríguez Ávila's PhD Research:IPN-CIC:Mexico City
################################################################################

#===============================================================================
#- SETTING GLOBAL VARIABLES AND FLAGS.
#===============================================================================

#- Sourcing utility functions.
. $PHDSCR/messages.scd

#- Script's main variables and constants.
#+ OPTIONS.- Script's command line options.
#+ VERBOSE.- Show additional information on script execution, redirected to
#+           STDERR.
#+ QUIET  .- Supressed process messages and status information.
#+ ACCOUNT.- Account requesting access.
#+ ALIAS.- Shortcut for an URL resource.
#+ METHOD.- HTTP methond tobe used.
#+ RESOURCE.- Twitter API service.
#+ PARAMS.- Parameters for API service. NOT IMPLEMENTED YET.
#+ STATUS.- Result or return code from last command.
#+ OASTR.- Authorisation string to be used calling the resource.


OPTIONS="hsva:A:"
VERBOSE=""
QUIET=""
ACCOUNT=${PHDACC:-""}
ALIAS=""
METHOD=""
RESOURCE=""
PARAMS=""
STATUS=0
OASTR=""

#- Internal script's functions.
function Usage {
#* Display how the script must be invoked and which options 
#& are available.
  echo "Usage: "$(basename $0)" [OPTIONS]* [-A ACCOUNT] -a ALIAS [PARAMETERS]*"
  echo "   or  "$(basename $0)" [OPTIONS]* [-A ACCOUNT] METHOD RESOURCE [PARAMETERS]*"
  echo ""
  echo "OPTIONS:"
  echo "       -v        Verbose mode."
  echo "       -s        Silent mode."
  echo "       -h        Clear screen to show options and arguments."
  echo ""
  echo "PARAMETERS"
  echo "       -A        Account requesting the query. If no account is given"
  echo "                 $PHDACC variable value will be used but if this is not"
  echo "                 set or empty an error arise."
  echo "       -a        Service alias and its parameters."
  echo "       METHOD    HTTP GET or POST method in uppercase"
  echo "       RESOURCE  API Twitter resource URL with necessary parameters as"
  echo "                 may be required (see exaples)."
  echo ""
  echo "Examples:"
  echo ""
  echo "$ "$(basename $0)" -a xyz GET https://api.twitter.com/1.1/statuses/user_timeline.json"
  echo ""
  echo "if parameters are requiered, they have to be added in key-value pairs:"
  echo ""
  echo "$ $(basename $0) ... https://.../user_timeline.json user_id 12 count 2"
  echo ""
  echo "This example has been abbreviated for presentation."
}

#===========================================================================
#- SCRIPT BODY
#===========================================================================

#
#- 1.- Script invocation validation
#
 
#+ Options used are parsed from the script's invocation.
while getopts $OPTIONS opt 
do
      case $opt in
           h) clear
              Usage
              exit 1
              ;;
           s) QUIET="--silent"
              ;;
           v) VERBOSE="--verbose"
              ;;
           A) ACCOUNT=$OPTARG
              ;;
           a) ALIAS=$OPTARG
              ;;
           #+ Anything that is not an script option will rise an error.
           ?) Usage
              exit 249;
              ;;
      esac
done

#- Arguments passed are validated
shift $((OPTIND-1))

if [[ $ALIAS == "" ]] 
   then if [ $(($#%2)) -ne 0 ]
           then STATUS=249
                Message $STATUS
                Usage
                exit $STATUS
        fi
        case $1 in
             GET|POST) ;;
                    *) STATUS=236
                       Message $STATUS $1
                       exit $STATUS
                       ;;
        esac
fi

if ! [[ $ACCOUNT ]]
   then STATUS=5
        Message $STATUS
        exit $STATUS
fi

#=============================================================================

#
#- 2.- API service settings.
#
if [[ $ALIAS ]]
   then if SUBOUT=$($PHDLIB/API/RESTv1_1.sh $ALIAS)
           then read METHOD RESOURCE <<< $(echo $SUBOUT)
           else STATUS=$?
                Message $STATUS
                exit $STATUS
        fi
else METHOD=$1
     RESOURCE=$2
     shift 2
fi

# 
#- 3.- The call is made to the API resource.
#  
OASTR=$($PHDSCR/oauth.sh $ACCOUNT $METHOD $RESOURCE $@)
STATUS=$?

if ! [ $STATUS ]
   then exit $STATUS
fi

if [[ $VERBOSE ]]
   then echo "Oauth string:"
        echo $OASTR
        echo ""
        echo "curl output:"
        echo ""
fi >&2

echo $OASTR | xargs curl $VERBOSE $QUIET; STATUS=$?
echo

if ! [ $STATUS ]
   then echo "... error $STATUS at REST API call."
fi >&2

exit $STATUS 
################################################################################
