#!/bin/bash

# =============================================================================
# PTERODACTYL PANEL REPAIR & THEME UNINSTALLER
# Versi: 2.0
# Dibuat oleh: Liwirya
# =============================================================================

set -e  # Exit on any error

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m'

SPINNER="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"

LOG_FILE="/var/log/pterodactyl-repair.log"
BACKUP_DIR="/root/pterodactyl-backups"

PANEL_DIR="/var/www/pterodactyl"
PTERODACTYL_VERSION=""
PHP_VERSION=""
WEB_SERVER=""

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
    log_message "INFO: $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
    log_message "ERROR: $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
    log_message "WARNING: $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
    log_message "INFO: $1"
}

print_header() {
    local message="$1"
    local length=${#message}
    local padding=$(((60 - length) / 2))
    
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    printf "${BLUE}║${NC}"
    printf "%*s" $padding ""
    printf "${WHITE}%s${NC}" "$message"
    printf "%*s" $((60 - length - padding)) ""
    printf "${BLUE}║${NC}\n"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
}

show_spinner() {
    local pid=$1
    local message="$2"
    local delay=0.1
    local spinstr=$SPINNER
    
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [${CYAN}%c${NC}] %s\r" "$spinstr" "$message"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "    \r"
}

show_progress() {
    local current=$1
    local total=$2
    local message="$3"
    local percentage=$((current * 100 / total))
    local bar_length=40
    local filled_length=$((percentage * bar_length / 100))
    
    printf "\r${CYAN}["
    for ((i=0; i<filled_length; i++)); do
        printf "█"
    done
    for ((i=filled_length; i<bar_length; i++)); do
        printf "░"
    done
    printf "] %d%% %s${NC}" "$percentage" "$message"
    
    if [ $current -eq $total ]; then
        echo ""
    fi
}

display_welcome() {
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════════════╗
    ║                                                                      ║
    ║      ██████╗ ████████╗███████╗██████╗  ██████╗ ██████╗ ███████╗     ║
    ║      ██╔══██╗╚══██╔══╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝     ║
    ║      ██████╔╝   ██║   █████╗  ██████╔╝██║   ██║██║  ██║█████╗       ║
    ║      ██╔═══╝    ██║   ██╔══╝  ██╔══██╗██║   ██║██║  ██║██╔══╝       ║
    ║      ██║        ██║   ███████╗██║  ██║╚██████╔╝██████╔╝███████╗     ║
    ║      ╚═╝        ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝     ║
    ║                                                                      ║
    ║                    🔧 PANEL REPAIR & THEME REMOVER 🔧                ║
    ║                            © Liwirya 2025                         ║
    ╚══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${WHITE}🛠️  Script ini akan membantu Anda:${NC}"
    echo -e "${CYAN}   • Menghapus tema custom dan kembali ke tema default${NC}"
    echo -e "${CYAN}   • Memperbaiki panel yang rusak atau error${NC}"
    echo -e "${CYAN}   • Memperbarui file panel ke versi terbaru${NC}"
    echo -e "${CYAN}   • Backup otomatis sebelum repair${NC}"
    echo ""
    echo -e "${GRAY}📱 Telegram: @senkaliwirya | 💼 Support: Liwirya Team${NC}"
    echo ""
}

check_root() {
    if (( $EUID != 0 )); then
        print_error "Script ini memerlukan akses root!"
        echo -e "${YELLOW}💡 Solusi: Jalankan dengan 'sudo bash $0'${NC}"
        exit 1
    fi
    
    print_status "Akses root terverifikasi"
}

detect_system() {
    print_info "🔍 Mendeteksi konfigurasi sistem..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME="$NAME"
        OS_VERSION="$VERSION"
    else
        OS_NAME="Unknown"
        OS_VERSION="Unknown"
    fi
    
    if command -v php >/dev/null 2>&1; then
        PHP_VERSION=$(php -v | head -n1 | cut -d" " -f2 | cut -c1-3)
        print_status "PHP $PHP_VERSION terdeteksi"
    else
        print_error "PHP tidak ditemukan!"
        exit 1
    fi
    
    if systemctl is-active --quiet nginx; then
        WEB_SERVER="nginx"
        print_status "Web server: Nginx"
    elif systemctl is-active --quiet apache2; then
        WEB_SERVER="apache2"
        print_status "Web server: Apache2"
    else
        print_warning "Web server tidak terdeteksi atau tidak berjalan"
    fi
    
    if [ ! -d "$PANEL_DIR" ]; then
        print_error "Direktori Pterodactyl tidak ditemukan di $PANEL_DIR"
        echo -e "${YELLOW}💡 Pastikan Pterodactyl Panel sudah terinstall${NC}"
        exit 1
    fi
    
    if [ -f "$PANEL_DIR/config/app.php" ]; then
        cd "$PANEL_DIR"
        PTERODACTYL_VERSION=$(php artisan --version | cut -d" " -f3)
        print_status "Pterodactyl Panel v$PTERODACTYL_VERSION terdeteksi"
    fi
}

show_system_info() {
    print_header "INFORMASI SISTEM"
    
    echo -e "${CYAN}🖥️  Operating System:${NC} $OS_NAME $OS_VERSION"
    echo -e "${CYAN}🐘 PHP Version:${NC} $PHP_VERSION"
    echo -e "${CYAN}🌐 Web Server:${NC} $WEB_SERVER"
    echo -e "${CYAN}🦅 Panel Version:${NC} $PTERODACTYL_VERSION"
    echo -e "${CYAN}📁 Panel Directory:${NC} $PANEL_DIR"
    echo -e "${CYAN}💾 Disk Usage:${NC} $(df -h $PANEL_DIR | tail -1 | awk '{print $5}')"
    echo -e "${CYAN}🔧 User:${NC} $(whoami)"
    echo ""
    
    if systemctl is-active --quiet "$WEB_SERVER" && [ -f "$PANEL_DIR/artisan" ]; then
        echo -e "${GREEN}✅ Panel Status: Online${NC}"
    else
        echo -e "${RED}❌ Panel Status: Offline${NC}"
    fi
    echo ""
}

create_backup() {
    print_header "MEMBUAT BACKUP"
    
    local backup_name="pterodactyl-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    print_info "📦 Membuat backup di: $BACKUP_DIR/$backup_name"
    
    if command -v mysqldump >/dev/null 2>&1; then
        print_info "🗄️  Backup database..."
        local db_name=$(grep DB_DATABASE "$PANEL_DIR/.env" | cut -d'=' -f2)
        local db_user=$(grep DB_USERNAME "$PANEL_DIR/.env" | cut -d'=' -f2)
        local db_pass=$(grep DB_PASSWORD "$PANEL_DIR/.env" | cut -d'=' -f2)
        
        if [ -n "$db_name" ]; then
            mysqldump -u "$db_user" -p"$db_pass" "$db_name" > "$BACKUP_DIR/$backup_name-database.sql" 2>/dev/null
            if [ $? -eq 0 ]; then
                print_status "✅ Database backup berhasil"
            else
                print_warning "⚠️  Database backup gagal, melanjutkan tanpa backup DB"
            fi
        fi
    fi
    
    print_info "📁 Backup file panel..."
    tar -czf "$BACKUP_DIR/$backup_name-files.tar.gz" -C /var/www pterodactyl --exclude="node_modules" --exclude="storage/logs/*" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "✅ File backup berhasil disimpan"
        echo -e "${GRAY}📍 Backup location: $BACKUP_DIR/$backup_name-*${NC}"
    else
        print_warning "⚠️  File backup gagal"
    fi
    
    echo ""
}

pre_flight_checks() {
    print_header "PEMERIKSAAN SISTEM"
    
    local errors=0
    
    local disk_usage=$(df "$PANEL_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt 90 ]; then
        print_error "Disk space hampir penuh ($disk_usage%)"
        ((errors++))
    else
        print_status "Disk space tersedia ($disk_usage% used)"
    fi
    
    local mem_available=$(free -m | awk 'NR==2{printf "%.0f", $7*100/$2}')
    if [ "$mem_available" -lt 10 ]; then
        print_warning "Memory tersisa rendah"
    else
        print_status "Memory tersedia cukup"
    fi
    
    if ping -c 1 github.com >/dev/null 2>&1; then
        print_status "Koneksi internet tersedia"
    else
        print_error "Tidak ada koneksi internet"
        ((errors++))
    fi
    
    local required_commands=("php" "composer" "curl" "tar")
    for cmd in "${required_commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            print_status "$cmd tersedia"
        else
            print_error "$cmd tidak ditemukan"
            ((errors++))
        fi
    done
    
    if [ $errors -gt 0 ]; then
        echo ""
        print_error "Ditemukan $errors error(s). Tidak dapat melanjutkan."
        echo -e "${YELLOW}💡 Perbaiki error di atas terlebih dahulu${NC}"
        exit 1
    fi
    
    print_status "✅ Semua pemeriksaan berhasil!"
    echo ""
}

repair_panel() {
    print_header "PROSES REPAIR PANEL"
    
    cd "$PANEL_DIR" || {
        print_error "Tidak dapat masuk ke direktori panel"
        exit 1
    }
    
    print_info "🔒 Mengaktifkan maintenance mode..."
    php artisan down --message="Panel sedang dalam maintenance" --retry=60 2>/dev/null
    show_progress 1 8 "Maintenance mode aktif"
    
    print_info "💾 Backup resources lama..."
    if [ -d "resources" ]; then
        mv resources resources.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null
    fi
    show_progress 2 8 "Resources di-backup"
    
    print_info "⬇️  Download panel terbaru..."
    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv >/dev/null 2>&1 &
    local download_pid=$!
    show_spinner $download_pid "Downloading panel files..."
    wait $download_pid
    show_progress 3 8 "Panel terbaru di-download"
    
    print_info "🔐 Mengatur permissions..."
    chmod -R 755 storage/* bootstrap/cache/ 2>/dev/null
    show_progress 4 8 "Permissions diatur"
    
    print_info "📦 Install dependencies..."
    composer install --no-dev --optimize-autoloader >/dev/null 2>&1 &
    local composer_pid=$!
    show_spinner $composer_pid "Installing composer dependencies..."
    wait $composer_pid
    show_progress 5 8 "Dependencies terinstall"
    
    print_info "🧹 Clear caches..."
    php artisan view:clear >/dev/null 2>&1
    php artisan config:clear >/dev/null 2>&1
    php artisan route:clear >/dev/null 2>&1
    php artisan cache:clear >/dev/null 2>&1
    show_progress 6 8 "Cache dibersihkan"
    
    print_info "🗄️  Jalankan database migrations..."
    php artisan migrate --seed --force >/dev/null 2>&1
    show_progress 7 8 "Database migrations selesai"
    
    print_info "👤 Set ownership dan restart services..."
    chown -R www-data:www-data "$PANEL_DIR"/* 2>/dev/null
    
    php artisan queue:restart >/dev/null 2>&1
    
    if [ -n "$WEB_SERVER" ]; then
        systemctl restart "$WEB_SERVER" >/dev/null 2>&1
    fi
    
    php artisan up >/dev/null 2>&1
    
    show_progress 8 8 "Repair selesai!"
    echo ""
    
    print_status "✅ Panel berhasil diperbaiki!"
    print_info "🌐 Panel sekarang online dan siap digunakan"
    
    local panel_url=$(grep APP_URL "$PANEL_DIR/.env" | cut -d'=' -f2- | tr -d '"')
    if [ -n "$panel_url" ]; then
        echo -e "${CYAN}🔗 URL Panel: $panel_url${NC}"
    fi
}

confirm_repair() {
    echo ""
    print_header "KONFIRMASI REPAIR"
    
    echo -e "${YELLOW}⚠️  PERHATIAN PENTING:${NC}"
    echo -e "${WHITE}   • Proses ini akan menghapus tema custom yang terpasang${NC}"
    echo -e "${WHITE}   • Panel akan kembali ke tema default Pterodactyl${NC}"
    echo -e "${WHITE}   • Backup otomatis akan dibuat sebelum repair${NC}"
    echo -e "${WHITE}   • Panel akan offline sementara selama proses repair${NC}"
    echo -e "${WHITE}   • Data server dan user tidak akan terpengaruh${NC}"
    echo ""
    
    echo -e "${CYAN}⏱️  Estimasi waktu: 2-5 menit${NC}"
    echo -e "${CYAN}📊 Proses: 8 langkah otomatis${NC}"
    echo ""
    
    while true; do
        echo -e "${YELLOW}❓ Lanjutkan proses repair? ${NC}"
        echo -e "${CYAN}[Y]${NC} Ya, lanjutkan repair"
        echo -e "${CYAN}[N]${NC} Tidak, batalkan"
        echo -e "${CYAN}[I]${NC} Tampilkan info sistem"
        echo -e "${CYAN}[B]${NC} Buat backup saja"
        echo ""
        
        printf "${WHITE}Pilihan Anda (Y/N/I/B): ${NC}"
        read -r choice
        
        case ${choice^^} in
            Y|YES)
                echo ""
                print_status "🚀 Memulai proses repair..."
                return 0
                ;;
            N|NO)
                echo ""
                print_status "❌ Proses repair dibatalkan"
                echo -e "${GRAY}Terima kasih telah menggunakan Liwirya Repair Tool${NC}"
                exit 0
                ;;
            I|INFO)
                echo ""
                show_system_info
                ;;
            B|BACKUP)
                echo ""
                create_backup
                echo ""
                print_status "✅ Backup selesai, script akan keluar"
                exit 0
                ;;
            *)
                print_error "Pilihan tidak valid! Gunakan Y, N, I, atau B."
                echo ""
                ;;
        esac
    done
}

show_final_results() {
    clear
    print_header "REPAIR SELESAI"
    
    echo -e "${GREEN}"
    cat << "EOF"
    ██████╗ ███████╗██████╗  █████╗ ██╗██████╗     ███████╗██╗   ██╗██╗  ██╗███████╗███████╗
    ██╔══██╗██╔════╝██╔══██╗██╔══██╗██║██╔══██╗    ██╔════╝██║   ██║██║ ██╔╝██╔════╝██╔════╝
    ██████╔╝█████╗  ██████╔╝███████║██║██████╔╝    ███████╗██║   ██║█████╔╝ ███████╗█████╗  
    ██╔══██╗██╔══╝  ██╔═══╝ ██╔══██║██║██╔══██╗    ╚════██║██║   ██║██╔═██╗ ╚════██║██╔══╝  
    ██║  ██║███████╗██║     ██║  ██║██║██║  ██║    ███████║╚██████╔╝██║  ██╗███████║███████╗
    ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
EOF
    echo -e "${NC}"
    
    echo -e "${WHITE}🎉 Panel Pterodactyl berhasil diperbaiki!${NC}"
    echo ""
    
    echo -e "${CYAN}📋 RINGKASAN REPAIR:${NC}"
    echo -e "${WHITE}   ✅ Tema dikembalikan ke default${NC}"
    echo -e "${WHITE}   ✅ Panel diperbarui ke versi terbaru${NC}"
    echo -e "${WHITE}   ✅ Cache dibersihkan${NC}"
    echo -e "${WHITE}   ✅ Database migrations dijalankan${NC}"
    echo -e "${WHITE}   ✅ Permissions diperbaiki${NC}"
    echo -e "${WHITE}   ✅ Services direstart${NC}"
    echo ""
    
    echo -e "${YELLOW}🔧 LANGKAH SELANJUTNYA:${NC}"
    echo -e "${WHITE}   1. Login ke panel admin Anda${NC}"
    echo -e "${WHITE}   2. Periksa semua fungsi panel${NC}"
    echo -e "${WHITE}   3. Install tema baru jika diperlukan${NC}"
    echo -e "${WHITE}   4. Hapus backup lama jika tidak diperlukan${NC}"
    echo ""
    
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A $BACKUP_DIR)" ]; then
        echo -e "${GRAY}💾 Backup tersimpan di: $BACKUP_DIR${NC}"
    fi
    
    echo -e "${GRAY}📱 Support: @senkaliwirya | 🏢 Clorinde ID Team${NC}"
    echo ""
}

cleanup() {
    if [ -f "/tmp/pterodactyl-repair.lock" ]; then
        rm -f "/tmp/pterodactyl-repair.lock"
    fi
}

main() {
    trap cleanup EXIT
    
    echo $$ > "/tmp/pterodactyl-repair.lock"
    
    touch "$LOG_FILE"
    log_message "Repair script started by user: $(whoami)"
    
    display_welcome
    check_root
    detect_system
    show_system_info
    pre_flight_checks
    confirm_repair
    
    echo ""
    create_backup
    repair_panel
    show_final_results
    
    log_message "Repair script completed successfully"
    
    echo -e "${GRAY}Script akan keluar dalam 10 detik...${NC}"
    for i in {10..1}; do
        printf "\r${GRAY}Keluar dalam: %d detik${NC}" $i
        sleep 1
    done
    echo ""
}

main "$@"