/etc/init.d/bind9 stop
rm -rf /etc/bind/tmp/bind/*
cp -r /etc/bind /tmp/
rm /tmp/bind/named.conf
/bin/sh /opt/dockerDNS/bin/selfConfig.sh
/usr/bin/ruby /opt/dockerDNS/bin/importer.rb
cp -r /tmp/bind /etc/
chown -R bind:bind /etc/bind
/etc/init.d/bind9 start
