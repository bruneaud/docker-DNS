domains = Array.new
counter = 0
begin
    file = File.new("/opt/dockerDNS/conf/userConfig", "r")
    while (line = file.gets)
	line = line.split(',')
	name = line[0]
	name=name.split('.')
	if name.size < 3 then
		puts "Exception: /opt/dockerDNS/conf/userConfig line #{counter}: invalid name"
		exit
	end
	bld=name[0]
	address=line[line.size-1]
	domain=''
	counter2=0
	name.each { |x| 
		if counter2 !=0 then
			domain=domain<<"#{x}."
		end
		counter2 = counter2 + 1
	}
	if !domains.include? domain then
		#New domain encountered, created new zone file, add zone declaration to named.conf
		domains << domain
	
		domain = domain
		fileName="#{domain}zone"
		newZone = File.new("/tmp/bind/zones/#{fileName}","w+")
		newZone << "$TTL 2d\n"
		newZone << "$ORIGIN #{domain}\n"
		newZone << "@	IN	SOA	ns1.#{domain}	hostmaster.#{domain} (\n"
		newZone << "1;	serial number\n"
		newZone << "12h;	refresh\n"
		newZone << "15w;	refresh retry\n"
		newZone << "3w;	; expiry\n"
		newZone << "2h; nxdomain\n"
		newZone << ")\n"
		newZone << "@	IN	NS	ns1.#{domain}\n"
		newZone << "ns1.#{domain}	IN	A	127.0.0.1\n"
		newZone	<< "#{bld}.#{domain}	IN	A	#{address}\n"
	else
		#Existing domain encountered, append record to existing zone file
	end
	counter = counter + 1
    end
    file.close
rescue => err
    puts "Exception: #{err}"
    err
end
