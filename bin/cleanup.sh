#Run this before commits!
service bind9 stop
rm -rf /etc/bind/zones/*
rm -rf /opt/dockerDNS/conf/*
rm -rf /tmp/bind/*
rm -rf /tmp/bind/zones/*
