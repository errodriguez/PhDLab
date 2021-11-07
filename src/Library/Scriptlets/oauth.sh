#! /usr/bin/env bash
#
# OAuth.sh v1.0.0
#
# This scripts implements an OAuth signed authentication wrapper for Twitter's
# REST API services. Based on Twitter's API documentation:
#
# https://dev.twitter.com/rest/reference/get/statuses/home_timeline
#
# Arguments:
#       $1    Twitter's account to be queried.
#       $2    HTTP protocol method.
#       $3    REST API resource URL.
#       $4    Resource parameter "name" (optional).
#       $5    Resource parameter "value" (optional).
#
# 2021 Nov:Restoration effort::Mexico City  
# 2017 Jul:Eduardo René Rodríguez Ávila's PhD Research:IPN-CIC:Mexico City
################################################################################

#===========================================================================
#- FUNCTIONS DECLARATION.
#===========================================================================
 
#- When this script is called options and arguments are parsed, if an error is 
#+ detected usage information is displayed. Usage information can be displayed
#+ too when the option -h is used. The script will stops no matter what other
#+ options were used if the option -h is included.

function Usage {
#* Usage.- Display how the script must be invoked and options available.
#+ Optional parameters name and value are required in pairs; a dummy value can
#+ be included with an empty string ("").
  echo "Usage: "$0" [options] account METHOD resource [name value ...]"
  echo "   -h    Show usage."
}

function RFC3986 {
#* RFC3986.- Percent encoding function. This function covers the URL encoding
#& process described in RFC 3986, section 2.1. In case of any  ambiguity or
#& conflict, refere to that document.
  for ((i=0;i<${#1};i++))
  do
     c="${1:i:1}"
     [[ $c =~ [._~A-Za-z0-9-] ]] && echo -n "$c" || printf "%%%02X" "'$c"
  done
}

#===============================================================================
#- GLOBAL VARIABLES AND FLAGS.
#===============================================================================

#- Script's main variables and constants.
#+ OPTIONS.- Script's command line options.

OPTIONS="h"
   
#- OAUTH keys and work list of keys.
#+ + OACK="oauth_consumer_key"
#+ + OANE="oauth_nonce"
#+ + OASE="oauth_signature"
#+ + OASM="oauth_signature_method"
#+ + OATP="oauth_timestamp"
#+ + OATN="oauth_token"
#+ + OAVN="oauth_version"

OACK="oauth_consumer_key"
OANE="oauth_nonce"
OASE="oauth_signature"
OASM="oauth_signature_method"
OATP="oauth_timestamp"
OATN="oauth_token"
OAVN="oauth_version"
OAUTH=( $OACK $OANE $OASE $OASM $OATP $OATN $OAVN )

#- KEYS.- Array of key names.
#+ VALUES.- Array of key values.

declare -A VALUES
declare -a KEYS

for (( i=0;i<${#OAUTH[@]};i++ ))
do
  KEYS[i]=${OAUTH[i]}
done

#- TIME.- Timestamp invocation.
#+ OSTR.- Ordered parameters string.
#+ SSTR.- Signature base string required by OAuth process.
#+ SKEY.- Signing key. Encoded consumer and access secrets.
#+ HSTR.- HTTP protocol headers string.
TIME=""
OSTR=""
SKEY=""
HSTR=""

#===========================================================================
#- SCRIPT BODY
#===========================================================================

#- 1.- Script invocation validation.
 
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

#- + When all options has been processed, arguments are verified. Shell option
#+ nocasematch is set on in this part.
shift $((OPTIND-1))
shopt -s nocasematch
if (( $# < 3 ))
   then echo "Twitter account, HTTP method and resource URL required."
        exit 255
   else if ! [ -f $PHDSEC/$1.tks ]
           then echo "Unknown Twitter account."
                exit 250
        elif ! [[ $2 =~ ^(GET|POST) ]]
               then echo "Uknown HTTP method."
                    exit 254
	elif ! [[ $3 =~ ^https://.+\.twitter.com/.+\.json ]]
               then echo "Bad resource URL."
                    exit 253
        fi     
fi
if (( $# > 3 ))
   then if ! (($# % 2))
           then echo "Wrong number of name and value pairs."
                exit 252
        fi
fi 
shopt -u nocasematch

for (( i=$((OPTIND+3)),k=$((${#OAUTH[@]})), j=$((OPTIND+4));
       i<=$#; 
       i+=2,           k++,                 j+=2))
do
    KEYS[k]=${!i}
    VALUES[${!i}]=${!j}
done

#=============================================================================

#
#- 2.- Creating a signature
#+     https://dev.twitter.com/oauth/overview/creating-signatures
#+
#+     In this part the OAuth 1.0a HMAC-SHA1 signature for the HTTP request
#+     is created. This signature will be suitable for passing to the Twitter
#+     API as part of an authorized request.
#
#- 2.1.- Collecting the request method and base URL.
#+     To produce a signature, start by determining the HTTP method and URL of
#+     the request. The base URL is the URL to which the request is directed,
#+     minus any query string or hash parameters.
#+
#
#- 2.2.- Collecting parameters.
#+     Next, gather all of the parameters included in the request. There are
#+     two such locations for these additional parameters - the URL (as part of
#+     the querystring) and the request body.

#- Consumer's key and secret as well as access token and access secret are
#- retrieved from the Twitter account keychain.
. $PHDSEC/$1.tks

#- All OAuth key values are assigned. Signature method is HMAC-SHA1.
VALUES[$OASM]="HMAC-SHA1"
VALUES[$OACK]=$CKEY
VALUES[$OATN]=$ATKN
VALUES[$OAVN]="1.0"

#- A timestamp is calculated for signing purposes. A random unique string must
#+ be used in each request and encoded. The "nonce" allows the Service Provider
#+ to verify that the request has never been made befores and helps prevent 
#+ attacks over non-secure channels.
TIME=$(date +%s)
if [ $PHDSYS == "MAC" ]
   then VALUES[$OANE]=$(echo -n $TIME | base64 )
   else VALUES[$OANE]=$(echo -n $TIME | base64 -w0)
fi
VALUES[$OATP]=$TIME

#- All these values need to be encoded into a single string which will be used
#+ later on. The process to build the string is very specific:
  
#- a. Percent encode every value that will be signed.
for i in ${!VALUES[@]}
do
    VALUES[$i]=$(RFC3986 ${VALUES[$i]})
done

#- b. Sort the list of parameters alphabetically by encoded key.
IFS=$'\n' KEYS=($(sort <<<"${KEYS[*]}"))

#- c. For each key/value pair:
#+ -  c.1  Append the encoded key to the output string.
#+ -  c.2  Append the ‘=’ character to the output string.
#+ -  c.3  Append the encoded value to the output string.
#+ -  c.4  If there are more key/value pairs remaining, append a ‘&’
#+         character to the output string.
OSTR=""
for (( i=0;i<${#KEYS[@]};i++ ))                 #* For all keys...
do
    if ! [[ ${VALUES[${KEYS[i]}]} == "" ]]      #& ...if it has a value...
       then if ! [[ $OSTR == "" ]]              #& ...and its not the first...
               then OSTR=$OSTR"&"
            fi
            OSTR=$OSTR$(RFC3986 ${KEYS[i]})"="${VALUES[${KEYS[i]}]}
    fi
done
#=============================================================================

# 
#- 3.- Create the signature base string.
#+     The three values collected so far must be joined to make a single string,
#+     from which the signature will be generated. This is called the signature
#+     base string by the OAuth specification.
SSTR="$2&"
SSTR=$SSTR$(RFC3986 $3)"&"
SSTR=$SSTR$(RFC3986 $OSTR)

#
#- 3.1.- Getting a signing key
#+ The value which identifies the application to Twitter is called the
#+ consumer secret. The value which identifies the account your application is
#+ acting on behalf of is called the oauth token secret. Both of these values
#+ need to be combined to form a signing key which will be used to generate the
#+ signature. The signing key is simply the percent encoded consumer secret,
#+ followed by an ampersand character ‘&’, followed by the percent encoded token
#+ secret. 
SKEY=$(RFC3986 $CSCT)"&"$(RFC3986 $ASCT)

# 
#- 3.2.- Calculating the signature
if [ $PHDSYS == "MAC" ]
   then VALUES[$OASE]=$(echo -n $SSTR | openssl dgst -binary -sha1 -hmac $SKEY | base64)
   else VALUES[$OASE]=$(echo -n $SSTR | openssl dgst -binary -sha1 -hmac $SKEY | base64 -w0 )
fi
VALUES[$OASE]=$(RFC3986 ${VALUES[$OASE]})

#=============================================================================

#
#- 4.- Authorizing the request
#+ https://dev.twitter.com/oauth/overview/authorizing-requests
#+
#+ To allow applications to provide which application is making the request,
#+ which user the request is posting on behalf of, whether the user has granted
#+ the application authorization to post on the user's behalf, and whether the 
#+ request has been tampered by a third party while in transit, Twitter's API
#+ requires that requests needing authorization contain and aditional HTTP
#+ Authorization header with enough information to answer those questions.
#+
#+ Authorization header contains 7 key/value pairs of key begining with the
#+ string "oauth_": oauth_consumer_key, oauth_nonce, oauth_signature,
#+ oauth_signature_method, oauth_timestamp, oauth_token, oauth_version.
#+
#+ To build the header string:
#+ a. Set the string to “OAuth ”.
#+ b. For each key/value pair of the 7 parameters listed above:
#+ b.1 Percent encode the key and append it.
#+ b.2 Append the equals character ‘=’.
#+ b.3 Append a double quote ‘”’.
#+ b.4 Percent encode the value and append it.
#+ b.5 Append a double quote ‘”’.
#+ b.6 If there are key/value pairs remaining, append a comma ‘,’ and a space.

HSTR=""
OSTR=""
for (( i=0; i<${#KEYS[@]}; i++ ))
do
   if [[ ${KEYS[i]} =~ ^oauth_ ]]
      then if ! [[ $HSTR == "" ]]
              then HSTR=$HSTR", " 
           fi
           HSTR=$HSTR$(RFC3986 ${KEYS[i]})"=\""${VALUES[${KEYS[i]}]}"\""
      else if ! [[ ${VALUES[${KEYS[i]}]} == "" ]]
              then if ! [[ $OSTR == "" ]]
                      then OSTR=$OSTR"&"
                   fi
                   OSTR=$OSTR${KEYS[i]}"="${VALUES[${KEYS[i]}]}
           fi
   fi
done
HSTR="OAuth "$HSTR

#=============================================================================

echo "$3?$OSTR  --$2 --header 'Authorization: $HSTR'"

exit $? 
###############################################################################
