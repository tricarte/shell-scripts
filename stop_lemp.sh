#!/usr/bin/env bash

if [[ ! -f "/usr/bin/update-alternatives" ]]
then
    echo "Err: This system is not based on Debian or Ubuntu."
    exit 1
fi

if [[ ! -f "/usr/bin/systemctl" ]]
then
    echo "Err: This system is not based on systemd."
    exit 1
fi

# /run/php/php7.4-fpm.sock
default_fpm=$(update-alternatives --quiet --query php-fpm.sock | grep Value | cut -d" " -f2)

# php7.4-fpm.sock
fpmfname=$(basename "$default_fpm")

# Remove '.sock' from above
fpmfname=${fpmfname%.sock}
# Now we have 'php7.4-fpm'

phpfpm_service_name="${fpmfname}.service"
sudo systemctl stop "$phpfpm_service_name"
echo "Stopping service: $phpfpm_service_name ... DONE!"

sudo systemctl stop mariadb.service
echo "Stopping service: mariadb.service.service ... DONE!"

# Stop MailHog
sudo systemctl stop mailhog
echo "Stopping service: mailhog ... DONE!"
# sudo systemctl stop nginx.service
