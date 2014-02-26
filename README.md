docker-DNS
==========

An easy to configure Docker DNS Container for subnetworks created with Docker requiring no knowledge of how to configure the internal Bind service

##Plan:

###v1 Requirements: 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) Basic DNS setup:
    -Bind9 server installed and in an operable state 
    -Zone files to handle 'localhost', recursive queries to Google DNS servers, 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b) Ability to operate on an any arbitrary subnet 
    -Local IP address passed in on creation for zone file NS declarations 
    -Any node-specific named.conf options passed in on creation 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c) Ability to pass in an optional text file containing name-address pairs 
    -Runs script on startup to generate zone files from this text file if it exists 

###v2 Requirements: 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) Automatic reverse zone generation scripts installed and set to run on a schedule 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b) Probind Web GUI installed 

###v3 Requirements: 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) Passing in a .zip/.tar/.tar.gz of existing configurations(named.conf, zone files, etc) on creation 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b) Extensions to the passed in text file config: 
    -comments
    -separation of views
    -zone specific options for named.conf 

###v4 Requirements: 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) Extensions to the passed in text file config:
    -Ability to specify a slave by IP for any zone
     -Ability to specify that we are a slave for a zone and specify a master by IP
     -Ability to add system level config changes(i.e. toggle recursive queries, set upstream servers to something other than Google DNS servers, etc.) 

###v5 Requirements: 
####&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) Extensions to the passed in text file config:
    -Ability to add view level config changes 
    -Ability to add zone level config changes 
    
##Contributing
    Contact David Bruneau via bruneaud@bibliolabs.com if you would like to contribute to this project.
