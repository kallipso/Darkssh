#!/bin/bash
## change to "bin/sh" when necessary

auth_email="authemail"                                       # The email used to login 'https://dash.cloudflare.com'
auth_method="global"                                 # Set to "global" for Global API Key or "token" for Scoped API Token
auth_key="authemailkey"                                         # Your API Token or Global API Key
zone_identifier="zonekey"                                  # Can be found in the "Overview" tab of your domain
record_name="recordsite"                                      # Which record you want to be synced
ttl="300"                                          # Set the DNS TTL (seconds)
proxy="false"                                     # Set the proxy to true or false
TELEGRAM_TOKEN="teletok"
CHAT_ID="telidd"


###########################################
## Check if we have a public IP
###########################################
ipv4_regex='([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])'
ip=$(curl -s -4 https://cloudflare.com/cdn-cgi/trace | grep -E '^ip'); ret=$?
if [[ ! $ret == 0 ]]; then # In the case that cloudflare failed to return an ip.
    # Attempt to get the ip from other websites.
    ip=$(curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com)
else
    # Extract just the ip from the ip line from cloudflare.
    ip=$(echo $ip | sed -E "s/^ip=($ipv4_regex)$/\1/")
fi

# Use regex to check for proper IPv4 format.
if [[ ! $ip =~ ^$ipv4_regex$ ]]; then
    logger -s "DDNS Updater: Failed to find a valid IP."
    exit 2
fi

###########################################
## Check and set the proper auth header
###########################################
if [[ "${auth_method}" == "global" ]]; then
  auth_header="X-Auth-Key:"
else
  auth_header="Authorization: Bearer"
fi

###########################################
## Seek for the A record
###########################################

logger "DDNS Updater: Check Initiated"
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?type=A&name=$record_name" \
                      -H "X-Auth-Email: $auth_email" \
                      -H "$auth_header $auth_key" \
                      -H "Content-Type: application/json")

###########################################
## Check if the domain has an A record
###########################################
if [[ $record == *"\"count\":0"* ]]; then
  logger -s "DDNS Updater: Record does not exist, perhaps create one first? (${ip} for ${record_name})"
  exit 1
fi

###########################################
## Get existing IP
###########################################
old_ip=$(echo "$record" | sed -E 's/.*"content":"(([0-9]{1,3}\.){3}[0-9]{1,3})".*/\1/')
# # Compare if they're the same
# while true
# do
#   array[0]="195.133.74.81"
#   array[1]="195.133.74.82"
#   array[2]="195.133.74.83"
#   array[3]="195.133.74.84"
#   array[4]="195.133.74.85"
#   array[5]="195.133.74.75"
#   array[6]="195.133.74.95"
#   array[7]="195.133.74.88"
#   array[8]="195.133.74.89"
#   array[9]="195.133.74.90"
#   array[10]="195.133.74.91"
#   array[11]="195.133.74.92"
#   array[12]="195.133.74.93"

#   ipx=${#array[@]}
#   index=$(($RANDOM % $ipx))
#   ip=${array[$index]}
  


#   if [[ $ip != $old_ip ]]; then
#     echo $ip != $old_ip
#     time=$(date +%T)
#     echo -e $ip $(date +%T) >> /root/ip-check.txt
#     TELEGRAM_TOKEN="5857681594:AAFSW_-It5hsSNWqwgxQyh2u2LlO9ogIsqw"
#     CHAT_ID="6180298111"
#     # TELEGRAM_TOKEN="6307270631:AAHYuRcRdL1XcejHDTzQoW-G2lRvF31uX_M"
#     # CHAT_ID="6207487369"
#     MESSAGE=" Your new ip: $ip at $time"
#     curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$MESSAGE" > /d$
#     break
#   fi
# done
###########################################
#declare -i lineip=0
declare -i lineip
lineip=$(< /root/conter)
# lineip=$(< /root/ip-check.txt | tail -1 | awk -F " " '{print $1}')
# lineip=$((lineip))
((lineip++))
if [[ "$lineip" = "1" ]]; then
  ip="212.87.168.1"
elif [[ "$lineip" = "2" ]]; then
  ip="195.133.74.62"
elif [[ "$lineip" = "3" ]]; then
  ip="188.241.243.243"
# elif [[ "$lineip" = "4" ]]; then
#   ip="188.241.243.82"
# elif [[ "$lineip" = "5" ]]; then
#   ip="195.133.74.85"
# elif [[ "$lineip" = "6" ]]; then
#   ip="195.133.74.86"
# elif [[ "$lineip" = "7" ]]; then
#   ip="195.133.74.87"
# elif [[ "$lineip" = "8" ]]; then
#   ip="195.133.74.88"
# elif [[ "$lineip" = "9" ]]; then
#   ip="195.133.74.89"
# elif [[ "$lineip" = "10" ]]; then
#   ip="195.133.74.90"
# elif [[ "$lineip" = "11" ]]; then
#   ip="195.133.74.91"
# elif [[ "$lineip" = "12" ]]; then
#   ip="195.133.74.92"
# elif [[ "$lineip" = "13" ]]; then
#   ip="195.133.74.93"
# elif [[ "$lineip" = "14" ]]; then
#   ip="195.133.74.94"
# elif [[ "$lineip" = "14" ]]; then
#   ip="195.133.74.95"
else
  ip="77.81.88.49"
  echo -e 0>conter
fi

if [[ "$lineip" -gt "3" ]]; then
  echo -e 1>conter
else
# ((lineip=lineip + 1))
  echo -e $lineip >conter
fi
echo $lineip
time=$(date)
echo -e $lineip $ip $(date +%T) 
echo -e $lineip $ip $(date +%T) >> /root/ip-check.txt

    # TELEGRAM_TOKEN="6307270631:AAHYuRcRdL1XcejHDTzQoW-G2lRvF31uX_M"
    # CHAT_ID="6207487369"
MESSAGE=" Your new ip: $ip at $time"
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$MESSAGE" > /d$




###########################################
## Set the record identifier from result
###########################################
record_identifier=$(echo "$record" | sed -E 's/.*"id":"(\w+)".*/\1/')

###########################################
## Change the IP@Cloudflare using the API
###########################################
update=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
                     -H "X-Auth-Email: $auth_email" \
                     -H "$auth_header $auth_key" \
                     -H "Content-Type: application/json" \
                     --data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"ttl\":\"$ttl\",\"proxied\":${proxy}}")

###########################################
## Report the status
###########################################
# case "$update" in
# *"\"success\":false"*)
#   echo -e "DDNS Updater: $ip $record_name DDNS failed for $record_identifier ($ip). DUMPING RESULTS:\n$update" | logger -s 
#   if [[ $slackuri != "" ]]; then
#     curl -L -X POST $slackuri \
#     --data-raw '{
#       "channel": "'$slackchannel'",
#       "text" : "'"$sitename"' DDNS Update Failed: '$record_name': '$record_identifier' ('$ip')."
#     }'
#   fi
#   if [[ $discorduri != "" ]]; then
#     curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST \
#     --data-raw '{
#       "content" : "'"$sitename"' DDNS Update Failed: '$record_name': '$record_identifier' ('$ip')."
#     }' $discorduri
#   fi
#   exit 1;;
# *)
#   logger "DDNS Updater: $ip $record_name DDNS updated."
#   if [[ $slackuri != "" ]]; then
#     curl -L -X POST $slackuri \
#     --data-raw '{
#       "channel": "'$slackchannel'",
#       "text" : "'"$sitename"' Updated: '$record_name''"'"'s'""' new IP Address is '$ip'"
#     }'
#   fi
#   if [[ $discorduri != "" ]]; then
#     curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST \
#     --data-raw '{
#       "content" : "'"$sitename"' Updated: '$record_name''"'"'s'""' new IP Address is '$ip'"
#     }' $discorduri
#   fi
#   exit 0;;
# esac





sleep 10m

  for user in $(cat /etc/passwd |awk -F : '$3 > 900 {print $1}' |grep -vi "nobody"); do
    pkill -f $user > /dev/null 2>&1
  done


