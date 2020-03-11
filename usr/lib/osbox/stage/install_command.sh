#!/bin/bash

# A function to clone a repo
make_repo() {
  echo "Make Repo"
    # Set named variables for better readability
    local directory="${1}"
    local remoteRepo="${2}"
    # The message to display when this function is running
    str="Clone ${remoteRepo} into ${directory}"
    # Display the message and use the color table to preface the message with an "info" indicator
    printf "  %b %s..." "${INFO}" "${str}"
    # If the directory exists,
    if [[ -d "${directory}" ]]; then
        # delete everything in it so git can clone into it
        rm -rf "${directory}"
    fi
    # Clone the repo and return the return code from this command
    git clone -q --depth 20 "${remoteRepo}" "${directory}" &> /dev/null || return $?
    # Show a colored message showing it's status
    printf "%b  %b %s\\n" "${OVER}" "${TICK}" "${str}"
    # Always return 0? Not sure this is correct
    return 0
}

make_repo /usr/share/osbox https://github.com/jerryhopper/osbox.git


if [ ! -f /var/lib/dietpi/postboot.d/postboot0.sh ]; then
    ln -s /usr/share/osbox/postboot0.sh /var/lib/dietpi/postboot.d/postboot0.sh
    chmod +x /var/lib/dietpi/postboot.d/postboot0.sh
fi

if [ ! -f /var/lib/dietpi/postboot.d/postboot1.sh ]; then
    ln -s /usr/share/osbox/postboot1.sh /var/lib/dietpi/postboot.d/postboot1.sh
    chmod +x /var/lib/dietpi/postboot.d/postboot1.sh
fi

