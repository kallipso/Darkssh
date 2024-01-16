###################  cloudflare.sh   #################

wget -O /bin/menuV4 https://raw.githubusercontent.com/kallipso/Darkssh/master/cloudflare.sh > /dev/null 2>&1; chmod +x /bin/cloudflare.sh

clear
echo ""
read -p "$(echo -e "\033[1;36mWHAT IS YOUR auth_email\033[1;31m? \033[1;37m  The email used to login 'https://dash.cloudflare.com' ")" -e xresp
sed -i "s;authemail;$xresp;" /bin/cloudflare.sh

clear
echo ""
read -p "$(echo -e "\033[1;36mWHAT IS YOUR aauth_key\033[1;31m? \033[1;37m Your API Token or Global API Key ")" -e xresp
sed -i "s;authemailkey;$xresp;" /bin/cloudflare.sh

clear
echo ""
read -p "$(echo -e "\033[1;36mWHAT IS YOUR zone_identifier\033[1;31m? \033[1;37m Can be found in the "Overview" tab of your domain ")" -e xresp
sed -i "s;zonekey;$xresp;" /bin/cloudflare.sh

clear
echo ""
read -p "$(echo -e "\033[1;36mWHAT IS YOUR record_name\033[1;31m? \033[1;37m Which record you want to be synced ")" -e xresp
sed -i "s;recordsite;$xresp;" /bin/cloudflare.sh

clear
echo ""
read -p "$(echo -e "\033[1;36mWHAT IS YOUR TELEGRAM_TOKEN\033[1;31m? \033[1;37m ")" -e xresp
sed -i "s;teletok;$xresp;" /bin/cloudflare.sh


clear
echo ""
read -p "$(echo -e "\033[1;36mWHAT IS YOUR CHAT_ID\033[1;31m? \033[1;37m ")" -e xresp
sed -i "s;telidd;$xresp;" /bin/cloudflare.sh


echo "0 */6 * * * /bin/bash /bin/cloudflare.sh"
#############################################################################################


