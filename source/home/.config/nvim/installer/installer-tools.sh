#!/bin/zsh
INSTALLER_TOOLS_DIR="`dirname $0`"

# Globals ################################################
EXIT_STATUS_SUCCESS=0
EXIT_STATUS_FAILURE=1
DEV_NULL='/dev/null'

# Functions ##############################################
function read_prompt()  # $1 is a prompt to print
{
    printf "\033[1;34mINPUT: \033[0m$1: \033[0;32m"
    read answer
    printf "\033[0m"
    export _prompt_result=$answer
}

function yes_no_prompt()  # $1 is a prompt to print
{
    printf "\033[1;34mINPUT: \033[0m$1[\033[0;32my\033[0m/\033[1;31mN\033[0m]: \033[0;32m"
    read answer
    printf "\033[0m"
    if [[ $answer == 'y' || $answer == 'Y' || $answer == 'yes' || $answer == 'YES' || $answer == 'Yes' ]]; then
        return $EXIT_STATUS_SUCCESS
    else
        return $EXIT_STATUS_FAILURE
    fi
}

function silent_call()  # Call to args with fd 1 and 2 redirected to dev-null
{
    ${@:1} 1>$DEV_NULL 2>&1
}

function verbose_run()
{
    RUN_MSG="${@:1}"
    print_info "\033[1;32mRunning:\033[0;37m $RUN_MSG\033[0m"

    ${@:1}

    return_status=$?
    if [[ $return_status != $EXIT_STATUS_SUCCESS ]]; then
        print_error "'${@:1}' failed. exit_status=$return_status"
    fi
    return $return_status
}

function print_error()  # Print error to stderr
{
    ERROR_MSG="${@:1}"
    printf "\033[1;31mERROR(pid: $$):\033[0m $ERROR_MSG\n" >&2
}

function print_warning()  # Print warrning to stderr
{
    WARN_MSG="${@:1}"
    printf "\033[1;33mWARN(pid: $$):\033[0m $WARN_MSG\n" >&2
}

function print_info()  # Print info to stderr
{
    INFO_MSG="${@:1}"
    printf "\033[1;35mINFO(pid: $$):\033[0m $INFO_MSG\n" >&2
}

function print_note()  # Print info to stderr
{
    NOTE_MSG="${@:1}"
    printf "\033[1;35mNOTE:\033[0;35m $NOTE_MSG\n\033[0m"
}

function print_seperator()  # Print info to stderr
{
    SEPERATOR_MSG="${@:1}"
    printf "\n"
    printf "\033[0;35m>------>\n"
    printf "\033[0;36m  >------> \033[1;34m$SEPERATOR_MSG\n"
    printf "\033[0;35m>------>\n"
    printf "\n\033[0m"
}

function print_done()
{
    printf "\033[1;32mDone\033[0m ${@:1}\n\n\n"
}

function print_vim_help()
{
    printf "\033[1;33mVIM HELP:\033[0;35m "
    printf "The file will open using vim.\n"
    printf "\t - To move, use the arrow keys or hjkl.\n"
    printf "\t - To get in Insert mode, press 'i', to exit it press <esc>.\n"
    printf "\t - To save changes, press <esc>, then type ':w', to exit ':q', to exit without saving ':q!'.\n"
    printf "\033[0m"
}
