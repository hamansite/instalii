#!/bin/bash

clear

STREAMING_CHUNK: Defining color codes for the interface...

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

STREAMING_CHUNK: Setting up Telegram Bot variables...

==========================================

TELEGRAM BOT CONFIGURATION

==========================================

BOT_TOKEN="8752327864:AAE7SgGLk345vU9czspxfxVy6VcKuueKNhA" # <--- توکن ربات خود را اینجا قرار دهید
CHAT_ID="-1002854648873"
TOPIC_FILE="$HOME/.server_tg_topic_id"

==========================================

STREAMING_CHUNK: Checking and installing required dependencies (curl, jq)...

install_dependencies() {
if ! command -v jq &> /dev/null || ! command -v curl &> /dev/null; then
echo -e "${YELLOW}Installing required packages (curl, jq) for Telegram bot...${NC}"
sudo apt-get update -y && sudo apt-get install -y curl jq > /dev/null 2>&1
fi
}

STREAMING_CHUNK: Creating Telegram topic and saving thread ID...

setup_telegram_topic() {
if [ "$BOT_TOKEN" == "YOUR_BOT_TOKEN" ]; then
echo -e "${RED}Warning: BOT_TOKEN is not set. Telegram logging will be disabled.${NC}"
sleep 2
return
fi

# Fetch Server IP
SERVER_IP=$(curl -s https://api.ipify.org)
if [ -z "$SERVER_IP" ]; then
    SERVER_IP=$(curl -s https://ipv4.icanhazip.com)
fi

# Create Topic if it doesn't exist
if [ ! -f "$TOPIC_FILE" ]; then
    echo -e "${YELLOW}Creating Telegram Topic for Server: $SERVER_IP...${NC}"
    RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/createForumTopic" \
        -d "chat_id=${CHAT_ID}" \
        -d "name=${SERVER_IP}")

    # Parse Thread ID
    THREAD_ID=$(echo "$RESPONSE" | jq -r '.result.message_thread_id')

    if [ "$THREAD_ID" != "null" ] && [ -n "$THREAD_ID" ]; then
        echo "$THREAD_ID" > "$TOPIC_FILE"
        send_tg_msg "✅ *Server Connected*\nIP: \`$SERVER_IP\`\nNew topic created successfully."
    else
        echo -e "${RED}Failed to create topic. Is the bot admin in the group?${NC}"
        sleep 3
    fi
fi


}

STREAMING_CHUNK: Defining the helper function to send Telegram messages...

send_tg_msg() {
local MSG="$1"
if [ "$BOT_TOKEN" == "YOUR_BOT_TOKEN" ] \vert{}\vert{} [ ! -f "$TOPIC_FILE" ]; then
return
fi
local THREAD_ID=$(cat "$TOPIC_FILE")
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
-d "chat_id=${CHAT_ID}" \
-d "message_thread_id=${THREAD_ID}" 

-d "text=${MSG}" 

-d "parse_mode=Markdown" > /dev/null
}

STREAMING_CHUNK: Defining the main menu UI...

show_menu() {
clear
echo -e "${CYAN}=================================================${NC}"
echo -e "${YELLOW}            Server Management Script${NC}"
echo -e "${CYAN}=================================================${NC}"
echo -e "Please select an option:"
echo -e "${GREEN}1)${NC} Install PasarGuard Node"
echo -e "${GREEN}2)${NC} Install Marzban Node"
echo -e "${GREEN}3)${NC} Run/Install nload"
echo -e "${GREEN}4)${NC} Update System Packages"
echo -e "${GREEN}5)${NC} Block Iranian ISPs"
echo -e "${GREEN}6)${NC} Install Dragon VPS Manager"
echo -e "${GREEN}7)${NC} Run Speed Test"
echo -e "${GREEN}8)${NC} Disable IPv6"
echo -e "${GREEN}9)${NC} Install 3x-ui Panel"
echo -e "${YELLOW}10)${NC} Security Settings"
echo -e "${YELLOW}11)${NC} Setup 5 AM Auto-Update (Bug Fix)"
echo -e "${RED}0)${NC} Exit"
echo -e "${CYAN}=================================================${NC}"
}

STREAMING_CHUNK: Adding Node installation functions...

install_pasarguard() {
echo -e "${YELLOW}Installing PasarGuard Node...${NC}"
send_tg_msg "⏳ Action Started: Installing PasarGuard Node..."
sudo bash -c "$(curl -sL https://github.com/PasarGuard/scripts/raw/main/pg-node.sh)" @ install
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: PasarGuard Node installed."
sleep 2
}

install_marzban() {
echo -e "${YELLOW}Installing Marzban Node...${NC}"
send_tg_msg "⏳ Action Started: Installing Marzban Node..."
bash <(curl -fsSL https://raw.githubusercontent.com/omidkarimi7945/marzba/main/install-marzban-node.sh)
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: Marzban Node installed."
sleep 2
}

install_nload() {
echo -e "${YELLOW}Checking nload...${NC}"
send_tg_msg "⏳ Action: Running/Installing nload..."
if ! command -v nload &> /dev/null; then
if [ -x "$(command -v apt-get)" ]; then
sudo apt-get update && sudo apt-get install -y nload
elif [ -x "$(command -v yum)" ]; then
sudo yum install -y epel-release && sudo yum install -y nload
else
echo -e "${RED}Error: Package manager not found.${NC}"
send_tg_msg "❌ Error: Package manager not found for nload."
return
fi
fi
echo -e "${GREEN}Running nload... (Press Ctrl+C to exit)${NC}"
nload
}

STREAMING_CHUNK: Adding System Update and Configuration functions...

update_system() {
echo -e "${YELLOW}Updating system...${NC}"
send_tg_msg "⏳ Action Started: Manual System Update..."
sudo apt update && sudo apt upgrade -y
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: System Update finished."
sleep 2
}

block_ir_isp() {
echo -e "${YELLOW}Running IR-ISP-Blocker...${NC}"
send_tg_msg "⏳ Action Started: Blocking IR-ISP..."
bash <(curl -s https://raw.githubusercontent.com/Kiya6955/IR-ISP-Blocker/main/ir-isp-blocker.sh)
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: IR-ISP Blocked."
sleep 2
}

install_dragon() {
echo -e "${YELLOW}Installing Dragon...${NC}"
send_tg_msg "⏳ Action Started: Installing Dragon VPS Manager..."
apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/januda-ui/DRAGON-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: Dragon VPS Manager installed."
sleep 2
}

speed_test() {
echo -e "${YELLOW}Running Speed Test...${NC}"
send_tg_msg "⏳ Action Started: Running Network Speed Test..."
wget -qO- bench.sh | bash
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: Network Speed Test finished."
echo "Press Enter to continue..."
read -r
}

disable_ipv6() {
echo -e "${YELLOW}Disabling IPv6...${NC}"
send_tg_msg "⏳ Action Started: Disabling IPv6..."
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf && echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf && sysctl -p
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: IPv6 has been disabled."
sleep 2
}

install_3x_ui() {
echo -e "${YELLOW}Installing 3x-ui...${NC}"
send_tg_msg "⏳ Action Started: Installing 3x-ui Panel..."
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: 3x-ui Panel installed."
sleep 2
}

STREAMING_CHUNK: Fixing the 5 AM Auto-update bug via non-interactive apt flags...

setup_auto_update() {
echo -e "${YELLOW}Setting up reliable 5 AM Auto-Update & Upgrade...${NC}"
send_tg_msg "⏳ Action Started: Configuring 5 AM Auto-Update..."

# Remove old potentially faulty cron jobs relating to apt-get
crontab -l 2>/dev/null | grep -v 'apt-get' | crontab -

# Add new reliable, non-interactive cron job
# Explanation: DEBIAN_FRONTEND=noninteractive and Dpkg::Options prevent the system from getting stuck on config prompts.
CRON_CMD="0 5 * * * DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get update -y && DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" upgrade >> /var/log/auto-update.log 2>&1"

(crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -

echo -e "${GREEN}Auto-update configured for 5:00 AM daily.${NC}"
echo -e "${CYAN}Logs will be saved to: /var/log/auto-update.log${NC}"
send_tg_msg "✅ *Action Completed:* 5 AM Non-interactive Auto-Update configured successfully."
sleep 4


}

STREAMING_CHUNK: Adding Security configurations...

change_ssh_port() {
echo -e "${YELLOW}Changing SSH Port...${NC}"
send_tg_msg "⏳ Action Started: Changing SSH port to 3900..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/^#Port 22/Port 3900/' /etc/ssh/sshd_config
sed -i 's/^Port [0-9]*/Port 3900/' /etc/ssh/sshd_config
if ! grep -q "^Port 3900" /etc/ssh/sshd_config; then
echo "Port 3900" >> /etc/ssh/sshd_config
fi
if command -v ufw > /dev/null; then
ufw allow 3900/tcp > /dev/null 2>&1
fi
systemctl restart sshd || systemctl restart ssh
echo -e "${GREEN}Port changed to 3900. Use it for next login!${NC}"
send_tg_msg "✅ Action Completed: SSH port successfully changed to 3900."
sleep 3
}

install_fail2ban() {
echo -e "${YELLOW}Installing Fail2Ban...${NC}"
send_tg_msg "⏳ Action Started: Installing Fail2Ban..."
if [ -x "$(command -v apt-get)" ]; then
sudo apt-get update && sudo apt-get install -y fail2ban
elif [ -x "$(command -v yum)" ]; then
sudo yum install -y epel-release && sudo yum install -y fail2ban
fi
systemctl enable fail2ban
systemctl start fail2ban
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: Fail2Ban installed and started."
sleep 2
}

security_menu() {
while true; do
clear
echo -e "${CYAN}=================================================${NC}"
echo -e "${YELLOW}                 Security Menu${NC}"
echo -e "${CYAN}=================================================${NC}"
echo -e "${GREEN}1)${NC} Change SSH Port to 3900"
echo -e "${GREEN}2)${NC} Install Fail2Ban"
echo -e "${RED}0)${NC} Return"
echo -e "${CYAN}=================================================${NC}"
read -p "Enter choice [0-2]: " sec_choice

    case $sec_choice in
        1) change_ssh_port ;;
        2) install_fail2ban ;;
        0) break ;;
        *) sleep 1 ;;
    esac
done


}

STREAMING_CHUNK: Initializing script sequence and main loop...

Run startup configurations

install_dependencies
setup_telegram_topic

Main loop

while true; do
show_menu
read -p "Enter choice [0-11]: " choice

case $choice in
    1) install_pasarguard ;;
    2) install_marzban ;;
    3) install_nload ;;
    4) update_system ;;
    5) block_ir_isp ;;
    6) install_dragon ;;
    7) speed_test ;;
    8) disable_ipv6 ;;
    9) install_3x_ui ;;
    10) security_menu ;;
    11) setup_auto_update ;;
    0) 
        send_tg_msg "🚪 User exited the Server Management Script."
        exit 0 
        ;;
    *) sleep 1 ;;
esac


done
