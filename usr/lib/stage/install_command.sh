

if [ ! -f /var/lib/dietpi/postboot.d/postboot0.sh ]; then
    ln -s /var/lib/dietpi/postboot.d/postboot0.sh /usr/share/osbox/postboot0.sh
    chmod +x /var/lib/dietpi/postboot.d/postboot0.sh
fi

if [ ! -f /var/lib/dietpi/postboot.d/postboot1.sh ]; then
    ln -s /var/lib/dietpi/postboot.d/postboot1.sh /usr/share/osbox/postboot1.sh
    chmod +x /var/lib/dietpi/postboot.d/postboot1.sh
fi

