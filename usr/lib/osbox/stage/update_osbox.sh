#!/bin/bash



#########################################################################3
source /usr/share/osbox/variables
source /usr/lib/osbox/func/is_command
source /usr/lib/osbox/func/make_repo
source /usr/lib/osbox/func/update_repo
source /usr/lib/osbox/func/minfo
source /usr/lib/osbox/func/install_osboxweb
#########################################################################3


echo "Updateing OSBox core."

update_repo /usr/local/src/osbox

#make_repo /usr/local/src/osbox https://github.com/jerryhopper/osbox.git

