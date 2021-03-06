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


echo "start"

#if [ ! -d "/usr/local/src/osbox" ]; then
  rm -rf /etc/osbox/osbox.state
  rm -rf /etc/osbox/osbox.id
  rm -rf /etc/osbox/osbox.hw
  rm -rf /etc/osbox/osbox.conf
  rm -rf /etc/osbox/osbox.owner
  rm -rf /etc/osbox/db/osbox.db


  rm -rf /usr/sbin/osbox
  rm -rf /usr/share/osbox
  rm -rf /usr/local/src/osbox
  rm -rf /usr/lib/osbox
  rm -rf /var/lib/dietpi/postboot.d/postboot0.sh
  rm -rf /var/lib/dietpi/postboot.d/postboot1.sh


  make_repo /usr/local/src/osbox https://github.com/jerryhopper/osbox.git

  #     Excecutable     new location
  ln -s /usr/local/src/osbox/usr/sbin/osbox /usr/sbin/osbox
  chmod +x /usr/sbin/osbox

  ln -s /usr/local/src/osbox/usr/share/osbox /usr/share/osbox
  ln -s /usr/local/src/osbox/usr/lib/osbox /usr/lib/osbox
#fi
  osbox install
