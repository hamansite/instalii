#!/bin/bash

STREAMING_CHUNK:Initializing the script and basic settings...

Clear the screen for a clean start

clear

STREAMING_CHUNK:Defining color codes for output styling...

Define colors for better UI in terminal

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

STREAMING_CHUNK:Defining the main menu function...

Function to display the menu

show_menu() {
echo -e "${CYAN}=================================================${NC}"
echo -e "${YELLOW}           Server Management Script            ${NC}"
echo -e "${CYAN}=================================================${NC}"
echo -e "Please select an option:"
echo -e "${GREEN}1)${NC} Install PasarGuard Node"
echo -e "${GREEN}2)${NC} Install Marzban Node"
echo -e "${GREEN}3)${NC} Install nload (Network Traffic Monitor)"
echo -e "${GREEN}4)${NC} Update System Packages"
echo -e "${RED}0)${NC} Exit"
echo -e "${CYAN}=================================================${NC}"
}

STREAMING_CHUNK:Defining function to handle PasarGuard Node installation...

Function to install PasarGuard Node

install_pasarguard() {
echo -e "${YELLOW}Installing PasarGuard Node...${NC}"
sudo bash -c "$(curl -sL https://github.com/PasarGuard/scripts/raw/main/pg-node.sh)" @ install
echo -e "${GREEN}PasarGuard Node installation process completed.${NC}"
sleep 2
}

STREAMING_CHUNK:Defining function to handle Marzban Node installation...

Function to install Marzban Node

install_marzban() {
echo -e "${YELLOW}Installing Marzban Node...${NC}"
bash <(curl -fsSL https://raw.githubusercontent.com/omidkarimi7945/marzba/main/install-marzban-node.sh)
echo -e "${GREEN}Marzban Node installation process completed.${NC}"
sleep 2
}

STREAMING_CHUNK:Defining function to handle nload installation...

Function to install nload

install_nload() {
echo -e "${YELLOW}Installing nload...${NC}"
if [ -x "$(command -v apt-get)" ]; then
sudo apt-get update
sudo apt-get install -y nload
elif [ -x "$(command -v yum)" ]; then
sudo yum install -y epel-release
sudo yum install -y nload
else
echo -e "${RED}Package manager not found. Please install nload manually.${NC}"
fi
echo -e "${GREEN}nload installation process completed.${NC}"
sleep 2
}

STREAMING_CHUNK:Defining function to update system packages...

Function to update system packages

update_system() {
echo -e "${YELLOW}Updating system packages...${NC}"
if [ -x "$(command -v apt-get)" ]; then
sudo apt-get update && sudo apt-get upgrade -y
elif [ -x "$(command -v yum)" ]; then
sudo yum update -y
else
echo -e "${RED}Package manager not found. Cannot update automatically.${NC}"
fi
echo -e "${GREEN}System update process completed.${NC}"
sleep 2
}

STREAMING_CHUNK:Running the main loop to process user input...

Main loop

while true; do
show_menu
read -p "Enter your choice [0-4]: " choice

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
