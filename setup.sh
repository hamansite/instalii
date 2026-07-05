# بررسی انتخاب کاربر
case $choice in
    # STREAMING_CHUNK:Handling PasarGuard installation...
    1)
        echo -e "\n${YELLOW}در حال نصب نود پاسارگارد (PasarGuard Node)...${NC}\n"
        sudo bash -c "$(curl -sL https://github.com/PasarGuard/scripts/raw/main/pg-node.sh)" @ install
        ;;
        
    # STREAMING_CHUNK:Handling Marzban installation...
    2)
        echo -e "\n${YELLOW}در حال نصب نود مرزبان (Marzban Node)...${NC}\n"
        bash <(curl -fsSL https://raw.githubusercontent.com/omidkarimi7945/marzba/main/install-marzban-node.sh)
        ;;
        
    # STREAMING_CHUNK:Handling nload installation...
    3)
        echo -e "\n${YELLOW}در حال نصب nload (Network Traffic Monitor)...${NC}\n"
        # فرض بر این است که از اوبونتو/دبیان استفاده می‌کنید
        sudo apt update && sudo apt install nload -y
        echo -e "\n${GREEN}نصب nload با موفقیت انجام شد! برای استفاده کافیست در ترمینال بنویسید: nload${NC}\n"
        ;;
        
    # STREAMING_CHUNK:Handling server update...
    4)
        echo -e "\n${YELLOW}در حال آپدیت و ارتقا سرور...${NC}\n"
        sudo apt update && sudo apt upgrade -y
        echo -e "\n${GREEN}سرور با موفقیت آپدیت شد!${NC}\n"
        ;;
        
    # STREAMING_CHUNK:Handling script exit...
    0)
        echo -e "\n${GREEN}خروج از اسکریپت. موفق باشید!${NC}\n"
        exit 0
        ;;
        
    # STREAMING_CHUNK:Handling invalid inputs...
    *)
        echo -e "\n${RED}گزینه نامعتبر است! لطفا فقط عددهای داخل منو را وارد کنید.${NC}\n"
        ;;
esac

# STREAMING_CHUNK:Pausing before returning to menu...
# توقف برنامه تا کاربر نتیجه را ببیند و سپس اینتر بزند تا منو دوباره لود شود
echo ""
read -p "برای بازگشت به منو دکمه Enter را بزنید..."
