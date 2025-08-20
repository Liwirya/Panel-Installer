#!/bin/bash

# =============================================================================
# PTERODACTYL PANEL AUTO INSTALLER
# Dibuat oleh: LIWIRYA
# Versi: 2.0
# =============================================================================

BLUE='\033[0;34m'       
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

LOG_FILE="/var/log/pterodactyl-installer.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
    log_message "INFO: $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    log_message "ERROR: $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    log_message "WARNING: $1"
}

print_header() {
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "${BLUE}[+] $1 [+]${NC}"
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
}

validate_domain() {
    if [[ $1 =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{1,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{1,61}[a-zA-Z0-9])?)*$ ]]; then
        return 0
    else
        return 1
    fi
}

validate_url() {
    if [[ $1 =~ ^https?:// ]]; then
        return 0
    else
        return 1
    fi
}

validate_number() {
    if [[ $1 =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

display_welcome() {
    clear
    echo -e ""
    print_header "                AUTO INSTALLER PTERODACTYL                "
    echo -e "${BLUE}[+]                   © LIWIRYA 2025                   [+]${NC}"
    print_header "==============================================="
    echo -e ""
    echo -e "${WHITE}Script ini dibuat untuk mempermudah instalasi Pterodactyl Panel${NC}"
    echo -e "${WHITE}Fitur lengkap: Panel, Tema, Wings, Node Management${NC}"
    echo -e "${RED}⚠️  Dilarang keras untuk mendistribusikan script ini!${NC}"
    echo -e ""
    echo -e "${CYAN}📱 TELEGRAM  : @senkaliwirya${NC}"
    echo -e "${CYAN}💼 CREDITS   : @Liwirya${NC}"
    echo -e "${CYAN}🌐 SUPPORT   : Clorinde ID Team${NC}"
    echo -e ""
    sleep 4
    clear
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Script ini harus dijalankan sebagai root!"
        print_error "Gunakan: sudo bash $0"
        exit 1
    fi
}

install_dependencies() {
    print_header "            UPDATE SISTEM & INSTALL DEPENDENCIES            "
    
    print_status "Mengupdate package list..."
    apt update -y >> "$LOG_FILE" 2>&1
    
    print_status "Menginstall dependencies yang diperlukan..."
    apt install -y curl wget unzip zip jq software-properties-common apt-transport-https ca-certificates gnupg lsb-release >> "$LOG_FILE" 2>&1
    
    if [ $? -eq 0 ]; then
        print_status "✅ Dependencies berhasil diinstall!"
    else
        print_error "❌ Gagal menginstall dependencies!"
        exit 1
    fi
    
    sleep 2
    clear
}

check_token() {
    print_header "               VERIFIKASI LISENSI TOKEN                "
    
    echo -e "${YELLOW}🔐 Masukkan token akses untuk melanjutkan:${NC}"
    read -r USER_TOKEN

    case "$USER_TOKEN" in
        "liwirya"|"Liwirya2025"|"pterodactyl-pro")
            print_status "✅ Token valid! Akses diberikan."
            ;;
        *)
            print_error "❌ Token tidak valid!"
            echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${WHITE}🛒 Untuk mendapatkan token akses:${NC}"
            echo -e "${CYAN}📱 TELEGRAM : @Liwirya${NC}"
            echo -e "${CYAN}📞 WHATSAPP : +6283879152564${NC}"
            echo -e "${GREEN}💰 HARGA    : 25K (Free update selamanya!)${NC}"
            echo -e "${YELLOW}⭐ BENEFIT  : Akses semua fitur + support 24/7${NC}"
            echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            exit 1
            ;;
    esac
    
    sleep 2
    clear
}

install_panel() {
    print_header "              INSTALASI PTERODACTYL PANEL               "
    
    echo -e "${YELLOW}📋 Informasi yang diperlukan untuk instalasi panel:${NC}"
    
    # Get domain
    while true; do
        echo -e "${CYAN}🌐 Masukkan FQDN/Domain (contoh: panel.domain.com):${NC}"
        read -r PANEL_FQDN
        if validate_domain "$PANEL_FQDN"; then
            break
        else
            print_error "Format domain tidak valid! Coba lagi."
        fi
    done
    
    echo -e "${CYAN}📧 Masukkan email admin:${NC}"
    read -r ADMIN_EMAIL
    
    echo -e "${CYAN}👤 Masukkan username admin:${NC}"
    read -r ADMIN_USERNAME
    
    echo -e "${CYAN}🔒 Masukkan password admin:${NC}"
    read -s ADMIN_PASSWORD
    echo
    
    echo -e "${CYAN}🗄️  Masukkan nama database (default: pterodactyl):${NC}"
    read -r DB_NAME
    DB_NAME=${DB_NAME:-pterodactyl}
    
    echo -e "${CYAN}🔐 Masukkan password database:${NC}"
    read -s DB_PASSWORD
    echo
    
    print_status "🚀 Memulai instalasi Pterodactyl Panel..."
    
    bash <(curl -s https://pterodactyl-installer.se) <<EOF
$ADMIN_EMAIL
$ADMIN_USERNAME
$ADMIN_USERNAME
$ADMIN_PASSWORD
$PANEL_FQDN
y
y
$DB_NAME
pterodactyl_user
$DB_PASSWORD
y
y
Europe/Amsterdam
$ADMIN_EMAIL
$ADMIN_USERNAME
$ADMIN_USERNAME
$ADMIN_PASSWORD
y
EOF

    if [ $? -eq 0 ]; then
        print_status "✅ Panel Pterodactyl berhasil diinstall!"
        echo -e "${GREEN}🌐 URL Panel: https://$PANEL_FQDN${NC}"
        echo -e "${GREEN}👤 Username: $ADMIN_USERNAME${NC}"
        echo -e "${GREEN}📧 Email: $ADMIN_EMAIL${NC}"
    else
        print_error "❌ Gagal menginstall panel!"
        return 1
    fi
    
    sleep 3
}

install_wings() {
    print_header "                 INSTALASI PTERODACTYL WINGS                "
    
    print_status "🚀 Memulai instalasi Wings..."
    
    print_status "🐳 Menginstall Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh >> "$LOG_FILE" 2>&1
    systemctl enable --now docker
    
    mkdir -p /etc/pterodactyl
    curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
    chmod u+x /usr/local/bin/wings
    
    cat > /etc/systemd/system/wings.service << 'EOF'
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable wings
    
    print_status "✅ Wings berhasil diinstall!"
    print_warning "⚠️  Jangan lupa konfigurasi node di panel dan jalankan configure_wings!"
    
    sleep 3
}

install_theme() {
    while true; do
        clear
        print_header "                    PILIH TEMA PANEL                    "
        
        echo -e "${WHITE}📋 Pilih tema yang ingin diinstall:${NC}"
        echo -e "${CYAN}1.${NC} 🌟 Stellar Theme (Modern & Elegant)"
        echo -e "${CYAN}2.${NC} 💰 Billing Theme (Dengan sistem billing)"
        echo -e "${CYAN}3.${NC} 🔮 Enigma Theme (Dark & Mysterious)"
        echo -e "${CYAN}4.${NC} 🎨 Custom Theme (Upload sendiri)"
        echo -e "${RED}x.${NC} 🔙 Kembali ke menu utama"
        echo
        echo -e "${YELLOW}Masukkan pilihan (1/2/3/4/x):${NC}"
        read -r SELECT_THEME
        
        case "$SELECT_THEME" in
            1)
                THEME_URL="https://github.com/Liwirya/Panel-Installer/raw/main/stellar.zip"
                THEME_NAME="stellar"
                install_selected_theme "$THEME_URL" "$THEME_NAME"
                break
                ;;
            2)
                THEME_URL="https://github.com/Liwirya/Panel-Installer/raw/main/billing.zip"
                THEME_NAME="billing"
                install_billing_theme "$THEME_URL" "$THEME_NAME"
                break
                ;;
            3)
                THEME_URL="https://github.com/Liwirya/Panel-Installer/raw/main/enigma.zip"
                THEME_NAME="enigma"
                install_enigma_theme "$THEME_URL" "$THEME_NAME"
                break
                ;;
            4)
                install_custom_theme
                break
                ;;
            x)
                return
                ;;
            *)
                print_error "Pilihan tidak valid! Silakan coba lagi."
                sleep 2
                ;;
        esac
    done
}

install_selected_theme() {
    local THEME_URL=$1
    local THEME_NAME=$2
    
    print_header "              INSTALASI TEMA ${THEME_NAME^^}               "
    
    # Backup existing theme
    print_status "💾 Membuat backup tema lama..."
    if [ -d "/var/www/pterodactyl" ]; then
        cp -rf /var/www/pterodactyl /var/www/pterodactyl.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Remove old theme files
    if [ -e /root/pterodactyl ]; then
        rm -rf /root/pterodactyl
    fi
    
    # Download and extract theme
    print_status "⬇️  Mengunduh tema $THEME_NAME..."
    wget -q "$THEME_URL" -O "/root/${THEME_NAME}.zip"
    
    if [ $? -ne 0 ]; then
        print_error "Gagal mengunduh tema!"
        return 1
    fi
    
    print_status "📦 Mengekstrak tema..."
    unzip -o "/root/${THEME_NAME}.zip" -d /root/
    
    # Install theme
    print_status "🎨 Menginstall tema..."
    cp -rfT /root/pterodactyl /var/www/pterodactyl
    
    # Install Node.js and dependencies
    print_status "📦 Menginstall Node.js dan dependencies..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - >> "$LOG_FILE" 2>&1
    apt install -y nodejs >> "$LOG_FILE" 2>&1
    npm install -g yarn >> "$LOG_FILE" 2>&1
    
    # Build theme
    cd /var/www/pterodactyl
    yarn install >> "$LOG_FILE" 2>&1
    yarn add react-feather >> "$LOG_FILE" 2>&1
    php artisan migrate --force >> "$LOG_FILE" 2>&1
    yarn build:production >> "$LOG_FILE" 2>&1
    php artisan view:clear >> "$LOG_FILE" 2>&1
    php artisan config:clear >> "$LOG_FILE" 2>&1
    
    # Set permissions
    chown -R www-data:www-data /var/www/pterodactyl/*
    
    # Cleanup
    rm -rf "/root/${THEME_NAME}.zip" /root/pterodactyl
    
    print_status "✅ Tema $THEME_NAME berhasil diinstall!"
    sleep 3
}

install_billing_theme() {
    local THEME_URL=$1
    local THEME_NAME=$2
    
    print_header "              INSTALASI TEMA BILLING               "
    
    install_selected_theme "$THEME_URL" "$THEME_NAME"
    
    print_status "💰 Mengkonfigurasi sistem billing..."
    cd /var/www/pterodactyl
    php artisan billing:install stable >> "$LOG_FILE" 2>&1
    
    print_status "✅ Tema billing dengan sistem pembayaran berhasil diinstall!"
    print_warning "ℹ️  Konfigurasi payment gateway melalui panel admin."
    sleep 3
}

install_enigma_theme() {
    local THEME_URL=$1
    local THEME_NAME=$2
    
    print_header "              INSTALASI TEMA ENIGMA                "
    
    echo -e "${CYAN}🔗 Masukkan link WhatsApp (https://wa.me/...):${NC}"
    read -r LINK_WA
    while ! validate_url "$LINK_WA"; do
        print_error "Format URL tidak valid!"
        echo -e "${CYAN}🔗 Masukkan link WhatsApp (https://wa.me/...):${NC}"
        read -r LINK_WA
    done
    
    echo -e "${CYAN}👥 Masukkan link grup (https://...):${NC}"
    read -r LINK_GROUP
    while ! validate_url "$LINK_GROUP"; do
        print_error "Format URL tidak valid!"
        echo -e "${CYAN}👥 Masukkan link grup (https://...):${NC}"
        read -r LINK_GROUP
    done
    
    echo -e "${CYAN}📺 Masukkan link channel (https://...):${NC}"
    read -r LINK_CHNL
    while ! validate_url "$LINK_CHNL"; do
        print_error "Format URL tidak valid!"
        echo -e "${CYAN}📺 Masukkan link channel (https://...):${NC}"
        read -r LINK_CHNL
    done
    
    print_status "⬇️  Mengunduh tema enigma..."
    rm -rf /root/pterodactyl
    wget -q "$THEME_URL" -O "/root/enigma.zip"
    unzip -o "/root/enigma.zip" -d /root/
    
    print_status "🔧 Mengkustomisasi tema dengan informasi Anda..."
    if [ -f "/root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx" ]; then
        sed -i "s|LINK_WA|$LINK_WA|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
        sed -i "s|LINK_GROUP|$LINK_GROUP|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
        sed -i "s|LINK_CHNL|$LINK_CHNL|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    fi
    
    install_selected_theme "$THEME_URL" "enigma"
}

install_custom_theme() {
    print_header "               INSTALASI TEMA CUSTOM                "
    
    echo -e "${CYAN}🔗 Masukkan URL tema custom (.zip):${NC}"
    read -r CUSTOM_URL
    
    while ! validate_url "$CUSTOM_URL"; do
        print_error "Format URL tidak valid!"
        echo -e "${CYAN}🔗 Masukkan URL tema custom (.zip):${NC}"
        read -r CUSTOM_URL
    done
    
    echo -e "${CYAN}📛 Masukkan nama tema:${NC}"
    read -r CUSTOM_NAME
    
    install_selected_theme "$CUSTOM_URL" "$CUSTOM_NAME"
}

uninstall_theme() {
    print_header "                HAPUS TEMA PANEL                "
    
    echo -e "${RED}⚠️  Apakah Anda yakin ingin menghapus tema dan restore ke default? (y/n):${NC}"
    read -r CONFIRM
    
    if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
        print_status "Pembatalan operasi."
        return
    fi
    
    print_status "🔄 Menjalankan script restore tema..."
    bash <(curl -s https://raw.githubusercontent.com/VallzHost/installer-theme/main/repair.sh) >> "$LOG_FILE" 2>&1
    
    if [ $? -eq 0 ]; then
        print_status "✅ Tema berhasil dihapus dan direstore ke default!"
    else
        print_error "❌ Gagal menghapus tema!"
    fi
    
    sleep 3
}

create_node() {
    print_header "                BUAT NODE BARU                "
    
    echo -e "${CYAN}📍 Masukkan nama lokasi:${NC}"
    read -r location_name
    
    echo -e "${CYAN}📝 Masukkan deskripsi lokasi:${NC}"
    read -r location_description
    
    echo -e "${CYAN}🌐 Masukkan domain/IP node:${NC}"
    read -r domain
    while ! validate_domain "$domain"; do
        print_error "Format domain/IP tidak valid!"
        echo -e "${CYAN}🌐 Masukkan domain/IP node:${NC}"
        read -r domain
    done
    
    echo -e "${CYAN}🏷️  Masukkan nama node:${NC}"
    read -r node_name
    
    echo -e "${CYAN}💾 Masukkan RAM (MB):${NC}"
    read -r ram
    while ! validate_number "$ram"; do
        print_error "RAM harus berupa angka!"
        echo -e "${CYAN}💾 Masukkan RAM (MB):${NC}"
        read -r ram
    done
    
    echo -e "${CYAN}💿 Masukkan disk space (MB):${NC}"
    read -r disk_space
    while ! validate_number "$disk_space"; do
        print_error "Disk space harus berupa angka!"
        echo -e "${CYAN}💿 Masukkan disk space (MB):${NC}"
        read -r disk_space
    done
    
    echo -e "${CYAN}🆔 Masukkan Location ID:${NC}"
    read -r locid
    while ! validate_number "$locid"; do
        print_error "Location ID harus berupa angka!"
        echo -e "${CYAN}🆔 Masukkan Location ID:${NC}"
        read -r locid
    done
    
    cd /var/www/pterodactyl || {
        print_error "Direktori pterodactyl tidak ditemukan!"
        return 1
    }
    
    print_status "📍 Membuat lokasi baru..."
    php artisan p:location:make <<EOF
$location_name
$location_description
EOF
    
    print_status "🖥️  Membuat node baru..."
    php artisan p:node:make <<EOF
$node_name
$location_description
$locid
https
$domain
yes
no
no
$ram
$ram
$disk_space
$disk_space
100
8080
2022
/var/lib/pterodactyl/volumes
EOF
    
    if [ $? -eq 0 ]; then
        print_status "✅ Node dan lokasi berhasil dibuat!"
        echo -e "${GREEN}📍 Lokasi: $location_name${NC}"
        echo -e "${GREEN}🖥️  Node: $node_name${NC}"
        echo -e "${GREEN}🌐 Domain: $domain${NC}"
    else
        print_error "❌ Gagal membuat node!"
    fi
    
    sleep 3
}

configure_wings() {
    print_header "                KONFIGURASI WINGS                "
    
    echo -e "${YELLOW}ℹ️  Salin konfigurasi dari panel admin -> Nodes -> Configuration${NC}"
    echo -e "${CYAN}📋 Paste konfigurasi Wings:${NC}"
    read -r wings_config
    
    print_status "⚙️  Mengkonfigurasi Wings..."
    
    eval "$wings_config"

    systemctl enable wings
    systemctl start wings
    
    if systemctl is-active --quiet wings; then
        print_status "✅ Wings berhasil dikonfigurasi dan dijalankan!"
        print_status "🔄 Status: $(systemctl is-active wings)"
    else
        print_error "❌ Gagal menjalankan Wings!"
        print_error "📋 Check log: journalctl -u wings -f"
    fi
    
    sleep 3
}

uninstall_panel() {
    print_header "               UNINSTALL PANEL                "
    
    echo -e "${RED}⚠️  PERINGATAN: Ini akan menghapus SEMUA data panel!${NC}"
    echo -e "${RED}💾 Pastikan Anda sudah backup data penting!${NC}"
    echo -e "${RED}❓ Apakah Anda yakin? (yes/no):${NC}"
    read -r CONFIRM
    
    if [[ $CONFIRM != "yes" ]]; then
        print_status "Operasi dibatalkan."
        return
    fi
    
    print_status "🗑️  Menjalankan uninstaller..."
    bash <(curl -s https://pterodactyl-installer.se) <<EOF
y
y
y
y
EOF
    
    if [ $? -eq 0 ]; then
        print_status "✅ Panel berhasil di-uninstall!"
    else
        print_error "❌ Gagal meng-uninstall panel!"
    fi
    
    sleep 3
}

create_admin_user() {
    print_header "               BUAT USER ADMIN BARU                "
    
    echo -e "${CYAN}👤 Masukkan username admin:${NC}"
    read -r admin_user
    
    echo -e "${CYAN}📧 Masukkan email admin:${NC}"
    read -r admin_email
    
    echo -e "${CYAN}🔒 Masukkan password admin:${NC}"
    read -s admin_password
    echo
    
    cd /var/www/pterodactyl || {
        print_error "Direktori pterodactyl tidak ditemukan!"
        return 1
    }
    
    print_status "👤 Membuat user admin baru..."
    php artisan p:user:make <<EOF
yes
$admin_email
$admin_user
$admin_user
$admin_user
$admin_password
EOF
    
    if [ $? -eq 0 ]; then
        print_status "✅ User admin berhasil dibuat!"
        echo -e "${GREEN}👤 Username: $admin_user${NC}"
        echo -e "${GREEN}📧 Email: $admin_email${NC}"
    else
        print_error "❌ Gagal membuat user admin!"
    fi
    
    sleep 3
}

change_vps_password() {
    print_header "               UBAH PASSWORD VPS                "
    
    echo -e "${CYAN}🔒 Masukkan password baru:${NC}"
    read -s new_password
    echo
    
    echo -e "${CYAN}🔒 Konfirmasi password baru:${NC}"
    read -s confirm_password
    echo
    
    if [ "$new_password" != "$confirm_password" ]; then
        print_error "Password tidak cocok!"
        return 1
    fi
    
    print_status "🔑 Mengubah password VPS..."
    echo "root:$new_password" | chpasswd
    
    if [ $? -eq 0 ]; then
        print_status "✅ Password VPS berhasil diubah!"
        print_warning "⚠️  Jangan lupa catat password baru!"
    else
        print_error "❌ Gagal mengubah password VPS!"
    fi
    
    sleep 3
}

show_system_info() {
    print_header "              INFORMASI SISTEM              "
    
    echo -e "${CYAN}🖥️  Hostname:${NC} $(hostname)"
    echo -e "${CYAN}💻 OS:${NC} $(lsb_release -d | cut -f2)"
    echo -e "${CYAN}🔧 Kernel:${NC} $(uname -r)"
    echo -e "${CYAN}💾 RAM:${NC} $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "${CYAN}💿 Disk:${NC} $(df -h / | awk 'NR==2 {print $2}')"
    echo -e "${CYAN}🌐 IP Public:${NC} $(curl -s ifconfig.me)"
    echo -e "${CYAN}⏰ Uptime:${NC} $(uptime -p)"
    
    if systemctl is-active --quiet pterodactyl; then
        echo -e "${GREEN}✅ Panel Status: Active${NC}"
    else
        echo -e "${RED}❌ Panel Status: Inactive${NC}"
    fi
    
    if systemctl is-active --quiet wings; then
        echo -e "${GREEN}✅ Wings Status: Active${NC}"
    else
        echo -e "${RED}❌ Wings Status: Inactive${NC}"
    fi
    
    echo
    echo -e "${YELLOW}Tekan Enter untuk kembali...${NC}"
    read
}

backup_panel() {
    print_header "                BACKUP PANEL                "
    
    BACKUP_DIR="/root/pterodactyl-backups"
    BACKUP_NAME="pterodactyl-backup-$(date +%Y%m%d_%H%M%S)"
    
    mkdir -p "$BACKUP_DIR"
    
    print_status "💾 Membuat backup panel..."
    
    tar -czf "$BACKUP_DIR/$BACKUP_NAME-files.tar.gz" -C /var/www pterodactyl
    
    mysqldump -u root pterodactyl > "$BACKUP_DIR/$BACKUP_NAME-database.sql"
    
    print_status "✅ Backup selesai!"
    echo -e "${GREEN}📁 Lokasi: $BACKUP_DIR/$BACKUP_NAME-*${NC}"
    
    sleep 3
}

display_menu() {
    clear
    echo -e "                                                                     "
    echo -e "${RED}        _,gggggggggg.                                     ${NC}"
    echo -e "${RED}    ,ggggggggggggggggg.                                   ${NC}"
    echo -e "${RED}  ,ggggg        gggggggg.                                 ${NC}"
    echo -e "${RED} ,ggg'               'ggg.                                ${NC}"
    echo -e "${RED}',gg       ,ggg.      'ggg:                               ${NC}"
    echo -e "${RED}'ggg      ,gg'''  .    ggg       Auto Installer Liwirya 2025   ${NC}"
    echo -e "${RED}gggg      gg     ,     ggg      ────────────────────────────  ${NC}"
    echo -e "${RED}ggg:     gg.     -   ,ggg       • Telegram : @senkaliwirya      ${NC}"
    echo -e "${RED} ggg:     ggg._    _,ggg        • Credits  : @Liwirya  ${NC}"
    echo -e "${RED} ggg.    '.'''ggggggp           • Support  : Clorinde ID Team  ${NC}"
    echo -e "${RED}  'ggg    '-.__                 • Version  : 2.0     ${NC}"
    echo -e "${RED}    ggg                                                   ${NC}"
    echo -e "${RED}      ggg                                                 ${NC}"
    echo -e "${RED}        ggg.                                              ${NC}"
    echo -e "${RED}          ggg.                                            ${NC}"
    echo -e "${RED}             b.                                           ${NC}"
    echo -e "                                                                     "
    
    print_header "                MENU UTAMA INSTALLER                "
    echo
    echo -e "${BLUE}📦 INSTALASI & SETUP:${NC}"
    echo -e "  ${CYAN}1.${NC}  🚀 Install Pterodactyl Panel"
    echo -e "  ${CYAN}2.${NC}  🖥️  Install Wings (Node)"
    echo -e "  ${CYAN}3.${NC}  🎨 Install Tema Panel"
    echo -e "  ${CYAN}4.${NC}  ⚙️  Konfigurasi Wings"
    echo
    echo -e "${GREEN}🔧 MANAGEMENT:${NC}"
    echo -e "  ${CYAN}5.${NC}  🏗️  Buat Node & Lokasi"
    echo -e "  ${CYAN}6.${NC}  👤 Buat User Admin"
    echo -e "  ${CYAN}7.${NC}  💾 Backup Panel"
    echo -e "  ${CYAN}8.${NC}  📊 Info Sistem"
    echo
    echo -e "${YELLOW}🛠️  MAINTENANCE:${NC}"
    echo -e "  ${CYAN}9.${NC}  🗑️  Uninstall Tema"
    echo -e "  ${CYAN}10.${NC} 🗑️  Uninstall Panel"
    echo -e "  ${CYAN}11.${NC} 🔑 Ubah Password VPS"
    echo
    echo -e "${PURPLE}🎯 TOOLS TAMBAHAN:${NC}"
    echo -e "  ${CYAN}12.${NC} 🔄 Restart Semua Service"
    echo -e "  ${CYAN}13.${NC} 🧹 Bersihkan Cache"
    echo -e "  ${CYAN}14.${NC} 📝 View Logs"
    echo -e "  ${CYAN}15.${NC} 🌟 Update Script"
    echo
    echo -e "  ${RED}x.${NC}  🚪 Keluar"
    echo
    echo -e "${YELLOW}Masukkan pilihan (1-15/x):${NC} "
}

restart_services() {
    print_header "              RESTART SEMUA SERVICE              "
    
    services=("nginx" "apache2" "mysql" "mariadb" "redis-server" "pterodactyl" "wings" "docker")
    
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "^$service.service"; then
            print_status "🔄 Restarting $service..."
            systemctl restart "$service" >> "$LOG_FILE" 2>&1
            if systemctl is-active --quiet "$service"; then
                echo -e "   ${GREEN}✅ $service: Active${NC}"
            else
                echo -e "   ${RED}❌ $service: Failed${NC}"
            fi
        fi
    done
    
    sleep 3
}

clear_cache() {
    print_header "                BERSIHKAN CACHE                "
    
    print_status "🧹 Membersihkan cache sistem..."
    
    sync && echo 3 > /proc/sys/vm/drop_caches
    
    if [ -d "/var/www/pterodactyl" ]; then
        cd /var/www/pterodactyl
        print_status "🧹 Membersihkan cache Pterodactyl..."
        php artisan cache:clear >> "$LOG_FILE" 2>&1
        php artisan config:clear >> "$LOG_FILE" 2>&1
        php artisan view:clear >> "$LOG_FILE" 2>&1
        php artisan route:clear >> "$LOG_FILE" 2>&1
    fi
    
    # Clear package cache
    apt autoclean && apt autoremove -y >> "$LOG_FILE" 2>&1
    
    print_status "✅ Cache berhasil dibersihkan!"
    sleep 3
}

view_logs() {
    print_header "                 VIEW LOGS                 "
    
    echo -e "${CYAN}Pilih log yang ingin dilihat:${NC}"
    echo -e "1. 📋 Log Script Installer"
    echo -e "2. 🖥️  Log Wings"
    echo -e "3. 🌐 Log Nginx/Apache"
    echo -e "4. 🗄️  Log MySQL/MariaDB"
    echo -e "5. 🐳 Log Docker"
    echo -e "x. 🔙 Kembali"
    
    read -r LOG_CHOICE
    
    case "$LOG_CHOICE" in
        1)
            if [ -f "$LOG_FILE" ]; then
                tail -50 "$LOG_FILE"
            else
                print_error "Log file tidak ditemukan!"
            fi
            ;;
        2)
            journalctl -u wings -n 50 --no-pager
            ;;
        3)
            if [ -f "/var/log/nginx/error.log" ]; then
                tail -50 /var/log/nginx/error.log
            elif [ -f "/var/log/apache2/error.log" ]; then
                tail -50 /var/log/apache2/error.log
            else
                print_error "Log web server tidak ditemukan!"
            fi
            ;;
        4)
            if [ -f "/var/log/mysql/error.log" ]; then
                tail -50 /var/log/mysql/error.log
            elif [ -f "/var/log/mariadb/mariadb.log" ]; then
                tail -50 /var/log/mariadb/mariadb.log
            else
                print_error "Log database tidak ditemukan!"
            fi
            ;;
        5)
            journalctl -u docker -n 50 --no-pager
            ;;
        x)
            return
            ;;
        *)
            print_error "Pilihan tidak valid!"
            ;;
    esac
    
    echo
    echo -e "${YELLOW}Tekan Enter untuk kembali...${NC}"
    read
}

update_script() {
    print_header "                UPDATE SCRIPT                "
    
    print_status "🔄 Memeriksa update terbaru..."
    
    SCRIPT_URL="https://raw.githubusercontent.com/Liwirya/Panel-Installer/main/install.sh"
    TEMP_SCRIPT="/tmp/install_new.sh"
    
    wget -q "$SCRIPT_URL" -O "$TEMP_SCRIPT"
    
    if [ $? -eq 0 ]; then
        if ! cmp -s "$0" "$TEMP_SCRIPT"; then
            print_status "📥 Update tersedia! Menginstall..."
            cp "$TEMP_SCRIPT" "$0"
            chmod +x "$0"
            print_status "✅ Script berhasil diupdate!"
            echo -e "${YELLOW}🔄 Restart script untuk menggunakan versi terbaru.${NC}"
        else
            print_status "✅ Script sudah versi terbaru!"
        fi
    else
        print_error "❌ Gagal memeriksa update!"
    fi
    
    rm -f "$TEMP_SCRIPT"
    sleep 3
}

optimize_system() {
    print_header "             OPTIMASI SISTEM             "
    
    print_status "⚡ Mengoptimasi kinerja sistem..."
    
    if command -v mysql >/dev/null 2>&1; then
        cat >> /etc/mysql/mysql.conf.d/pterodactyl.cnf << 'EOF'
[mysqld]
innodb_buffer_pool_size = 256M
innodb_log_file_size = 64M
max_connections = 200
query_cache_size = 32M
query_cache_limit = 2M
EOF
        systemctl restart mysql
    fi
    
    if [ -f "/etc/php/8.1/fpm/php.ini" ]; then
        sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/8.1/fpm/php.ini
        sed -i 's/upload_max_filesize = .*/upload_max_filesize = 100M/' /etc/php/8.1/fpm/php.ini
        sed -i 's/post_max_size = .*/post_max_size = 100M/' /etc/php/8.1/fpm/php.ini
        systemctl restart php8.1-fpm
    fi
    
    cat >> /etc/sysctl.conf << 'EOF'
# Pterodactyl optimizations
vm.swappiness = 10
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 65536 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
EOF
    
    sysctl -p >> "$LOG_FILE" 2>&1
    
    print_status "✅ Sistem berhasil dioptimasi!"
    sleep 3
}

security_hardening() {
    print_header "             KEAMANAN SISTEM             "
    
    print_status "🔒 Menerapkan pengaturan keamanan..."
    
    apt install -y fail2ban >> "$LOG_FILE" 2>&1
    
    cat > /etc/fail2ban/jail.local << 'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
EOF
    
    systemctl enable fail2ban
    systemctl start fail2ban
    
    if command -v ufw >/dev/null 2>&1; then
        ufw --force enable
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow ssh
        ufw allow 80/tcp
        ufw allow 443/tcp
        ufw allow 8080/tcp
        ufw allow 2022/tcp
    fi
    
    print_status "✅ Pengaturan keamanan diterapkan!"
    sleep 3
}

main() {
    touch "$LOG_FILE"
    log_message "Script started"
    
    check_root
    
    display_welcome
    install_dependencies
    check_token
    
    while true; do
        display_menu
        read -r MENU_CHOICE
        clear
        
        case "$MENU_CHOICE" in
            1)
                install_panel
                ;;
            2)
                install_wings
                ;;
            3)
                install_theme
                ;;
            4)
                configure_wings
                ;;
            5)
                create_node
                ;;
            6)
                create_admin_user
                ;;
            7)
                backup_panel
                ;;
            8)
                show_system_info
                ;;
            9)
                uninstall_theme
                ;;
            10)
                uninstall_panel
                ;;
            11)
                change_vps_password
                ;;
            12)
                restart_services
                ;;
            13)
                clear_cache
                ;;
            14)
                view_logs
                ;;
            15)
                update_script
                ;;
            16)
                optimize_system
                ;;
            17)
                security_hardening
                ;;
            x)
                print_status "👋 Terima kasih telah menggunakan Liwirya Installer!"
                print_status "📱 Support: @senkaliwirya"
                log_message "Script ended"
                exit 0
                ;;
            *)
                print_error "Pilihan tidak valid! Silakan pilih 1-15 atau x."
                sleep 2
                ;;
        esac
    done
}

main "$@"
