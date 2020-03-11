

install_osboxweb() {
    echo "mkdir "
    if [ ! -d "/var/www/html/osbox" ]; then
        mkdir -p /var/www/html/osbox
    fi
    echo "makerepo"
    make_repo /var/www/html/osbox https://github.com/jerryhopper/blackboxweb.git

    echo "composer install"
    composer install -d /var/www/html/osbox

}
