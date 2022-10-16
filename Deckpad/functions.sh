function prepare_fullscreen {
    clear
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
}

function show_prompt {
    prompt=$1
    if [[ -z ${2+x} ]]; then
        style='banner'
    else
        style=$2
    fi
    if command -v figlet &>/dev/null; then
        figlet -c -w 180 -f $style -k "$prompt"
        echo ""
        echo ""
        echo ""
    else
        echo "-----------------------------------"
        echo ""
        echo "         $prompt"
        echo ""
        echo "-----------------------------------"
    fi
}

function block_until_mouse_click {
    echo -e "\e[?1000h"
    read -n 12
}

function disable_sleep {
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target >/dev/null 2>&1
}

function reenable_sleep {
    sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target >/dev/null 2>&1
}

brightness_file=/sys/class/backlight/amdgpu_bl0/brightness
function set_brightness_to_minimum {
    # Backup current brightness
    cat $brightness_file >./brightness_bak

    # Set to minimum
    echo 0 >$brightness_file

    # Prevent Steam from changing brightness (make read-only)
    chmod 444 $brightness_file
}

function restore_brightness {
    # Allow Steam to change brightness again (make read-write)
    chmod 666 $brightness_file

    # Restore original brightness
    cat ./brightness_bak >$brightness_file
    rm ./brightness_bak
}

function start_virtualhere {
    virtualhere/vhusbdx86_64 >/dev/null 2>&1 &
    echo $! >./virtualhere_pid
}

function stop_virtualhere {
    kill -s SIGINT $(cat ./virtualhere_pid)
    rm ./virtualhere_pid
    wait
}

function start_prompt {
    # Deprecated
    prepare_fullscreen
    show_prompt "Starting in . . . 3"
    sleep 1
    prepare_fullscreen
    show_prompt "Starting in . . . 2"
    sleep 1
    prepare_fullscreen
    show_prompt "Starting in . . . 1"
    sleep 1
}

function quit_prompt {
    sleep_time=0.6
    prepare_fullscreen
    show_prompt "Quitting"
    sleep $sleep_time
    prepare_fullscreen
    show_prompt "Quitting ."
    sleep $sleep_time
    prepare_fullscreen
    show_prompt "Quitting . ."
    sleep $sleep_time
    prepare_fullscreen
    show_prompt "Quitting . . ."
}


function _do_run_prompt {
    while true;
    do
        battery=$(cat /sys/class/power_supply/BAT1/capacity)
        # battery=$(date +'%s') # Used to debug

        prepare_fullscreen
        show_prompt "Tap To Quit!"
        show_prompt "$battery %"
        sleep 0.5
    done
}
function run_prompt_start {
    _do_run_prompt &
    echo $! >./run_prompt_pid
}
function run_prompt_stop {
    kill -s SIGKILL $(cat ./run_prompt_pid)
    rm ./run_prompt_pid
}
