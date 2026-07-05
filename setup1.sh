#!/bin/bash

# Clear the screen for a clean start
clear

# Define colors for better UI in terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
    echo -e "${CYAN}=================================================${NC}"
    echo -e "${YELLOW}           Server Management Script            ${NC}"
    echo -e "${CYAN}=================================================${NC}"
    echo -e "Please select an option:"
    echo -e "${GREEN}1)${NC} Install PasarGuard Node"
    echo -e "${GREEN}2)${NC} Install Marzban Node"
    echo -e "${GREEN}3)${NC} Run/Install nload (Network Traffic Monitor)"
    echo -e "${GREEN}4)${NC} Update System Packages"
    echo -e "${GREEN}5)${NC} Block Iranian ISPs (IR-ISP-Blocker)"
    echo -e "${GREEN}6)${NC} Install Dragon VPS Manager"
    echo -e "${GREEN}7)${NC} Run Speed Test (bench.sh)"
    echo -e "${GREEN}8)${NC} Disable IPv6"
    echo -e "${RED}0)${NC} Exit"
    echo -e "${CYAN}=================================================${NC}"
}

# Function to install PasarGuard Node
install_pasarguard() {
    echo -e "${YELLOW}Installing PasarGuard Node...${NC}"
    sudo bash -c "$(curl -sL https://github.com/PasarGuard/scripts/raw/main/pg-node.sh)" @ install
    echo -e "${GREEN}PasarGuard Node installation process completed.${NC}"
    sleep 2
}

# Function to install Marzban Node
install_marzban() {
    echo -e "${YELLOW}Installing Marzban Node...${NC}"
    bash <(curl -fsSL https://raw.githubusercontent.com/omidkarimi7945/marzba/main/install-marzban-node.sh)
    echo -e "${GREEN}Marzban Node installation process completed.${NC}"
    sleep 2
}

# Function to install and run nload
install_nload() {
    echo -e "${YELLOW}Checking nload...${NC}"
    if ! command -v nload &> /dev/null; then
        echo -e "${YELLOW}nload is not installed. Installing it first...${NC}"
        if [ -x "$(command -v apt-get)" ]; then
            sudo apt-get update
            sudo apt-get install -y nload
        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y epel-release
            sudo yum install -y nload
        else
            echo -e "${RED}Package manager not found. Please install nload manually.${NC}"
            return
        fi
    fi
    echo -e "${GREEN}Running nload... (Press Ctrl+C to exit nload)${NC}"
    nload
}

# Function to update system packages
update_system() {
    echo -e "${YELLOW}Updating system packages...${NC}"
    sudo apt update && sudo apt upgrade -y
    echo -e "${GREEN}System update process completed.${NC}"
    sleep 2
}

# Function to block IR ISPs
block_ir_isp() {
    echo -e "${YELLOW}Running IR-ISP-Blocker...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/Kiya6955/IR-ISP-Blocker/main/ir-isp-blocker.sh)
    echo -e "${GREEN}IR-ISP-Blocker process completed.${NC}"
    sleep 2
}

# Function to install Dragon VPS Manager
install_dragon() {
    echo -e "${YELLOW}Installing Dragon VPS Manager...${NC}"
    apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/januda-ui/DRAGON-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe
    echo -e "${GREEN}Dragon VPS Manager installation completed.${NC}"
    sleep 2
}

# Function to run Speed Test
speed_test() {
    echo -e "${YELLOW}Running Speed Test...${NC}"
    wget -qO- bench.sh | bash
    echo -e "${GREEN}Speed Test completed.${NC}"
    sleep 2
}

# Function to disable IPv6
disable_ipv6() {
    echo -e "${YELLOW}Disabling IPv6...${NC}"
    echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf && echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf && sysctl -p
    echo -e "${GREEN}IPv6 has been disabled.${NC}"
    sleep 2
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice [0-8]: " choice

    case $choice in
        1)
            install_pasarguard
            ;;
        2)
            install_marzban
            ;;
        3)
            install_nload
            ;;
        4)
            update_system
            ;;
        5)
            block_ir_isp
            ;;
        6)
            install_dragon
            ;;
        7)
            speed_test
            ;;
        8)
            disable_ipv6
            ;;
        0)
            echo -e "${GREEN}Exiting... Have a good day!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 1
            clear
            ;;
    esac

    # Prompt before showing menu again (except on exit)
    if [ "$choice" != "0" ]; then
        echo -e "\nPress Enter to return to the main menu..."
        read
        clear
    fi
done
```
