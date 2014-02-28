domains = Array.new
zonesToAdd = Array.new
counter = 0

#is_num?
#Source: http://stackoverflow.com/questions/1235863/test-if-a-string-is-basically-an-integer-in-quotes-using-ruby
#Used to determine if the destination provided in userConfig is to an IP address or another name(are we making an 'A' or a 'CNAME' record?)
def is_num?(str)
  begin
    !!Integer(str)
  rescue ArgumentError, TypeError
    false
  end
end

begin
    #Read in userConfig
    file = File.new("/opt/dockerDNS/conf/userConfig", "r")
    while (line = file.gets)
	line = line.split(',')
	size = line.size-1
	for i in 0..size
		line[i] = line[i].strip()	
	end
	name = line[0]
	name=name.split('.')
	#The name we are mapping to a destinaiton must have a bottom, mid, and top level domain.  Otherwise we cannot determine which zone to place it in.  
	####FUTURE ADDITION: Allow users to specify the MLD and TLD for one address and then have it automatically append to any subsequent BLDs that do not override it
	if name.size < 3 then
		puts "Exception: /opt/dockerDNS/conf/userConfig line #{counter}: invalid name"
		exit
	end
	bld=name[0]
	#DETERMINE IF WE ARE MAKING A FORWARD RECORD OR A CNAME
	destination=line[line.size-1]
	destSplit = destination.split(".")
	recordType = ""
	#IF THE LAST SECTION OF THE DESTINATION ADDRESS IS NUMERICAL, WE HAVE AN IP ADDRESS, OTHERWISE WE HAVE A NAME 
	if is_num?(destSplit[destSplit.size-1]) then
		recordType = "A"
	else
		recordType = "CNAME"
	end
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
		destBld = destination.split(".")[0]
		if recordType == "A" then
			newZone	<< "#{bld}.#{domain}	IN	#{recordType}	#{destination}\n"
		else 
			newZone << "#{bld}	IN	#{recordType}	#{destSplit[0]}\n"
		end
		zonesToAdd  << domain
	else
		#Existing domain encountered, append new record to existing zone file
		fileName="#{domain}zone"
		existingZone = File.new("/tmp/bind/zones/#{fileName}","a+")
		puts "/tmp/bind/zones/#{fileName}"
		if recordType == "A" then
                        existingZone << "#{bld}.#{domain}    IN      #{recordType}   #{destination}\n"
                else
                        existingZone << "#{bld}      IN      #{recordType}   #{destSplit[0]}\n"
                end
	end
	counter = counter + 1
    end
    file.close
rescue => err
    puts "Exception: #{err}"
    err
end

#Create /etc/bind/named.conf with new zone definitions
namedConfFile = File.new("/tmp/bind/named.conf","a+")
namedConfFile << "include \"/etc/bind/named.conf.options\";\n"
namedConfFile << "include \"/etc/bind/named.conf.local\";\n"
namedConfFile << "include \"/etc/bind/named.conf.default-zones\";\n"
zonesToAdd.each { |x| 
	namedConfFile << "zone \"#{x}\" {\n"
        namedConfFile << "type master;\n"
        namedConfFile << "file \"/etc/bind/zones/#{x}zone\";\n"
	namedConfFile << "};\n"
}
