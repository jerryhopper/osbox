#!/bin/bash

#########################################################################3
source /usr/share/osbox/variables
source /usr/lib/osbox/func/is_command
source /usr/lib/osbox/func/make_repo
source /usr/lib/osbox/func/minfo
source /usr/lib/osbox/func/install_osboxweb
source /usr/lib/osbox/func/set_documentroot

#########################################################################3



# Check if statefile exists.
if [ ! -f $OSBOX_STATE_FILE ]; then
  mkdir $OSBOX_ETC
  echo "0">$OSBOX_STATE_FILE
  OSBOX_STATE="0"
else
  OSBOX_STATE=$(<$OSBOX_STATE_FILE)
fi




# run through the installation stages...




# hardware detection
if [ "$OSBOX_STATE" == "0" ]; then
  echo "State = 0"
  echo $(minfo)>$OSBOX_HARDWARE
  # Set state.
  echo "1">$OSBOX_STATE_FILE
  OSBOX_STATE="1"
fi




# doublecheck for git availability
if [ "$OSBOX_STATE" == "1" ]; then
  echo "State = 1"
    if $(is_command git) ; then
        #echo  "git is available."
        # Set state.
        echo "2" > $OSBOX_STATE_FILE
        OSBOX_STATE="2"
    else
        apt install git -y
        sleep 1
        reboot
    fi
fi



# install prerequisites
if [ "$OSBOX_STATE" == "2" ]; then
    echo "State = 2"
    apt-get -y install php-common php-sqlite3 php-xml php-intl php-zip php-mbstring php-gd php-apcu php-cgi composer dialog dhcpcd5 dnsutils lsof nmap netcat idn2 dns-root-data

    # Set state.
    echo "3" > $OSBOX_STATE_FILE
    OSBOX_STATE=3
fi


# install the osbox-web
if [ "$OSBOX_STATE" == "3" ]; then
    echo "State = 3"
    #telegram "INSTALLSTATE=$OSBOX_STATE Cloning blackbox.git"
    install_osboxweb
    # Set state.
    echo "4" > $OSBOX_STATE_FILE
    OSBOX_STATE=4

fi


# install the osbox-web
if [ "$OSBOX_STATE" == "4" ]; then
    #
    set_documentroot
    bash /usr/lib/osbox/stage/certcheck.sh

    echo "State = 4"
fi








if [ "$OSBOX_STATE" == "X" ]; then
        # is pihole installed?

        #copy_piholeftlconf
        #copy_piholesetupvarsconf


        # Set repo to V5 beta
        #echo "release/v5.0" | sudo tee /etc/pihole/ftlbranch

        if $(is_command pihole) ; then
            echo "PiHole is installed."

        else
            echo "Pihole is not installed"

        fi

fi
