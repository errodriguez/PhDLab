#! /bin/env bash
#
# ps1-01.scd v1.0.0
#
# First level prompt definition and variables settings for a BASH environment.
# Bash allows prompt strings to be customized by inserting a number of
# backslash-escaped special characters that are decoded as follows:
#
# \a	     An ASCII bell character (07).
# \d	     The date in "Weekday Month Date" format (e.g., "Tue May 26").
# \D{format} The format is passed to strftime(3) and the result is inserted
#            into the prompt string an empty format results in a
#            locale-specific time representation. The braces are required.
# \e         An ASCII escape character (033).
# \h         The hostname up to the first `.'.
# \H         The hostname.
# \j         The number of jobs currently managed by the shell.
# \l         The basename of the shell's terminal device name.
# \n         Newline.
# \r         Carriage return.
# \s         The name of the shell, the basename of $0 (the portion following
#            the final slash).
# \t         The current time in 24-hour HH:MM:SS format.
# \T         The current time in 12-hour HH:MM:SS format.
# \@         The current time in 12-hour am/pm format.
# \A         The current time in 24-hour HH:MM format.
# \u         The username of the current user.
# \v         The version of bash (e.g., 2.00).
# \V         The release of bash, version + patch level (e.g., 2.00.0).
# \w         The current working directory, with $HOME abbreviated with a
#            tilde.
# \W         The basename of the current working directory, with $HOME
#            abbreviated with a tilde.
# \!         The history number of this command.
# \#         The command number of this command.
# \$         If the effective UID is 0, a #, otherwise a $.
# \nnn       The character corresponding to the octal number nnn.
# \\         A backslash.
# \[         Begin a sequence of non-printing characters, which could be used
#            to embed a terminal control sequence into the prompt.
# \]         End a sequence of non-printing characters.
#
# The command number and the history number are usually different: the history
# number of a command is its position in the history list, which may include
# commands restored from the history file, while the command number is the
# position in the sequence of commands executed during the current shell
# session. After the string is decoded, it is expanded via parameter expansion,
# command substitution, arithmetic expansion, and quote removal, subject to the
# value of the prompt vars shell option.
#
# References:
# http://www.terminally-incoherent.com/blog/2013/01/14/whats-in-your-bash-prompt
#
## IPN-CIC:Eduardo René Rodríguez Ávila:PhD Research:July 2017
################################################################################

#==============================================================================
#- FUNCTIONS DECLARATION
#==============================================================================

#. PromptPS1.- First level prompt definition: Current working directory and
#& information on status of last command executed (through prompts colour).
function PromptPS1 {
    case $? in
                #- Green bold colour for 0 return codes.
	     0) PS1="$Green_B"
                ;;
                #- Yellow bold colour for 1 thru 9 return codes.
	 [1-9]) PS1="$Yellow_B"
                ;;
                #- Red bold colour for return codes greater than 9.
	     *) PS1="$Red_B"
                ;;
    esac
    #+ PS1 current working directory get through "\w" BASH switch.
    PS1+="[\w]"
    #+ PS1 current working directory calculation for other shells is disabled
    #& at this time.
#    if [[ "$(dirname $PWD)" = "/" ]]
#       then PS1+="[$PWD]"
#       else PS1+="[.../$(basename $PWD)]"
#    fi
    #+ After gave information on last command execution, CLI is set to green.
    PS1+="$Green"
    #+ Privileged accounts identification is disabled at this time.
#    if [[ $USER = "root" ]]
#       then PS1+="# "
#       else PS1+="$ "
#    fi 
     PS1+='\$ '
}

#===============================================================================
#- GLOBAL VARIABLES AND FLAGS DECLARATION
#===============================================================================

#- Trim level for BASH "\w" switch (PROMPT_DIRTRIM variable).
PROMPT_DIRTRIM=1
#- Prompt function setting to BASH variable PROMPT_COMMAND.
PROMPT_COMMAND=PromptPS1
