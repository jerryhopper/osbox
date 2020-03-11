#!/bin/bash

source /usr/share/osbox/variables
source /usr/lib/osbox/func/is_command
source /usr/lib/osbox/func/make_repo


if [ ! -f OSBOX_STATE_FILE ]; then
      echo "0">OSBOX_STATE_FILE
fi


OSBOX_ID=${$OSBOX_ID_FILE}
OSBOX_STATE=${$OSBOX_STATE_FILE}



if [ "$OSBOX_STATE" == "0" ]; then
    if $(is_command git) ; then
        echo  "git is available."
        echo "1">$OSBOX_STATE_FILE
        OSBOX_STATE = "1"
    else
        apt install git -y
        #/boot/dietpi/dietpi-software install 17 --unattended
        #echo 0 > /sys/class/leds/nanopi:red:pwr/brightness
        #echo 0 > /sys/class/leds/nanopi\:green\:status/brightness
        sleep 1
        #echo 1 > /sys/class/leds/nanopi\:green\:status/brightness
        reboot
    fi

fi



if [ "$OSBOX_STATE" == "1" ]; then
    if $(is_command lighttpd) ; then
        echo  "lighttpd is installed."
        # is blackbox installed?
        if [[ ! -d "/var/www/html/blackbox" ]] ; then
            echo "no blackbox webdir."
            mkdir -p /var/www/html/blackbox
            make_repo /var/www/html/blackbox https://github.com/jerryhopper/blackboxweb.git
            #echo "heartbeat" > /sys/class/leds/nanopi:red:pwr/trigger
            echo "2">$OSBOX_STATE_FILE
            OSBOX_STATE = "2"
        fi

    else
        echo "install started : lighttpd "
        /boot/dietpi/dietpi-software install 81 --unattended
        #apt install -y git
        echo "install finished : lighttpd">>/boot/log.txt
        sleep 1
        reboot

    fi
fi

if [ "$OSBOX_STATE" == "2" ]; then
    # git lighttpd
    apt-get -y install php-common php-sqlite3 php-xml php-intl php-zip php-mbstring php-gd php-apcu php-cgi composer dialog dhcpcd5 dnsutils lsof nmap netcat idn2 dns-root-data composer
    echo "3">$OSBOX_STATE_FILE
    OSBOX_STATE=3

fi

if [ "$OSBOX_STATE" == "3" ]; then
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
