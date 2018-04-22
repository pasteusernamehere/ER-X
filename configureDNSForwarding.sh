#!/bin/vbash
run="/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper"
safesearch="216.239.38.120"

$run begin

# Remove all dns forwarding config so that new config can be laid down.
$run delete service dns forwarding options

# Add DNS tag for devices that require DNS proxying
$run set service dns forwarding options dhcp-option=tag:USA,option:dns-server,169.53.182.120,169.54.78.85

#Rokus
$run set service dns forwarding options dhcp-mac=set:USA,c8:3a:6b:26:c8:76
$run set service dns forwarding options dhcp-mac=set:USA,88:de:a9:bc:0b:31
$run set service dns forwarding options dhcp-mac=set:USA,b8:3e:59:2a:95:15
$run set service dns forwarding options dhcp-mac=set:USA,b0:ee:7b:f4:40:95

$run set service dns forwarding options address=/.bing.com/204.79.197.220
$run set service dns forwarding options address=/.duckduckgo.com/0.0.0.0
$run set service dns forwarding options address=/.yahoo.com/0.0.0.0
$run set service dns forwarding options address=/.snapchat.com/0.0.0.0


# Forward all google search requests to safe search
echo Configuring Google search to utilize safe search for all known Google domains:

while read domain
do
    echo set service dns forwarding options address=/www"$domain"/$safesearch
    $run set service dns forwarding options address=/www"$domain"/$safesearch
done < <(curl -sL "https://www.google.com/supported_domains")

$run commit
$run save
$run end
