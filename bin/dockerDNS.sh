cp -r /etc/bind /tmp/
/bin/sh /opt/dockerDNS/bin/selfConfig.sh
/usr/bin/ruby /opt/dockerDNS/bin/importer.rb
cp -r /tmp/bind /etc/
