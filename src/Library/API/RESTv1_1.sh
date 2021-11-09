#! /usr/bin/env bash
#
# RESTv1_1.sh v1.0.0
#
# Twitter's REST API v1.1 services. Receives API method alias and returns
# resource URL.
#
# 2021 Nov:Restoration effort::Mexico City  
# 2017 Jul:Eduardo René Rodríguez Ávila's PhD Research:IPN-CIC:Mexico City
################################################################################
#==============================================================================
#- SETTING GLOBAL VARIABLES AND FLAGS.
#==============================================================================

#- Script's main variables and constants.
#+ HTTP    .- HTTP protocol.
#+ URI     .- Uniform Resource Identification.
#+ VERSION .- Twitter's API version
HTTP="https"
URI="api.twitter.com"
VERSION="1.1"

#- Twitter API families methods
STATUS="statuses"
FOLLOWING="friends"
SEARCH="search"

#- Short aliases (based on methods' first word) conversion for Twitter API methods
case $1 in
     HOME)    echo -n "GET" $HTTP"://"$URI"/"$VERSION"/"$STATUS"/home_timeline.json"
              exit 0
              ;;   
     USER)    echo -n "GET" $HTTP"://"$URI"/"$VERSION"/"$STATUS"/user_timeline.json"
              exit 0
              ;;
     SHOW)    echo -n "GET" $HTTP"://"$URI"/"$VERSION"/"$STATUS"/show.json"
              exit 0
              ;;
     FRNDSID) echo -n "GET" $HTTP"://"$URI"/"$VERSION"/"$FOLLOWING"/ids.json"
              exit 0
              ;;
     FRIENDS) echo -n "GET" $HTTP"://"$URI"/"$VERSION"/"$FOLLOWING"/list.json"
              exit 0
              ;;
     SEARCH)  echo -n "GET" $HTTP"://"$URI"/"$VERSION"/"$SEARCH"/tweets.json"
              exit 0
              ;;
     SHWUSR)  echo -n "GET" $HTTP"://"$URI"/"$VERSION"/users/show.json"
              exit 0
              ;;
     *)       echo -n "GET" $HTTP"://"$URI"/"$VERSION"/"
              exit 253
              ;;
esac 
