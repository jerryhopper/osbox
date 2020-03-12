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


bash /usr/lib/osbox/stage/boot_command.sh
