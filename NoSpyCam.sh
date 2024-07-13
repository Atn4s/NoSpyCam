#!/bin/bash

# Function to show the menu
show_menu() {
    clear
    echo "No Spy Cam"
    echo "======================="
    echo "1. Turn on  [Webcam]"
    echo "2. Turn off [Webcam]"
    echo "3. Exit App"
    echo "======================="
}

# Function to enable the webcam
enable_webcam() {
    echo "Turning ON your Webcam"
    modprobe uvcvideo
    echo "[Webcam] is: ENABLED"
}

# Function to disable the webcam
disable_webcam() {
    echo "Disabling your Webcam"

    # Check if any process is using a webcam
    if lsof /dev/video0 >/dev/null 2>&1; then
        echo "Application(s) are using the Webcam:"
        lsof /dev/video0
        echo "Do you want to close the application(s)? (Y/N):"
        read -r response

        if [[ $response =~ ^[Yn]$ ]]; then
            echo "Closing the application(s) that are using the Webcam"
            fuser -k /dev/video0
            sleep 2 # Wait a brief moment to ensure the application closes
        else
            echo "Operation cancelled. The Webcam will not be disabled."
            return
        fi
    fi

    modprobe -r uvcvideo
    echo "[Webcam] is: DISABLED"
}

# Function to check webcam status
check_webcam_status() {
    if lsmod | grep -q uvcvideo; then
        echo "Your Webcam is: ENABLED"
    else
        echo "Your Webcam is: DISABLED"
    fi
}

# Checks if the user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script needs to be run as root/superuser."
    exit 1
fi

while true; do
    show_menu
    check_webcam_status
    echo "======================="
    read -p "Choose an option (1/2/3): " choice

    case $choice in
        1)
            enable_webcam
            ;;
        2)
            disable_webcam
            ;;
        3)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Choose again."
            ;;
    esac
done
