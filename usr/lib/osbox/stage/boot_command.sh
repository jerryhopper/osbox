#!/bin/bash

#########################################################################3
source /usr/share/osbox/variables
source /usr/lib/osbox/func/is_command
source /usr/lib/osbox/func/set_ssl
source /usr/lib/osbox/func/make_repo
source /usr/lib/osbox/func/update_repo
source /usr/lib/osbox/func/minfo
source /usr/lib/osbox/func/install_osboxweb
source /usr/lib/osbox/func/set_documentroot
source /usr/lib/osbox/func/find_ipv4_information


source /usr/lib/osbox/stage/service_dhcpcd.sh
#########################################################################3



# Check if statefile exists.

if [ ! -d /etc/osbox ]; then
  mkdir /etc/osbox
fi


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
  echo "State = 0 | Hardware detection & initial state 0"
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
        update_repo /usr/local/src/osbox
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
    echo "State = 2 | apt-install prerequisites"
    apt-get -y install php-common php-sqlite3 php-xml php-intl php-zip php-mbstring php-gd php-apcu php-cgi composer dialog dhcpcd5 dnsutils lsof nmap netcat idn2 dns-root-data

    service_dhcpcd "disable"
    service_dhcpcd "stop"

    # Set state.
    echo "3" > $OSBOX_STATE_FILE
    OSBOX_STATE=3
fi


# install the osbox-web
if [ "$OSBOX_STATE" == "3" ]; then
    echo "State = 3 | install_osboxweb"
    #telegram "INSTALLSTATE=$OSBOX_STATE Cloning blackbox.git"
    install_osboxweb
    # Set state.
    echo "4" > $OSBOX_STATE_FILE
    OSBOX_STATE=4

fi


# install the osbox-web
if [ "$OSBOX_STATE" == "4" ]; then
    set_documentroot
    php /usr/lib/osbox/stage/certcheck.sh
    set_ssl

    # restart
    service lighttpd restart

    # Set state.
    echo "5" > $OSBOX_STATE_FILE
    OSBOX_STATE=5
fi

if [ "$OSBOX_STATE" == "5" ]; then

    source /usr/lib/osbox/pihole/ftl_conf
    source /usr/lib/osbox/pihole/adlists_list
    source /usr/lib/osbox/pihole/setupvars_conf

    #telegram "INSTALLSTATE=$INSTALLSTATE Installing Pihole configs and blocklists"
    find_IPv4_information
    piholesetupvarsconf
    piholeftlconf
    piholeadlists
    #copy_piholeftlconf
    #copy_piholesetupvarsconf

    # Set state.
    echo "6" > $OSBOX_STATE_FILE
    OSBOX_STATE=6
fi

if [ "$OSBOX_STATE" == "6" ]; then
    #telegram "INSTALLSTATE=$INSTALLSTATE Installing Pi-Hole from official repository"
    echo "install started : pihole">>/boot/log.txt
    curl -L https://install.pi-hole.net | bash /dev/stdin --unattended
    #curl -L https://raw.githubusercontent.com/jerryhopper/pi-hole/master/automated%20install/basic-install.sh  | bash /dev/stdin --unattended
    #curl -L https://github.com/jerryhopper/pi-hole/blob/release/v5.0/automated%20install/basic-install.sh  | bash /dev/stdin --unattended

    #telegram "install finished : pihole"
    echo "install finished : pihole">>/boot/log.txt
    echo "6" > $OSBOX_STATE
    OSBOX_STATE=6
fi

if [ "$OSBOX_STATE" == "6" ]; then
    #telegram "INSTALLSTATE=$INSTALLSTATE Finalizing installation."
    usermod -a -G pihole www-data

    if [ ! -f "/etc/pihole/ftlbranch" ] ; then
        #if [ "$(</etc/pihole/ftlbranch)" != "release/v5.0" ]; then

            # Set repo to V5 beta
            echo "release/v5.0" | sudo tee /etc/pihole/ftlbranch

            #telegram "INSTALLSTATE=$INSTALLSTATE Checking out release/v5 CORE"
            #devicelog "[v$VERSION] Checkout release/v5.0 CORE "
            echo "yes"|pihole checkout core release/v5.0

            #telegram "INSTALLSTATE=$OSBOX_STATE Checking out release/v5 WEB"
            #devicelog "[v$VERSION] Checkout release/v5.0 WEB "
            echo "yes"|pihole checkout web release/v5.0
        #fi

    fi

    #echo 'server.document-root        = "/var/www/html"'>/etc/lighttpd/external.conf
    #echo 'server.error-handler-404    = "/blackbox/index.php"'>>/etc/lighttpd/external.conf




    #devicelog "[v$VERSION] Usermod "

    usermod -a -G pihole www-data
    #devicelog "[v$VERSION] edit lighttpd "
    #sed -i -e 's/pihole\/index.php/blackbox\/index.php/g' /etc/lighttpd/lighttpd.conf
    #sed -i -e 's/"\/var\/www"/"\/var\/www\/html"/g' /etc/lighttpd/lighttpd.conf

    #echo "www-data ALL=NOPASSWD: /usr/sbin/blackbox">/etc/sudoers.d/blackbox

    #telegram "INSTALLSTATE=$INSTALLSTATE create postboot"

    #createpostboot

    service lighttpd restart
    echo "7" > $OSBOX_STATE
    OSBOX_STATE=7
    telegram "INSTALLSTATE=$INSTALLSTATE"
    #reboot
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
