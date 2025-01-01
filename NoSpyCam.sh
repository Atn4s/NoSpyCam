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
    modprobe uvcvideo
}

# Function to disable the webcam
disable_webcam() {
    # Check if any process is using a webcam
    if lsof /dev/video0 >/dev/null 2>&1; then
        echo "Application(s) are using the Webcam:"
        lsof /dev/video0
        echo "Do you want to close the application(s)? (Y/N):"
        read -r response

        if [[ $response =~ ^[Yy]$ ]]; then
            echo "Closing the application(s) that are using the Webcam"
            fuser -k /dev/video0
            sleep 2 # Wait a brief moment to ensure the application closes

        elif [[ $response =~ ^[Nn]$ ]]; then
            echo "Application not closed"
            sleep 2
        else
            echo "Invalid command. Try Again"
            sleep 2 
            clear
            disable_webcam
        fi
    fi
    modprobe -r uvcvideo
}

# Function to check webcam status
check_webcam_status() {
    if lsmod | grep -q uvcvideo; then
        echo "Your Webcam is currently: [ ENABLED ]"
    else
        echo "Your Webcam is currently: [ DISABLED ]"
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
            sleep 1
            clear
            break
            ;;
        *)
            echo "Invalid option. Choose again."
            ;;
    esac
done
