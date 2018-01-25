echo $1 $2 $3 $4

export DROPLET_IP="$1"
export DROPLET_USERNAME="$2"
export DROPLET_PASSWORD="$3"
export DROPLET_PORT="$4"

chown -R $DROPLET_USERNAME:$DROPLET_USERNAME /etc/ssh/$DROPLET_USERNAME

chmod 755 /etc/ssh/$DROPLET_USERNAME

chmod 644 /etc/ssh/$DROPLET_USERNAME/authorized_keys

sed -i -e "/^#AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile \/etc\/ssh\/"$DROPLET_USERNAME"\/authorized_keys/" /etc/ssh/sshd_config

sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config

sed -i -e '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config

sh -c 'echo "" >> /etc/ssh/sshd_config'

sh -c 'echo "" >> /etc/ssh/sshd_config'

sh -c 'echo "# Added by Katabasis build process" >> /etc/ssh/sshd_config'

sh -c 'echo "AllowUsers $DROPLET_USERNAME" >> /etc/ssh/sshd_config'

systemctl reload sshd

systemctl start firewalld

firewall-cmd --reload

systemctl enable firewalld

sed -i -e "/^Port/s/^.*$/Port "$DROPLET_PORT"/" /etc/ssh/sshd_config

firewall-cmd --add-port $DROPLET_PORT/tcp --permanent

firewall-cmd --reload

systemctl reload sshd

timedatectl set-timezone Asia/Kolkata

fallocate -l 3G /swapfile

chmod 600 /swapfile

mkswap /swapfile

sh -c "echo '/swapfile none swap sw 0 0' >> /etc/fstab"

sysctl vm.swappiness=10

sh -c "echo 'vm.swappiness=10' >> /etc/sysctl.conf"

sysctl vm.vfs_cache_pressure=30

sh -c 'echo "vm.vfs_cache_pressure=30" >> /etc/sysctl.conf'

sh -c 'echo "log_format timekeeper \$remote_addr - \$remote_user [\$time_local] " >> /etc/nginx/conf.d/timekeeper-log-format.conf'

sed -i "s/\$remote_addr/\'\$remote_addr/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/_local] /_local] \'/" /etc/nginx/conf.d/timekeeper-log-format.conf

sh -c 'echo "                      \$request \$status \$body_bytes_sent " >> /etc/nginx/conf.d/timekeeper-log-format.conf'

sed -i "s/\$request/\'\"\$request\"/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/_sent /_sent \'/" /etc/nginx/conf.d/timekeeper-log-format.conf

sh -c 'echo "                      \$http_referer \$http_user_agent \$http_x_forwarded_for \$request_time;" >> /etc/nginx/conf.d/timekeeper-log-format.conf'

sed -i "s/\$http_referer/\'\"\$http_referer\"/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/\$http_user_agent/\"\$http_user_agent\"/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/\$http_x_forwarded_for/\"\$http_x_forwarded_for\"/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/_time;/_time\';/" /etc/nginx/conf.d/timekeeper-log-format.conf

sh -c 'echo "geoip_country /usr/share/GeoIP/GeoIP.dat;" >> /etc/nginx/conf\.d/geoip.conf'

sed -i '/# Default server configuration/a \}' /etc/nginx/sites-available/default

sed -i '/# Default server configuration/a US yes;' /etc/nginx/sites-available/default

sed -i '/# Default server configuration/a default no;' /etc/nginx/sites-available/default

sed -i '/# Default server configuration/a map \$geoip_country_code \$allowed_country \{' /etc/nginx/sites-available/default

sed -i '/# Default server configuration/a \' /etc/nginx/sites-available/default

sed -i 's/US yes;/        US yes;/' /etc/nginx/sites-available/default

sed -i 's/default no;/        default no;/' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a \}#tmp_id_1' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a return 444;' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a if (\$allowed_country = no) \{' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a \' /etc/nginx/sites-available/default

sed -i 's/\}#tmp_id_1/        \}/' /etc/nginx/sites-available/default

sed -i 's/return 444;/                return 444;/' /etc/nginx/sites-available/default

sed -i 's/if (\$allowed_country = no)/        if (\$allowed_country = no)/' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a access_log \/var\/log\/nginx\/server-block-1-access\.log timekeeper gzip;' /etc/nginx/sites-available/default

sed -i 's/access_log \/var\/log\/nginx\/server-block-1-access\.log timekeeper gzip;/        access_log \/var\/log\/nginx\/server-block-1-access\.log timekeeper gzip;/' /etc/nginx/sites-available/default

sed -i '/access_log \/var\/log\/nginx\/server-block-1-access\.log timekeeper gzip;/a error_log \/var\/log\/nginx\/server-block-1-error\.log;' /etc/nginx/sites-available/default

sed -i 's/error_log \/var\/log\/nginx\/server-block-1-error\.log;/        error_log \/var\/log\/nginx\/server-block-1-error\.log;/' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a \' /etc/nginx/sites-available/default

sh -c "echo 'gzip_vary on;' >> /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_proxied any;' >> /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_comp_level 6;' >> /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_buffers 16 8k;' >> /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_http_version 1.1;' >> /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_min_length 256;' >> /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;' >> /etc/nginx/conf.d/gzip.conf"

nginx -t

systemctl start nginx

firewall-cmd --permanent --zone=public --add-service=http

firewall-cmd --permanent --zone=public --add-service=https

firewall-cmd --reload

systemctl enable nginx

systemctl enable fail2ban

sh -c 'echo "[DEFAULT]" >> /etc/fail2ban/jail.local'

sh -c 'echo "bantime = 7200" >> /etc/fail2ban/jail.local'

sh -c 'echo "findtime = 1200" >> /etc/fail2ban/jail.local'

sh -c 'echo "maxretry = 3" >> /etc/fail2ban/jail.local'

sh -c 'echo "destemail = <email_addr>" >> /etc/fail2ban/jail.local'

sh -c 'echo "sendername = security@<vps_name>" >> /etc/fail2ban/jail.local'

sh -c 'echo "banaction = iptables-multiport" >> /etc/fail2ban/jail.local'

sh -c 'echo "mta = sendmail" >> /etc/fail2ban/jail.local'

sh -c 'echo "action = %(banaction)s[name=%(__name__)s, bantime=\"%(bantime)s\", port=\"%(port)s\", protocol=\"%(protocol)s\", chain=\"%(chain)s\"], %(mta)s-whois-lines[name=%(__name__)s, dest=\"%(destemail)s\", logpath=%(logpath)s, chain=\"%(chain)s\"]" >> /etc/fail2ban/jail.local'

sh -c 'echo "" >> /etc/fail2ban/jail.local'

sh -c 'echo "[sshd]" >> /etc/fail2ban/jail.local'

sh -c 'echo "enabled = true" >> /etc/fail2ban/jail.local'

sh -c 'echo "" >> /etc/fail2ban/jail.local'

sh -c 'echo "" >> /etc/fail2ban/jail.local'

sh -c 'echo "[sshd-ddos]" >> /etc/fail2ban/jail.local'

sh -c 'echo "enabled = true" >> /etc/fail2ban/jail.local'

sh -c 'echo "" >> /etc/fail2ban/jail.local'

sh -c 'echo "[nginx-http-auth]" >> /etc/fail2ban/jail.local'

sh -c 'echo "enabled = true" >> /etc/fail2ban/jail.local'

systemctl restart fail2ban

echo "Congratulations !! Your Server is Up. Exit and Login as "
echo "ssh -p 1024 -L 8888:localhost:8000 user1@139.59.2.38"

cat /home/$DROPLET_USERANAME/.credentials | chpasswd

rm /home/$DROPLET_USERNAME/.credentials

su - postgres

psql

CREATE USER $DROPLET_USERNAME WITH PASSWORD '$DROPLET_PASSWORD';

CREATE DATABASE master OWNER $DROPLET_USERNAME;

\q

su - $DROPLET_USERNAME

$DROPLET_PASSWORD

psql master

CREATE TABLE market (

pk serial PRIMARY KEY,

time float,

open float,

high float,

low float,

close float,

volume integer

);
