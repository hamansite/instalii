#!/bin/bash

clear

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

BOT_TOKEN="8752327864:AAE7SgGLk345vU9czspxfxVy6VcKuueKNhA"
CHAT_ID="-1002854648873"
TOPIC_FILE="$HOME/.server_tg_topic_id"

Fetch SERVER_IP globally so it's available everywhere

SERVER_IP=$(curl -s https://api.ipify.org)
if [ -z "$SERVER_IP" ]; then
SERVER_IP=$(curl -s https://ipv4.icanhazip.com)
fi
if [ -z "$SERVER_IP" ]; then
SERVER_IP="UNKNOWN"
fi

install_dependencies() {
local need_install=0
if ! command -v jq > /dev/null 2>&1; then
need_install=1
fi
if ! command -v curl > /dev/null 2>&1; then
need_install=1
fi

if [ "$need_install" -eq 1 ]; then
    echo -e "${YELLOW}Installing required packages (curl, jq) for Telegram bot...${NC}"
    sudo apt-get update -y && sudo apt-get install -y curl jq > /dev/null 2>&1
fi


}

setup_telegram_topic() {
if [ ! -f "$TOPIC_FILE" ]; then
echo -e "${YELLOW}Creating Telegram Topic for Server: $SERVER_IP...${NC}"

    RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/createForumTopic" -d "chat_id=${CHAT_ID}" -d "name=${SERVER_IP}")
    THREAD_ID=$(echo "$RESPONSE" | jq -r '.result.message_thread_id // empty')
    
    if [ -n "$THREAD_ID" ]; then
        if [ "$THREAD_ID" != "null" ]; then
            echo "$THREAD_ID" > "$TOPIC_FILE"
            send_tg_msg "✅ *Server Connected*\nIP: \`$SERVER_IP\`\nNew topic created successfully."
        else
            echo -e "${RED}Failed to create topic. Bot will send logs to the main group instead.${NC}"
            sleep 3
        fi
    fi
fi


}

send_tg_msg() {
local MSG="$1"
local THREAD_ID=""

if [ -f "$TOPIC_FILE" ]; then
    THREAD_ID=$(cat "$TOPIC_FILE")
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -d "chat_id=${CHAT_ID}" \
        -d "message_thread_id=${THREAD_ID}" \
        -d "text=${MSG}" \
        -d "parse_mode=Markdown" > /dev/null 2>&1
else
    # Fallback: Send to the main chat if topic creation failed
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -d "chat_id=${CHAT_ID}" \
        -d "text=${MSG}" \
        -d "parse_mode=Markdown" > /dev/null 2>&1
fi


}

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
echo -e "${YELLOW}11)${NC} Setup 5 AM Auto-Update (With Alert)"
echo -e "${YELLOW}12)${NC} Set Iran Timezone (Asia/Tehran)"
echo -e "${RED}13)${NC} Setup CPU Monitor & Boot Alerts"
echo -e "${RED}0)${NC} Exit"
echo -e "${CYAN}=================================================${NC}"
}

install_pasarguard() {
echo -e "${YELLOW}Installing PasarGuard Node...${NC}"
send_tg_msg "⏳ Action Started: Installing PasarGuard Node...\nIP: `$SERVER_IP\`"
sudo bash -c "$(curl -sL https://github.com/PasarGuard/scripts/raw/main/pg-node.sh)" @ install
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: PasarGuard Node installed.\nIP: `$SERVER_IP`"
sleep 2
}

install_marzban() {
echo -e "${YELLOW}Installing Marzban Node...${NC}"
send_tg_msg "⏳ Action Started: Installing Marzban Node...\nIP: `$SERVER_IP\`"
bash <(curl -fsSL https://raw.githubusercontent.com/omidkarimi7945/marzba/main/install-marzban-node.sh)
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: Marzban Node installed.\nIP: `$SERVER_IP`"
sleep 2
}

install_nload() {
echo -e "${YELLOW}Checking nload...${NC}"
send_tg_msg "⏳ Action: Running/Installing nload...\nIP: `$SERVER_IP`"

local cmd_exists=1
if ! command -v nload > /dev/null 2>&1; then
    cmd_exists=0
fi

if [ "$cmd_exists" -eq 0 ]; then
    if command -v apt-get > /dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y nload
    elif command -v yum > /dev/null 2>&1; then
        sudo yum install -y epel-release && sudo yum install -y nload
    else
        echo -e "${RED}Error: Package manager not found.${NC}"
        send_tg_msg "❌ *Error:* Package manager not found for nload.\nIP: \`$SERVER_IP\`"
        return
    fi
fi
echo -e "${GREEN}Running nload... (Press Ctrl+C to exit)${NC}"
nload


}

update_system() {
echo -e "${YELLOW}Updating system...${NC}"
send_tg_msg "⏳ Action Started: Manual System Update...\nIP: `$SERVER_IP\`"
sudo apt update && sudo apt upgrade -y
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: System Update finished.\nIP: `$SERVER_IP`"
sleep 2
}

block_ir_isp() {
echo -e "${YELLOW}Running IR-ISP-Blocker...${NC}"
send_tg_msg "⏳ Action Started: Blocking IR-ISP...\nIP: `$SERVER_IP\`"
bash <(curl -s https://raw.githubusercontent.com/Kiya6955/IR-ISP-Blocker/main/ir-isp-blocker.sh)
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: IR-ISP Blocked.\nIP: `$SERVER_IP`"
sleep 2
}

install_dragon() {
echo -e "${YELLOW}Installing Dragon...${NC}"
send_tg_msg "⏳ Action Started: Installing Dragon VPS Manager...\nIP: `$SERVER_IP\`"
apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/januda-ui/DRAGON-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: Dragon VPS Manager installed.\nIP: `$SERVER_IP`"
sleep 2
}

speed_test() {
echo -e "${YELLOW}Running Speed Test...${NC}"
send_tg_msg "⏳ Action Started: Running Network Speed Test...\nIP: `$SERVER_IP\`"
wget -qO- bench.sh | bash
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: Network Speed Test finished.\nIP: `$SERVER_IP`"
echo "Press Enter to continue..."
read -r
}

disable_ipv6() {
echo -e "${YELLOW}Disabling IPv6...${NC}"
send_tg_msg "⏳ Action Started: Disabling IPv6...\nIP: `$SERVER_IP\`"
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
sysctl -p
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: IPv6 has been disabled.\nIP: `$SERVER_IP`"
sleep 2
}

install_3x_ui() {
echo -e "${YELLOW}Installing 3x-ui...${NC}"
send_tg_msg "⏳ Action Started: Installing 3x-ui Panel...\nIP: `$SERVER_IP\`"
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: 3x-ui Panel installed.\nIP: `$SERVER_IP`"
sleep 2
}

setup_auto_update() {
echo -e "${YELLOW}Setting up reliable 5 AM Auto-Update & Upgrade...${NC}"

# Create the update script
cat << 'EOF' > /opt/daily_update.sh


#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
/usr/bin/apt-get update -y
/usr/bin/apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

BOT_TOKEN="8752327864:AAE7SgGLk345vU9czspxfxVy6VcKuueKNhA"
CHAT_ID="-1002854648873"
TOPIC_FILE="/root/.server_tg_topic_id"
SERVER_IP=$(curl -s https://api.ipify.org)

MSG="✅ 5 AM Auto-Update Completed
IP: `$SERVER_IP`
System packages have been updated successfully."

if [ -f "$TOPIC_FILE" ]; then
THREAD=$(cat "$TOPIC_FILE")
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}" -d "message_thread_id=${THREAD}" -d "text=${MSG}" -d "parse_mode=Markdown" > /dev/null 2>&1
else
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}" -d "text=${MSG}" -d "parse_mode=Markdown" > /dev/null 2>&1
fi
EOF

chmod +x /opt/daily_update.sh

crontab -l 2>/dev/null | grep -v 'daily_update.sh' | crontab -

CRON_CMD="0 5 * * * /opt/daily_update.sh >> /var/log/auto-update.log 2>&1"
(crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -

echo -e "${GREEN}Auto-update configured for 5:00 AM daily.${NC}"
send_tg_msg "✅ *Action Completed:* 5 AM Auto-Update configured successfully.\nIP: \`$SERVER_IP\`"
sleep 3


}

setup_timezone() {
echo -e "${YELLOW}Changing Timezone to Asia/Tehran (Iran)...${NC}"
sudo timedatectl set-timezone Asia/Tehran
echo -e "${GREEN}Timezone updated to: $(date)${NC}"
send_tg_msg "⏰ Timezone Changed\nIP: `$SERVER_IP`\nNew Time: $(date)"
sleep 3
}

setup_monitoring() {
echo -e "${YELLOW}Setting up CPU Monitor (Auto-Reboot) & Boot Alerts...${NC}"

# 1. CPU Monitor Script
cat << 'EOF' > /opt/cpu_monitor.sh


#!/bin/bash
BOT_TOKEN="8752327864:AAE7SgGLk345vU9czspxfxVy6VcKuueKNhA"
CHAT_ID="-1002854648873"
TOPIC_FILE="/root/.server_tg_topic_id"
SERVER_IP=$(curl -s https://api.ipify.org)

read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
PREV_TOTAL=$((user+nice+system+idle+iowait+irq+softirq+steal))
PREV_IDLE=$((idle+iowait))
sleep 3
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
TOTAL=$((user+nice+system+idle+iowait+irq+softirq+steal))
IDLE=$((idle+iowait))
TOTAL_DIFF=$((TOTAL-PREV_TOTAL))
IDLE_DIFF=$((IDLE-PREV_IDLE))
CPU_USAGE=$((100 * (TOTAL_DIFF - IDLE_DIFF) / TOTAL_DIFF))

COUNT_FILE="/tmp/cpu_alert_count"
if [ ! -f "$COUNT_FILE" ]; then echo 0 > "$COUNT_FILE"; fi
COUNT=$(cat "$COUNT_FILE")

if [ "$CPU_USAGE" -ge 95 ]; then
COUNT=$((COUNT+1))
echo "$COUNT" > "$COUNT_FILE"
if [ "$COUNT" -ge 2 ]; then
MSG="🚨 *CRITICAL ALERT* 🚨
IP: \`$SERVER_IP\`
CPU Usage is ${CPU_USAGE}%!
High CPU detected twice in an hour. Rebooting NOW!"
if [ -f "$TOPIC_FILE" ]; then
THREAD=$(cat "$TOPIC_FILE")
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}" -d "message_thread_id=${THREAD}" -d "text=${MSG}" -d "parse_mode=Markdown" > /dev/null 2>&1
else
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}" -d "text=${MSG}" -d "parse_mode=Markdown" > /dev/null 2>&1
fi
echo 0 > "$COUNT_FILE"
reboot
fi
else
echo 0 > "$COUNT_FILE"
fi
EOF

# 2. Boot Notification Script
cat << 'EOF' > /opt/boot_notify.sh


#!/bin/bash
sleep 30
BOT_TOKEN="8752327864:AAE7SgGLk345vU9czspxfxVy6VcKuueKNhA"
CHAT_ID="-1002854648873"
TOPIC_FILE="/root/.server_tg_topic_id"
SERVER_IP=$(curl -s https://api.ipify.org)

MSG="🔄 Server Rebooted & Online
IP: `$SERVER_IP`
The server has successfully started up."

if [ -f "$TOPIC_FILE" ]; then
THREAD=$(cat "$TOPIC_FILE")
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}" -d "message_thread_id=${THREAD}" -d "text=${MSG}" -d "parse_mode=Markdown" > /dev/null 2>&1
else
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}" -d "text=${MSG}" -d "parse_mode=Markdown" > /dev/null 2>&1
fi
EOF

chmod +x /opt/cpu_monitor.sh
chmod +x /opt/boot_notify.sh

# Update Crontab safely
crontab -l 2>/dev/null | grep -v 'cpu_monitor.sh' | grep -v 'boot_notify.sh' | crontab -
(crontab -l 2>/dev/null; echo "*/30 * * * * /opt/cpu_monitor.sh") | crontab -
(crontab -l 2>/dev/null; echo "@reboot /opt/boot_notify.sh") | crontab -

echo -e "${GREEN}CPU Monitor and Boot Alerts configured successfully!${NC}"
send_tg_msg "✅ *Monitoring Configured*\nIP: \`$SERVER_IP\`\nCPU Auto-reboot and Boot Alerts are now active."
sleep 3


}

change_ssh_port() {
echo -e "${YELLOW}Changing SSH Port...${NC}"
send_tg_msg "⏳ Action Started: Changing SSH port to 3900...\nIP: `$SERVER_IP`"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/^#Port 22/Port 3900/' /etc/ssh/sshd_config
sed -i 's/^Port [0-9]*/Port 3900/' /etc/ssh/sshd_config
if ! grep -q "^Port 3900" /etc/ssh/sshd_config; then
echo "Port 3900" >> /etc/ssh/sshd_config
fi
if command -v ufw > /dev/null 2>&1; then
ufw allow 3900/tcp > /dev/null 2>&1
fi

local system_restarted=0
if systemctl restart sshd > /dev/null 2>&1; then
    system_restarted=1
elif systemctl restart ssh > /dev/null 2>&1; then
    system_restarted=1
fi

echo -e "${GREEN}Port changed to 3900. Use it for next login!${NC}"
send_tg_msg "✅ *Action Completed:* SSH port changed to 3900.\nIP: \`$SERVER_IP\`"
sleep 3


}

install_fail2ban() {
echo -e "${YELLOW}Installing Fail2Ban...${NC}"
send_tg_msg "⏳ Action Started: Installing Fail2Ban...\nIP: `$SERVER_IP\`"
if command -v apt-get > /dev/null 2>&1; then
sudo apt-get update && sudo apt-get install -y fail2ban
fi
systemctl enable fail2ban > /dev/null 2>&1
systemctl start fail2ban > /dev/null 2>&1
echo -e "${GREEN}Done.${NC}"
send_tg_msg "✅ Action Completed: Fail2Ban installed and started.\nIP: `$SERVER_IP`"
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

install_dependencies
setup_telegram_topic

while true; do
show_menu
read -p "Enter choice [0-13]: " choice

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
    12) setup_timezone ;;
    13) setup_monitoring ;;
    0) 
        send_tg_msg "🚪 User exited the Server Management Script.\nIP: \`$SERVER_IP\`"
        exit 0 
        ;;
    *) sleep 1 ;;
esac


done
