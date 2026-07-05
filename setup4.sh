#!/bin/bash

clear

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

show_menu() {
clear
echo -e "${CYAN}=================================================${NC}"
echo -e "${YELLOW}           Server Management Script            ${NC}"
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
echo -e "${RED}0)${NC} Exit"
echo -e "${CYAN}=================================================${NC}"
}

install_pasarguard() {
echo -e "${YELLOW}Installing PasarGuard Node...${NC}"
sudo bash -c "$(curl -sL https://github.com/PasarGuard/scripts/raw/main/pg-node.sh)" @ install
echo -e "${GREEN}Done.${NC}"
sleep 2
}

install_marzban() {
echo -e "${YELLOW}Installing Marzban Node...${NC}"
bash <(curl -fsSL https://raw.githubusercontent.com/omidkarimi7945/marzba/main/install-marzban-node.sh)
echo -e "${GREEN}Done.${NC}"
sleep 2
}

install_nload() {
echo -e "${YELLOW}Checking nload...${NC}"
if ! command -v nload &> /dev/null; then
if [ -x "$(command -v apt-get)" ]; then
sudo apt-get update && sudo apt-get install -y nload
elif [ -x "$(command -v yum)" ]; then
sudo yum install -y epel-release && sudo yum install -y nload
else
echo -e "${RED}Error: Package manager not found.${NC}"
return
fi
fi
echo -e "${GREEN}Running nload... (Press Ctrl+C to exit)${NC}"
nload
}

update_system() {
echo -e "${YELLOW}Updating system...${NC}"
sudo apt update && sudo apt upgrade -y
echo -e "${GREEN}Done.${NC}"
sleep 2
}

block_ir_isp() {
echo -e "${YELLOW}Running IR-ISP-Blocker...${NC}"
bash <(curl -s https://raw.githubusercontent.com/Kiya6955/IR-ISP-Blocker/main/ir-isp-blocker.sh)
echo -e "${GREEN}Done.${NC}"
sleep 2
}

install_dragon() {
echo -e "${YELLOW}Installing Dragon...${NC}"
apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/januda-ui/DRAGON-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe
echo -e "${GREEN}Done.${NC}"
sleep 2
}

speed_test() {
echo -e "${YELLOW}Running Speed Test...${NC}"
wget -qO- bench.sh | bash
echo -e "${GREEN}Done.${NC}"
sleep 2
}

disable_ipv6() {
echo -e "${YELLOW}Disabling IPv6...${NC}"
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf && echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf && sysctl -p
echo -e "${GREEN}Done.${NC}"
sleep 2
}

install_3x_ui() {
echo -e "${YELLOW}Installing 3x-ui...${NC}"
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
echo -e "${GREEN}Done.${NC}"
sleep 2
}

change_ssh_port() {
echo -e "${YELLOW}Changing SSH Port...${NC}"
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
sleep 3
}

install_fail2ban() {
echo -e "${YELLOW}Installing Fail2Ban...${NC}"
if [ -x "$(command -v apt-get)" ]; then
sudo apt-get update && sudo apt-get install -y fail2ban
elif [ -x "$(command -v yum)" ]; then
sudo yum install -y epel-release && sudo yum install -y fail2ban
fi
systemctl enable fail2ban
systemctl start fail2ban
echo -e "${GREEN}Done.${NC}"
sleep 2
}

security_menu() {
while true; do
clear
echo -e "${CYAN}=================================================${NC}"
echo -e "${YELLOW}                 Security Menu                 ${NC}"
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

while true; do
show_menu
read -p "Enter choice [0-10]: " choice

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
    0) exit 0 ;;
    *) sleep 1 ;;
esac


done
