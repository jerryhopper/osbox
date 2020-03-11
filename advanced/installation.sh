#!/bin/bash


# A function to clone a repo
make_repo() {
  echo "make repo"
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



if [ ! -d "/usr/local/src/osbox" ]; then
  make_repo /usr/local/src/osbox https://github.com/jerryhopper/osbox.git

  #     Excecutable     Real location
  ln -s /usr/sbin/osbox /usr/local/src/osbox/usr/sbin/osbox
  chmod +x /usr/sbin/osbox

  ln -s /usr/share/osbox /usr/share/osbox/usr/share/osbox

fi
