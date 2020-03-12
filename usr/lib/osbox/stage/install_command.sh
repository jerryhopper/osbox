#!/bin/bash


if [ ! -f /usr/sbin/osbox ]; then
  ln -s /usr/local/src/osbox/usr/sbin/osbox /usr/sbin/osbox
  chmod +x /usr/sbin/osbox
fi

if [ ! -f /usr/share/osbox ]; then
  ln -s /usr/local/src/osbox/usr/share/osbox /usr/share/osbox
fi

if [ ! -f /usr/lib/osbox ]; then
  ln -s /usr/local/src/osbox/usr/lib/osbox /usr/lib/osbox
fi

if [ ! -f /var/lib/dietpi/postboot.d/postboot0.sh ]; then
    ln -s /usr/share/osbox/postboot0.sh /var/lib/dietpi/postboot.d/postboot0.sh
    chmod +x /var/lib/dietpi/postboot.d/postboot0.sh
fi

if [ ! -f /var/lib/dietpi/postboot.d/postboot1.sh ]; then
    ln -s /usr/share/osbox/postboot1.sh /var/lib/dietpi/postboot.d/postboot1.sh
    chmod +x /var/lib/dietpi/postboot.d/postboot1.sh
fi

#########################################################################3
source /usr/share/osbox/variables
source /usr/lib/osbox/func/is_command
source /usr/lib/osbox/func/make_repo
source /usr/lib/osbox/func/minfo
source /usr/lib/osbox/func/install_osboxweb.cmd
#########################################################################3




if [ ! -f $OSBOX_STATE_FILE ]; then
  mkdir $OSBOX_ETC
  echo "0">$OSBOX_STATE_FILE
  OSBOX_STATE="0"
else
  OSBOX_STATE=$(<$OSBOX_STATE_FILE)
fi



if [ "$OSBOX_STATE" == "0" ]; then
  echo "State = 0"
  echo $(minfo)>$OSBOX_HARDWARE
  # Set state.
  echo "1">$OSBOX_STATE_FILE
  OSBOX_STATE="1"
fi



if [ "$OSBOX_STATE" == "1" ]; then
  echo "State = 1"
    if $(is_command git) ; then
        echo  "git is available."
        # Set state.
        echo "2" > $OSBOX_STATE_FILE
        OSBOX_STATE="2"
    else
        apt install git -y
        sleep 1
        reboot
    fi
fi




if [ "$OSBOX_STATE" == "2" ]; then
    echo "State = 2"
    #telegram "INSTALLSTATE=$OSBOX_STATE apt-get install prerequisites"
    # git lighttpd
    apt-get -y install php-common php-sqlite3 php-xml php-intl php-zip php-mbstring php-gd php-apcu php-cgi composer dialog dhcpcd5 dnsutils lsof nmap netcat idn2 dns-root-data >/dev/null

    # Set state.
    echo "3" > $OSBOX_STATE_FILE
    OSBOX_STATE=3
fi






if [ "$OSBOX_STATE" == "3" ]; then
    echo "State = 3"
    #telegram "INSTALLSTATE=$OSBOX_STATE Cloning blackbox.git"
    install_osboxweb
    # Set state.
    echo "4" > $OSBOX_STATE_FILE
    OSBOX_STATE=4

fi

