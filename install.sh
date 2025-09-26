#!/bin/bash

# =============================================================================
# PTERODACTYL PANEL INSTALLER (OFFICIAL-COMPATIBLE)
# Versi: 2.1
# Dibuat oleh: Liwirya
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
    local domain="$1"
    if [[ $domain =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
        return 0
    else
        return 1
    fi
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Script ini harus dijalankan sebagai root."
        exit 1
    fi
}

install_dependencies() {
    print_header "MENGUPDATE & INSTALL DEPENDENCIES"
    apt update -y >> "$LOG_FILE" 2>&1
    apt install -y curl wget unzip software-properties-common apt-transport-https ca-certificates lsb-release >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        print_error "Gagal menginstall dependencies"
        exit 1
    fi
    print_status "Dependencies berhasil diinstall"
}

install_panel() {
    print_header "INSTALASI PTERODACTYL PANEL"

    while true; do
        read -rp "Masukkan FQDN (contoh: panel.domain.com): " PANEL_FQDN
        if validate_domain "$PANEL_FQDN"; then
            break
        else
            print_error "Domain tidak valid"
        fi
    done

    read -rp "Email admin: " ADMIN_EMAIL
    read -rp "Username admin: " ADMIN_USERNAME
    read -rsp "Password admin: " ADMIN_PASSWORD
    echo

    print_status "Mengunduh installer resmi..."

    # Unduh installer resmi dari sumber tepercaya
    if ! curl -sSf -o /tmp/pterodactyl-installer.sh "https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer/master/install-panel.sh"; then
        print_error "Gagal mengunduh installer resmi"
        exit 1
    fi

    chmod +x /tmp/pterodactyl-installer.sh

    print_status "Menjalankan installer panel..."

    # Jalankan dengan input otomatis
    /tmp/pterodactyl-installer.sh <<EOF
$ADMIN_EMAIL
$ADMIN_USERNAME
$ADMIN_USERNAME
$ADMIN_PASSWORD
$PANEL_FQDN
y
y
pterodactyl
pterodactyl_user
$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-24)
y
y
UTC
$ADMIN_EMAIL
$ADMIN_USERNAME
$ADMIN_USERNAME
$ADMIN_PASSWORD
y
EOF

    if [ $? -eq 0 ]; then
        print_status "Panel berhasil diinstall!"
        echo -e "${GREEN}URL: https://$PANEL_FQDN${NC}"
    else
        print_error "Instalasi panel gagal"
        exit 1
    fi

    rm -f /tmp/pterodactyl-installer.sh
}

install_wings() {
    print_header "INSTALASI WINGS"

    print_status "Menginstall Docker..."
    if ! curl -fsSL https://get.docker.com -o /tmp/get-docker.sh; then
        print_error "Gagal mengunduh Docker installer"
        exit 1
    fi
    sh /tmp/get-docker.sh >> "$LOG_FILE" 2>&1
    systemctl enable --now docker
    rm -f /tmp/get-docker.sh

    print_status "Mengunduh Wings..."
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        BIN_ARCH="amd64"
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
        BIN_ARCH="arm64"
    else
        print_error "Arsitektur tidak didukung: $ARCH"
        exit 1
    fi

    if ! curl -L "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$BIN_ARCH" -o /usr/local/bin/wings; then
        print_error "Gagal mengunduh Wings"
        exit 1
    fi
    chmod +x /usr/local/bin/wings

    cat > /etc/systemd/system/wings.service << 'EOF'
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
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

    print_status "Wings berhasil diinstall"
    print_warning "Konfigurasi node melalui panel admin → Nodes → Configuration"
}

configure_wings() {
    print_header "KONFIGURASI WINGS"

    if [ ! -f /usr/local/bin/wings ]; then
        print_error "Wings belum diinstall"
        return 1
    fi

    print_status "Pastikan Anda sudah menyalin konfigurasi dari panel"
    echo -e "${YELLOW}Jalankan perintah berikut di server ini setelah menyalin dari panel:${NC}"
    echo -e "${CYAN}  wings configure${NC}"
    echo ""
    read -rp "Tekan Enter untuk melanjutkan..."
    wings configure
}

backup_panel() {
    print_header "BACKUP PANEL"

    BACKUP_DIR="/root/pterodactyl-backups"
    BACKUP_NAME="backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    if [ -d /var/www/pterodactyl ]; then
        tar -czf "$BACKUP_DIR/$BACKUP_NAME-files.tar.gz" -C /var/www pterodactyl --exclude="storage/logs/*"
        print_status "File backup disimpan di $BACKUP_DIR/$BACKUP_NAME-files.tar.gz"
    fi

    if command -v mysqldump >/dev/null 2>&1 && [ -f /var/www/pterodactyl/.env ]; then
        DB_NAME=$(grep DB_DATABASE /var/www/pterodactyl/.env | cut -d'=' -f2)
        DB_USER=$(grep DB_USERNAME /var/www/pterodactyl/.env | cut -d'=' -f2)
        DB_PASS=$(grep DB_PASSWORD /var/www/pterodactyl/.env | cut -d'=' -f2)
        if [ -n "$DB_NAME" ]; then
            mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_DIR/$BACKUP_NAME-db.sql"
            print_status "Database backup disimpan"
        fi
    fi
}

show_system_info() {
    print_header "INFORMASI SISTEM"
    echo "Hostname: $(hostname)"
    echo "OS: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "Kernel: $(uname -r)"
    echo "RAM: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $4}')"
    echo "IP Publik: $(curl -s --max-time 5 ifconfig.me || echo "N/A")"
    echo "Panel: $(systemctl is-active pterodactyl 2>/dev/null || echo "inactive")"
    echo "Wings: $(systemctl is-active wings 2>/dev/null || echo "inactive")"
    echo
    read -rp "Tekan Enter untuk kembali..."
}

display_menu() {
    clear
    print_header "MENU UTAMA - PTERODACTYL INSTALLER"
    echo
    echo "1. Install Panel"
    echo "2. Install Wings"
    echo "3. Konfigurasi Wings"
    echo "4. Backup Panel"
    echo "5. Info Sistem"
    echo "x. Keluar"
    echo
    read -rp "Pilihan (1-5/x): " choice
}

main() {
    touch "$LOG_FILE"
    log_message "Installer dimulai"

    check_root
    install_dependencies

    while true; do
        display_menu
        case "$choice" in
            1) install_panel ;;
            2) install_wings ;;
            3) configure_wings ;;
            4) backup_panel ;;
            5) show_system_info ;;
            x) 
                print_status "Terima kasih"
                exit 0
                ;;
            *)
                print_error "Pilihan tidak valid"
                sleep 1
                ;;
        esac
    done
}

main "$@"
