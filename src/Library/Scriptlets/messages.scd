#! /usr/bin/env bash
#
# messages.scd v1.0.1
#
# Generic functions to display formatted messages in $STDERR and to write
# records in log files.
#
# 2021 Nov:Restoration effort::Mexico City  
# 2017 Jul:Eduardo René Rodríguez Ávila's PhD Research:IPN-CIC:Mexico City
################################################################################

#==============================================================================
#- FUNCTIONS DECLARATION
#==============================================================================

function Logger {
#* Sends a formatted timestamp value for log record purposes to whatever 
#& $PATH_LOG points to ($STDERR as default). So, it requires a previously
#& exported PATH_LOG variable. If there is any problem writing to the log, the
#& message is sent to $STDERR anyway.  This function generates a timestamp and
#& echoes it to $PATH_LOG. Any problem related with the log file is reported
#& and a non-zero status value is returned.

  if (( ${#1} == 0 ))    #+ Nothing to report? 
     then return 1       #& Just a return 1 as friendly reminder.
  fi 

  #+ Path and file name are checked if both set.
  if [[ "$PATH_LOG" != "" && $FILE_LOG != "" ]]    
     #+ $PATH_LOG value is check to exist, where timestamp value is send.
     then if [ -d $PATH_LOG ]
             then 
                  Timestamp ${@} >> $PATH_LOG/$FILE_LOG
                  #+ In case of troubles, a message a non-zero status value 
                  #& are returned.
                  if [ $? -ne 0 ]
                     then Message 247
                          return 247
                     else return 0
                  fi
             else Message 246
                  return 246
          fi
     else Message 245
          return 245
  fi
}
#==============================================================================

function Message {
#* Message.- Displays or records (or both) a string message and sets a status
#& value. This function includes a local function which provides information
#& on its invocation (for development and debugging purposes). By default
#& messages are show in $SDTERR and no recorded.

  function Info {
           echo ""
           echo "Message [-l | -r] [NUMBER | STRING]"
           echo ""
           echo " Options are mutually exclusive. Last one fix the expected"
           echo " behaviour."
           echo ""
           echo "    -r      Record in the log too."
           echo "    -l      Record only in the log."
           echo "    -h      Prints this help."
           echo ""
           echo "  NUMBER    Retrieves a message from the catalog. Return"
           echo "            code is the message number."
           echo "  STRING    Use the string provided as the message. Return"
           echo "            code is zero."
           echo ""
           echo " In case neither NUMBER nor STRING were provided an ellipsis"
           echo " is displayed and the return code is zero."
           echo ""
           return 1
  }
 
  local OPTIND OPTIONS REC LOG opt
  OPTIONS="lrh"   #- Valid invocation options:
                  #+ -r Shows the record in console and records it in the log.
                  #+ -l No message is shown in console, it is recorded only.
                  #+ -h Shows usage information.
  REC=false       #- REC f. Permanent recording of messages in log.
  LOG=false       #- LOG f. Log entry-only action.


  #- Invocation options are validated.
  while getopts $OPTIONS opt
  do
     case "$opt" in
          r) REC=true
             LOG=false
             ;;
          l) LOG=true
             REC=false
             ;;
        h|*) Info
             return 
             ;;
     esac
  done
    
  shift $((OPTIND-1))

  #- First argument is set as return code value. This value is used as key to
  #+ look up for the string message.
  status=$1
  case "$1" in
      0) m="OK ($@)."
         ;;
      1) m="Script invocation instruction (usage) by explicit request ($@)."
         ;;
      2) m="Ignoring unnecesary arguments provided ($@)."
         ;;
      3) m="Missing dataset file or path ($@)."
         ;;
      4) m=" ($@)."
         ;;
      5) m="A Twitter account is required."
         ;;
      6) m="Account $2 ..."
         ;;
      7) m="... No data for account $account."
         ;;
      8) m="... Reseting account $2."
         ;;
      9) m="... Nothing to reset."
         ;;
     10) m="... Output path for account $2 created."
         ;;
     11) m="... Processing file $2."
         ;;
     12) m="... step $2... "
         ;;
     13) m="... done($2)."
         ;;
     14) m="... extracting text and entities..."
         ;;
     15) m="... emojis ..."
         ;;
     16) m="... emoticons ..."
         ;;
     17) m="... directory for texts and entities created."
         ;;
     18) m="Starting..."
         ;;
     19) m="Finishing."
         ;;
     20) m="... extracting tweets' text..."
         ;;
     21) m="... identifying entities..."
         ;;
     22) m="... data cleansing..."
         ;;
     23) m="... dingbats ..."
         ;;
     24) m="Verbose mode requested."
         ;;
     25) m="Validating data repository."
         ;;
     26) m="... extracting hashtags..."
         ;;
     27) m="... extracting media items..."
         ;;
     28) m="... files from $2 to $3."
         ;;
     29) m="... extracting symbols..."
         ;;
     30) m="... date range: $2-$3."
         ;;
     31) m="... extracting URLs..."
         ;;
     32) m="... extracting user mentions..."
         ;;
    127) m="================================================================="
         ;;
    123) m="Transfer closed with outstanding read data remaining (curl) ($@)."
         ;;
    129) m="Terminating process ($1)."
         ;;
    130) m="curl cancelled by user ($@)."
         ;;
    146) m="Log path not set ($1)."
         ;;
    147) m="Creating log path ($2)."
         ;;
    148) m="Creating log file ($2)."
         ;;
    149) m="Reseting log file ($1)."
         ;;
    236) m="Missing or unknown HTTP $2 method."
         ;;
    237) m="A REST call name is required."
         ;;
    238) m="A task code or name is required."
         ;;
    239) m="End date must be equal or greater than the initial one."
         ;;
    240) m="$1 is not a number."
         ;;
    241) m="Unidentified system."
         ;;
    242) m="Media not mounted, environment not available."
         ;;
    243) m="Invalid date."
         ;;
    244) m="Wrong parameters number"
         ;;
    245) m="Error: Log file not set ($@)."
         ;;
    247) m="Error: log recording problem ($@)."
         ;;
    248) m="Error reseting log file for $ACCOUNT ($@)."
         ;;
    249) m="Missing argument(s) or value(s) ($@)."
         ;;
    250) m="Error deleting files or directories ($2)."
         ;;
    251) m="Error creating a path, directory or file ($2)."
         ;;
    252) m="Unknown Twitter account ($2)."
         ;;
    253) m="Bad argument ($@)."
         ;;
    254) m="Unknown script option ($@)."
         ;;
    255) m="Usage display raised by an error condition ($@)."
         ;;
    #- Any argument value not defined in the function is taken as a string
    #+ to be displayed as is (numeric or not). In that case, return code
    #+ will be zero.
    #+ If no argument is provided an ellipsis is showed, and a zero value
    #+ will be returned too.
      *) if [ ${#@} -ne "0" ]
            then m="$@"
                 status=0;
            else m="..."
                 status=0;
         fi
  esac

  #- If $LOG flag is set (true), Logger function is summoned and string message
  #+ is passed to be recorded. Nothing will be shown on the console.
  if $LOG
     then Logger "$m"
          return $status
     else #- By default, timestamp and string message are shown in $STDERR. 
          #+ This is only supressed by $LOG flag. 
          Timestamp "$m" >&2
          #- If $REC flag is set (true) string and timestamp are recorded in 
          #+ the log.
          if $REC
             then Logger "$m"
          fi
          return $status
  fi
}
#==============================================================================

function Timestamp {
#* Timestamp.- Generates a timestamp taking into account date command 
#& variations with $PHDSYS value and echoes it adding the first argument 
#& passed to this function.

  if [ $PHDSYS == "MAC" ]
     then echo $(date -u +"%Y.%m.%d %H:%M:%S") [${0##*/}] $@ 
     else echo $(date -u --rfc-3339="seconds") [${0##*/}] $@
  fi 
}
#==============================================================================

function Logging {
#* Logging.- Validates and prepares what is necessary for Logger function.
#& Receives path, file name and, optionally, a reset flag.
  if (( $# < 2 ))
     then return 249
  fi
  if ! [ -d $1 ]
     then Message 146
          mkdir -p $1
          STATUS=$?
          Message 147 $STATUS
          if [ $STATUS -ne 0 ]
             then Message 251 $STATUS
                  return 251
          fi
          return 0
     else if ! [ -f $1/$2 ]
             then touch $1/$2
                  STATUS=$?
                  Message 148 $STATUS
                  if [ $STATUS -ne 0 ]
                     then Message 251 $STATUS
                          return $STATUS
                  fi
                  return 0
             else if [ "$3" ]
                     then > $1/$2
                          Message 149
                  fi
                  return 0
          fi
  fi
}
