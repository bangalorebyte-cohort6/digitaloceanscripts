################################################################################
#                                                                              #
#   Katabasis is licensed under the GNU General Public License, version 2.0.   #
#                                                                              #
################################################################################

################################################################################
#                                                                              #
# *++*+++***+**++*+++*|%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|*+++*++**+***+++*++* #
# ++*+++***+**++*+++**|%%%|                          |%%%|**+++*++**+***+++*++ #
# +*+++***+**++*+++***|%%%|                     preA |%%%|***+++*++**+***+++*+ #
# *+++***+**++*+++***+|%%%|    K A T A B A S I S     |%%%|+***+++*++**+***+++* #
# +++***+**++*+++***++|%%%|                          |%%%|++***+++*++**+***+++ #
# ++***+**++*+++***+++|%%%|                          |%%%|+++***+++*++**+***++ #
# +***+**++*+++***+++*|%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|*+++***+++*++**+***+ #
#                                                                              #
# You will need the following information:                                     #
# ~ your email address (hereafter: &lt;email_addr&gt;)                               #
# ~ your server's internet protocol address (hereafter: &lt;vps_ip_addr&gt;)         #
# ~ your server's name (hereafter: &lt;vps_name&gt;)                                 #
#                                                                              #
# Be advised:                                                                  #
# ~ &lt;os_username&gt; must be a string that is not "root"                          #
# ~ &lt;os_password&gt; should be a string that is longer than eight characters      #
# ~ &lt;defined_ssh_port&gt; must be an integer that is between 1024 and 65535       #
#                                                                              #
################################################################################

# ::|\ _______ /|::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| |       | |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| | local | |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| !_______! |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::!/         \!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #

ssh-keygen -t rsa

sh -c 'echo "&lt;os_username&gt;:&lt;os_password&gt;" &gt;&gt; .credentials'

ssh root@&lt;vps_ip_addr&gt;

# ::|\ ________ /|:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| |        | |:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| | remote | |:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| !________! |:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::!/          \!:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #

yes

sh -c 'echo "set const" &gt;&gt; .nanorc'

sh -c 'echo "set tabsize 8" &gt;&gt; .nanorc'

sh -c 'echo "set tabstospaces" &gt;&gt; .nanorc'

adduser --disabled-password --gecos "" &lt;os_username&gt;

usermod -aG sudo &lt;os_username&gt;

cp .nanorc /home/&lt;os_username&gt;/

mkdir /etc/ssh/&lt;os_username&gt;

exit

# ::|\ _______ /|::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| |       | |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| | local | |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| !_______! |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::!/         \!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #

scp .ssh/id_rsa.pub root@&lt;vps_ip_addr&gt;:/etc/ssh/&lt;os_username&gt;/authorized_keys

scp .credentials root@&lt;vps_ip_addr&gt;:/home/&lt;os_username&gt;/

ssh root@&lt;vps_ip_addr&gt;

# ::|\ ________ /|:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| |        | |:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| | remote | |:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::| !________! |:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #
# ::!/          \!:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: #

chown -R &lt;os_username&gt;:&lt;os_username&gt; /etc/ssh/&lt;os_username&gt;

chmod 755 /etc/ssh/&lt;os_username&gt;

chmod 644 /etc/ssh/&lt;os_username&gt;/authorized_keys

sed -i -e '/^#AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile \/etc\/ssh\/&lt;os_username&gt;\/authorized_keys/' /etc/ssh/sshd_config

sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config

sed -i -e '/^PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config

sh -c 'echo "" &gt;&gt; /etc/ssh/sshd_config'

sh -c 'echo "" &gt;&gt; /etc/ssh/sshd_config'

sh -c 'echo "# Added by Katabasis build process" &gt;&gt; /etc/ssh/sshd_config'

sh -c 'echo "AllowUsers &lt;os_username&gt;" &gt;&gt; /etc/ssh/sshd_config'

systemctl reload sshd

apt-get -y install firewalld

systemctl start firewalld

firewall-cmd --reload

systemctl enable firewalld

sed -i -e '/^Port/s/^.*$/Port &lt;defined_ssh_port&gt;/' /etc/ssh/sshd_config

firewall-cmd --add-port &lt;defined_ssh_port&gt;/tcp --permanent

firewall-cmd --reload

systemctl reload sshd

timedatectl set-timezone America/New_York

apt-get -y install ntp

fallocate -l 3G /swapfile

chmod 600 /swapfile

mkswap /swapfile

sh -c "echo '/swapfile none swap sw 0 0' &gt;&gt; /etc/fstab"

sysctl vm.swappiness=10

sh -c "echo 'vm.swappiness=10' &gt;&gt; /etc/sysctl.conf"

sysctl vm.vfs_cache_pressure=30

sh -c 'echo "vm.vfs_cache_pressure=30" &gt;&gt; /etc/sysctl.conf'

apt-get -y install nginx

sh -c 'echo "log_format timekeeper \$remote_addr - \$remote_user [\$time_local] " &gt;&gt; /etc/nginx/conf.d/timekeeper-log-format.conf'

sed -i "s/\$remote_addr/\'\$remote_addr/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/_local] /_local] \'/" /etc/nginx/conf.d/timekeeper-log-format.conf

sh -c 'echo "                      \$request \$status \$body_bytes_sent " &gt;&gt; /etc/nginx/conf.d/timekeeper-log-format.conf'

sed -i "s/\$request/\'\"\$request\"/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/_sent /_sent \'/" /etc/nginx/conf.d/timekeeper-log-format.conf

sh -c 'echo "                      \$http_referer \$http_user_agent \$http_x_forwarded_for \$request_time;" &gt;&gt; /etc/nginx/conf.d/timekeeper-log-format.conf'

sed -i "s/\$http_referer/\'\"\$http_referer\"/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/\$http_user_agent/\"\$http_user_agent\"/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/\$http_x_forwarded_for/\"\$http_x_forwarded_for\"/" /etc/nginx/conf.d/timekeeper-log-format.conf

sed -i "s/_time;/_time\';/" /etc/nginx/conf.d/timekeeper-log-format.conf

sh -c 'echo "geoip_country /usr/share/GeoIP/GeoIP.dat;" &gt;&gt; /etc/nginx/conf\.d/geoip.conf'

sed -i '/# Default server configuration/a \}' /etc/nginx/sites-available/default

sed -i '/# Default server configuration/a US yes;' /etc/nginx/sites-available/default

sed -i '/# Default server configuration/a default no;' /etc/nginx/sites-available/default

sed -i '/# Default server configuration/a map \$geoip_country_code \$allowed_country \{' /etc/nginx/sites-available/default

sed -i '/# Default server configuration/a \

' /etc/nginx/sites-available/default

sed -i 's/US yes;/        US yes;/' /etc/nginx/sites-available/default

sed -i 's/default no;/        default no;/' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a \}#tmp_id_1' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a return 444;' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a if (\$allowed_country = no) \{' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a \

' /etc/nginx/sites-available/default

sed -i 's/\}#tmp_id_1/        \}/' /etc/nginx/sites-available/default

sed -i 's/return 444;/                return 444;/' /etc/nginx/sites-available/default

sed -i 's/if (\$allowed_country = no)/        if (\$allowed_country = no)/' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a access_log \/var\/log\/nginx\/server-block-1-access\.log timekeeper gzip;' /etc/nginx/sites-available/default

sed -i 's/access_log \/var\/log\/nginx\/server-block-1-access\.log timekeeper gzip;/        access_log \/var\/log\/nginx\/server-block-1-access\.log timekeeper gzip;/' /etc/nginx/sites-available/default

sed -i '/access_log \/var\/log\/nginx\/server-block-1-access\.log timekeeper gzip;/a error_log \/var\/log\/nginx\/server-block-1-error\.log;' /etc/nginx/sites-available/default

sed -i 's/error_log \/var\/log\/nginx\/server-block-1-error\.log;/        error_log \/var\/log\/nginx\/server-block-1-error\.log;/' /etc/nginx/sites-available/default

sed -i '/listen \[::\]:80 default_server;/a \

' /etc/nginx/sites-available/default

# sed -i -e '/^#    server {/s/^.*$/    server {/' /etc/nginx/nginx.conf

# sed -i -e '/^#        listen       443 ssl http2 default_server;/s/^.*$/        listen       443 ssl http2 default_server;/' /etc/nginx/nginx.conf

# sed -i -e '/^#        listen       \[::\]:443 ssl http2 default_server;/s/^.*$/        listen       \[::\]:443 ssl http2 default_server;/' /etc/nginx/nginx.conf

# sed -i -e '/^#        server_name  _;/s/^.*$/        server_name  _;/' /etc/nginx/nginx.conf

# sed -i -e '/^#        root         \/usr\/share\/nginx\/html;/s/^.*$/        root         \/usr\/share\/nginx\/html;#tmp_id_2/' /etc/nginx/nginx.conf

# sed -i '/^        root         \/usr\/share\/nginx\/html;#tmp_id_2/a resolver 8\.8\.8\.8 8\.8\.4\.4 208\.67\.222\.222 208\.67\.220\.220 216\.146\.35\.35 216\.146\.36\.36 valid=300s;' /etc/nginx/nginx.conf

# sed -i 's/resolver 8\.8\.8\.8 8\.8\.4\.4 208\.67\.222\.222 208\.67\.220\.220 216\.146\.35\.35 216\.146\.36\.36 valid=300s;/        resolver 8\.8\.8\.8 8\.8\.4\.4 208\.67\.222\.222 208\.67\.220\.220 216\.146\.35\.35 216\.146\.36\.36 valid=300s;/' /etc/nginx/nginx.conf

# sed -i '/^        resolver 8\.8\.8\.8 8\.8\.4\.4 208\.67\.222\.222 208\.67\.220\.220 216\.146\.35\.35 216\.146\.36\.36 valid=300s;/a resolver_timeout 3s;' /etc/nginx/nginx.conf

# sed -i 's/resolver_timeout 3s;/        resolver_timeout 3s;/' /etc/nginx/nginx.conf

# sed -i '/^        root         \/usr\/share\/nginx\/html;#tmp_id_2/a \

# #' /etc/nginx/nginx.conf

# sed -i '/^        root         \/usr\/share\/nginx\/html;#tmp_id_2/a #        add_header Strict-Transport-Security \"max-age=31536000; includeSubDomains; preload\";' /etc/nginx/nginx.conf

# sed -i '/^        root         \/usr\/share\/nginx\/html;#tmp_id_2/a add_header Strict-Transport-Security \"max-age=31536000\";' /etc/nginx/nginx.conf

# sed -i 's/add_header Strict-Transport-Security \"max-age=31536000\";/        add_header Strict-Transport-Security \"max-age=31536000\";/' /etc/nginx/nginx.conf

# sed -i '/^        root         \/usr\/share\/nginx\/html;#tmp_id_2/a add_header X-Frame-Options DENY;' /etc/nginx/nginx.conf

# sed -i 's/add_header X-Frame-Options DENY;/        add_header X-Frame-Options DENY;/' /etc/nginx/nginx.conf

# sed -i '/^        root         \/usr\/share\/nginx\/html;#tmp_id_2/a add_header X-Content-Type-Options nosniff;' /etc/nginx/nginx.conf

# sed -i 's/add_header X-Content-Type-Options nosniff;/        add_header X-Content-Type-Options nosniff;/' /etc/nginx/nginx.conf

# sed -i '/^        root         \/usr\/share\/nginx\/html;#tmp_id_2/a \

# #' /etc/nginx/nginx.conf

# sed -i -e '/^#        ssl_certificate "\/etc\/pki\/nginx\/server\.crt";/s/^.*$/        ssl_certificate "\/etc\/pki\/nginx\/server\.crt";/' /etc/nginx/nginx.conf

# sed -i -e '/^#        ssl_certificate_key "\/etc\/pki\/nginx\/private\/server\.key";/s/^.*$/        ssl_certificate_key "\/etc\/pki\/nginx\/private\/server\.key";#tmp_id_6/' /etc/nginx/nginx.conf

# sed -i '/^        ssl_certificate_key \"\/etc\/pki\/nginx\/private\/server\.key\";#tmp_id_6/a ssl_protocols TLSv1 TLSv1\.1 TLSv1\.2;' /etc/nginx/nginx.conf

# sed -i 's/ssl_protocols TLSv1 TLSv1\.1 TLSv1\.2;/        ssl_protocols TLSv1 TLSv1\.1 TLSv1\.2;/' /etc/nginx/nginx.conf

# sed -i '/^        ssl_certificate_key \"\/etc\/pki\/nginx\/private\/server\.key\";#tmp_id_6/a ssl_ecdh_curve secp384r1;' /etc/nginx/nginx.conf

# sed -i 's/ssl_ecdh_curve secp384r1;/        ssl_ecdh_curve secp384r1;/' /etc/nginx/nginx.conf

# sed -i -e '/^#        ssl_session_cache shared:SSL:1m;/s/^.*$/        ssl_session_cache shared:SSL:1m;/' /etc/nginx/nginx.conf

# sed -i -e '/^#        ssl_session_timeout  10m;/s/^.*$/        ssl_session_timeout  10m;/' /etc/nginx/nginx.conf

# sed -i -e '/^#        ssl_ciphers HIGH:!aNULL:!MD5;/s/^.*$/        ssl_ciphers \"EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH\";/' /etc/nginx/nginx.conf

# sed -i -e '/^#        ssl_prefer_server_ciphers on;/s/^.*$/        ssl_prefer_server_ciphers on;/' /etc/nginx/nginx.conf

# sed -i -e '/^#        # Load configuration files for the default server block\./s/^.*$/        # Load configuration files for the default server block\./' /etc/nginx/nginx.conf

# sed -i -e '/^#        include \/etc\/nginx\/default\.d\/\*\.conf;/s/^.*$/        include \/etc\/nginx\/default\.d\/\*\.conf;#tmp_id_3/' /etc/nginx/nginx.conf

# sed -i '/^        include \/etc\/nginx\/default\.d\/\*\.conf;#tmp_id_3/a \}#tmp_id_7' /etc/nginx/nginx.conf

# sed -i 's/\}#tmp_id_7/        \}#tmp_id_7/' /etc/nginx/nginx.conf

# sed -i '/^        include \/etc\/nginx\/default\.d\/\*\.conf;#tmp_id_3/a return 444;#tmp_id_4' /etc/nginx/nginx.conf

# sed -i 's/return 444;#tmp_id_4/            return 444;#tmp_id_4/' /etc/nginx/nginx.conf

# sed -i '/^        include \/etc\/nginx\/default\.d\/\*\.conf;#tmp_id_3/a if (\$allowed_country = no) \{#tmp_id_8' /etc/nginx/nginx.conf

# sed -i 's/if (\$allowed_country = no) {#tmp_id_8/        if (\$allowed_country = no) {#tmp_id_8/' /etc/nginx/nginx.conf

# sed -i '/^        include \/etc\/nginx\/default\.d\/\*\.conf;#tmp_id_3/a \

# #' /etc/nginx/nginx.conf

# sed -i '/^        include \/etc\/nginx\/default\.d\/\*\.conf;#tmp_id_3/a access_log \/var\/log\/nginx\/server-block-1-access.log  timekeeper;#tmp_id_9' /etc/nginx/nginx.conf

# sed -i -e 's/access_log \/var\/log\/nginx\/server-block-1-access.log  timekeeper;#tmp_id_9/        access_log \/var\/log\/nginx\/server-block-1-access.log  timekeeper;#tmp_id_9/' /etc/nginx/nginx.conf

# sed -i '/access_log \/var\/log\/nginx\/server-block-1-access.log  timekeeper;#tmp_id_9/a error_log \/var\/log\/nginx\/server-block-1-error.log;#tmp_id_10' /etc/nginx/nginx.conf

# sed -i -e 's/error_log \/var\/log\/nginx\/server-block-1-error.log;#tmp_id_10/        error_log \/var\/log\/nginx\/server-block-1-error.log;#tmp_id_10/' /etc/nginx/nginx.conf

# sed -i '/^        include \/etc\/nginx\/default\.d\/\*\.conf;#tmp_id_3/a \

# #' /etc/nginx/nginx.conf

# sed -i -e '/^#        location \/ {/s/^.*$/        location \/ {/' /etc/nginx/nginx.conf

# sed -i -e '/^#        }/s/^.*$/        }/' /etc/nginx/nginx.conf

# sed -i -e '/^#        error_page 404 \/404.html;/s/^.*$/        error_page 404 \/404.html;/' /etc/nginx/nginx.conf

# sed -i -e '/^#            location = \/40x.html {/s/^.*$/            location = \/40x.html {/' /etc/nginx/nginx.conf

# sed -i -e '/^#        error_page 500 502 503 504 \/50x.html;/s/^.*$/        error_page 500 502 503 504 \/50x.html;/' /etc/nginx/nginx.conf

# sed -i -e '/^#            location = \/50x.html {/s/^.*$/            location = \/50x.html {/' /etc/nginx/nginx.conf

# sed -i -e '/^#    }/s/^.*$/    }/' /etc/nginx/nginx.conf

sh -c "echo 'gzip_vary on;' &gt;&gt; /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_proxied any;' &gt;&gt; /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_comp_level 6;' &gt;&gt; /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_buffers 16 8k;' &gt;&gt; /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_http_version 1.1;' &gt;&gt; /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_min_length 256;' &gt;&gt; /etc/nginx/conf.d/gzip.conf"

sh -c "echo 'gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;' &gt;&gt; /etc/nginx/conf.d/gzip.conf"

nginx -t

systemctl start nginx

firewall-cmd --permanent --zone=public --add-service=http

firewall-cmd --permanent --zone=public --add-service=https

firewall-cmd --reload

systemctl enable nginx

apt-get -y install fail2ban

systemctl enable fail2ban

sh -c 'echo "[DEFAULT]" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "bantime = 7200" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "findtime = 1200" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "maxretry = 3" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "destemail = &lt;email_addr&gt;" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "sendername = security@&lt;vps_name&gt;" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "banaction = iptables-multiport" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "mta = sendmail" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "action = %(banaction)s[name=%(__name__)s, bantime=\"%(bantime)s\", port=\"%(port)s\", protocol=\"%(protocol)s\", chain=\"%(chain)s\"], %(mta)s-whois-lines[name=%(__name__)s, dest=\"%(destemail)s\", logpath=%(logpath)s, chain=\"%(chain)s\"]" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "[sshd]" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "enabled = true" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "[sshd-ddos]" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "enabled = true" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "[nginx-http-auth]" &gt;&gt; /etc/fail2ban/jail.local'

sh -c 'echo "enabled = true" &gt;&gt; /etc/fail2ban/jail.local'

systemctl restart fail2ban

cat /home/&lt;os_username&gt;/.credentials | chpasswd

rm /home/&lt;os_username&gt;/.credentials

sudo apt-get -y install postgresql postgresql-contrib

su - postgres

psql

CREATE USER &lt;os_username&gt; WITH PASSWORD '&lt;os_password&gt;';

CREATE DATABASE master OWNER &lt;os_username&gt;;

\q

su - &lt;os_username&gt;

&lt;os_password&gt;

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
