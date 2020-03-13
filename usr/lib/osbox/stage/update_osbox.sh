#!/bin/bash



#########################################################################3
source /usr/share/osbox/variables
source /usr/lib/osbox/func/is_command
source /usr/lib/osbox/func/make_repo
source /usr/lib/osbox/func/update_repo
source /usr/lib/osbox/func/minfo
source /usr/lib/osbox/func/install_osboxweb
#########################################################################3
if [ ! -f $OSBOX_STATE_FILE ]; then
  echo "ERROR: Cannot update when not installed! ($OSBOX_STATE_FILE)"
  echo "Try the command : osbox install"
  exit 1
fi

echo "Current state : $(<$OSBOX_STATE_FILE)"
echo ". "
echo "Updateing OSBox core."

make_repo /usr/local/src/osbox https://github.com/jerryhopper/osbox.git
#update_repo /usr/local/src/osbox
chmod +x /usr/sbin/osbox

echo ". "
echo "Updating OSBox web."
make_repo /var/www/html/osbox https://github.com/jerryhopper/blackboxweb.git
#update_repo /var/www/html/osbox

echo ". "
echo "Updating Composer dependencies."
composer update -d /var/www/html/osbox



#chmod +x /usr/sbin/osbox

#make_repo /usr/local/src/osbox https://github.com/jerryhopper/osbox.git

