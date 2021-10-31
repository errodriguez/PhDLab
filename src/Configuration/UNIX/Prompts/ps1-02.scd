#! /bin/env bash
#
# ps1-02.scd v1.0.0
#
# First level prompt definition and variables settings for a BASH environment.
# Prompt setting by character length.
#
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


#. __prompt_command.- First level prompt definition for a BASH shell 
#& environment. Prompt informs if previous status ends successfully (green)
#& or not (red) and user, host and path is added.
function __prompt_command()
{
    #+ Capture the exit status of the last command.
    EXIT="$?"
    PS1=""
 
    if [ $EXIT -eq 0 ]
       then PS1+="\[$Green\]"
       else PS1+="\[$Red\]"
    fi

    #+ Basic information (user@host:path) is added.
    PS1+="\u\h:"

    #+ Path is trimmed in length control basis
    TRIMMED_PWD=${PWD: -$PHDENV_PromptLength}
    TRIMMED_PWD=${TRIMMED_PWD:-$PWD}
    if [[ "$TRIMMED_PWD" != "$PWD" ]]
       then TRIMMED_PWD="..."$TRIMMED_PWD
    fi
    PS1+="\[$Green\]$TRIMMED_PWD "
    unset TRIMMED_PWD
 
    #+ Check if inside a git repository:
    local git_status="`git status -unormal 2>&1`"    
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]
       then #+ - Parse the porcelain output of git status.
            if [[ "$git_status" =~ nothing\ to\ commit ]]
               then local Color_On=$Green
                    elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]
                         then local Color_On=$Yellow
               else local Color_On=$Red
            fi
            if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]
               then branch=${BASH_REMATCH[1]}
               else #+ - Detached HEAD (a faster alternative).
                    branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
            fi
            #+ - Add the result to prompt.
            PS1+="[$branch] "
    fi
 
    #+ Sets prompt $ for regular users or sets # for root.
    if [[ $USER == "root" ]]
       then PS1+="# "
       else PS1+="$"
    fi

}

PHDENV_PromptLength=8
PROMPT_COMMAND=__prompt_command
