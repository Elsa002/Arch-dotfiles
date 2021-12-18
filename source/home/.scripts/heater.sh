#!/bin/zsh

HEAT_COMMAND='while true; do echo heating>/dev/null; done'

function kill_all_heaters()
{
    kill $(ps -ef | grep "zsh -c $HEAT_COMMAND" | grep -v "grep" | grep -o "`whoami`\s*[0-9]\+" | grep -o "[0-9]\+") 1>/dev/null 2>&1
}

function turn_on_heater()
{
    zsh -c "$HEAT_COMMAND"&
}

case $1 in
    "on")
        kill_all_heaters
        for i in {1..`nproc --all`}; do
            turn_on_heater
        done
        ;;
    "off")
        kill_all_heaters
        ;;
    *)
        echo "Invalid argument. Please pass as first argument 'on' or 'off'">&2
        exit 2
esac
