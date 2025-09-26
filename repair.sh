#!/bin/bash

# =============================================================================
# PTERODACTYL PANEL REPAIR & THEME RESET TOOL
# Versi: 2.1
# Dibuat oleh: Liwirya
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m'

LOG_FILE="/var/log/pterodactyl-repair.log"
BACKUP_DIR="/root/pterodactyl-backups"
PANEL_DIR="/var/www/pterodactyl"

# Variabel sistem
OS_NAME=""
OS_VERSION=""
PHP_VERSION=""
WEB_SERVER=""
PTERODACTYL_VERSION=""

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
    local total_width=60
    local msg_len=${#message}
    local pad_left=$(( (total_width - msg_len) / 2 ))
    local pad_right=$(( total_width - msg_len - pad_left ))

    echo -e "${BLUE}╔$(printf '═%.0s' $(seq 1 $total_width))╗${NC}"
    printf "${BLUE}║${NC}%*s%s%*s${BLUE}║${NC}\n" $pad_left "" "$message" $pad_right ""
    echo -e "${BLUE}╚$(printf '═%.0s' $(seq 1 $total_width))╝${NC}"
}

display_welcome() {
    clear
    echo -e "${PURPLE}
    ╔══════════════════════════════════════════════════════════════════════╗
    ║                                                                      ║
    ║      ██████╗ ████████╗███████╗██████╗  ██████╗ ██████╗ ███████╗     ║
    ║      ██╔══██╗╚══██╔══╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝     ║
    ║      ██████╔╝   ██║   █████╗  ██████╔╝██║   ██║██║  ██║█████╗       ║
    ║      ██╔═══╝    ██║   ██╔══╝  ██╔══██╗██║   ██║██║  ██║██╔══╝       ║
    ║      ██║        ██║   ███████╗██║  ██║╚██████╔╝██████╔╝███████╗     ║
    ║      ╚═╝        ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝     ║
    ║                                                                      ║
    ║                    PANEL REPAIR & THEME RESET TOOL                   ║
    ║                            © Liwirya 2025                         ║
    ╚══════════════════════════════════════════════════════════════════════╝
${NC}"

    echo -e "${WHITE}Script ini akan:${NC}"
    echo -e "${CYAN}  • Mengembalikan panel ke tema default resmi${NC}"
    echo -e "${CYAN}  • Memperbarui file panel ke versi terbaru${NC}"
    echo -e "${CYAN}  • Memperbaiki cache, dependencies, dan migrasi${NC}"
    echo -e "${CYAN}  • Membuat backup otomatis sebelum perubahan${NC}"
    echo ""
    echo -e "${GRAY}Telegram: @senkaliwirya | Support: Liwirya Team${NC}"
    echo ""
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Script ini harus dijalankan sebagai root."
        echo -e "${YELLOW}Jalankan dengan: sudo bash $0${NC}"
        exit 1
    fi
    print_status "Akses root terverifikasi"
}

detect_system() {
    print_info "Mendeteksi konfigurasi sistem..."

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME="$NAME"
        OS_VERSION="$VERSION_ID"
    fi

    if command -v php >/dev/null 2>&1; then
        PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;" 2>/dev/null || echo "unknown")
        print_status "PHP $PHP_VERSION terdeteksi"
    else
        print_error "PHP tidak ditemukan"
        exit 1
    fi

    if systemctl is-active --quiet nginx; then
        WEB_SERVER="nginx"
    elif systemctl is-active --quiet apache2; then
        WEB_SERVER="apache2"
    fi

    if [ -n "$WEB_SERVER" ]; then
        print_status "Web server: $WEB_SERVER"
    else
        print_warning "Web server tidak aktif"
    fi

    if [ ! -d "$PANEL_DIR" ] || [ ! -f "$PANEL_DIR/artisan" ]; then
        print_error "Pterodactyl tidak ditemukan di $PANEL_DIR"
        exit 1
    fi

    cd "$PANEL_DIR" || exit 1
    if [ -f .env ]; then
        PTERODACTYL_VERSION=$(php artisan --version 2>/dev/null | cut -d' ' -f3 || echo "unknown")
        print_status "Pterodactyl v$PTERODACTYL_VERSION terdeteksi"
    else
        print_error "File .env tidak ditemukan"
        exit 1
    fi
}

show_system_info() {
    print_header "INFORMASI SISTEM"
    echo -e "${CYAN}OS:${NC} $OS_NAME $OS_VERSION"
    echo -e "${CYAN}PHP:${NC} $PHP_VERSION"
    echo -e "${CYAN}Web Server:${NC} ${WEB_SERVER:-tidak aktif}"
    echo -e "${CYAN}Panel Version:${NC} $PTERODACTYL_VERSION"
    echo -e "${CYAN}Panel Dir:${NC} $PANEL_DIR"
    echo -e "${CYAN}Disk Usage:${NC} $(df -h $PANEL_DIR | awk 'NR==2 {print $5}')"
    echo ""
}

create_backup() {
    print_header "MEMBUAT BACKUP"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_name="pterodactyl-backup-$timestamp"
    mkdir -p "$BACKUP_DIR"

    print_info "Backup file panel..."
    tar -czf "$BACKUP_DIR/$backup_name-files.tar.gz" -C /var/www pterodactyl \
        --exclude="storage/logs/*" \
        --exclude="storage/framework/cache/*" \
        --exclude="node_modules" 2>/dev/null

    if [ $? -eq 0 ]; then
        print_status "File backup berhasil: $BACKUP_DIR/$backup_name-files.tar.gz"
    else
        print_warning "Gagal membuat backup file"
    fi

    if command -v mysqldump >/dev/null 2>&1 && [ -f "$PANEL_DIR/.env" ]; then
        print_info "Backup database..."
        local db_name=$(grep -E "^DB_DATABASE=" "$PANEL_DIR/.env" | cut -d'=' -f2)
        local db_user=$(grep -E "^DB_USERNAME=" "$PANEL_DIR/.env" | cut -d'=' -f2)
        local db_pass=$(grep -E "^DB_PASSWORD=" "$PANEL_DIR/.env" | cut -d'=' -f2)

        if [ -n "$db_name" ] && [ -n "$db_user" ]; then
            mysqldump -u"$db_user" -p"$db_pass" "$db_name" > "$BACKUP_DIR/$backup_name-database.sql" 2>/dev/null
            if [ $? -eq 0 ]; then
                print_status "Database backup berhasil"
            else
                print_warning "Gagal backup database"
            fi
        fi
    fi
    echo ""
}

pre_flight_checks() {
    print_header "PEMERIKSAAN AWAL"

    local errors=0

    local disk_usage=$(df "$PANEL_DIR" | tail -1 | awk '{print $5}' | tr -d '%')
    if [ "$disk_usage" -gt 90 ]; then
        print_error "Disk hampir penuh ($disk_usage%)"
        ((errors++))
    fi

    if ! ping -c 1 github.com >/dev/null 2>&1; then
        print_error "Tidak ada koneksi internet"
        ((errors++))
    fi

    local required=("php" "composer" "curl" "tar" "mysqldump")
    for cmd in "${required[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            print_warning "$cmd tidak ditemukan (opsional)"
        fi
    done

    if [ $errors -gt 0 ]; then
        print_error "Ditemukan $errors error kritis. Perbaiki lalu jalankan ulang."
        exit 1
    fi

    print_status "Semua pemeriksaan lulus"
    echo ""
}

reset_theme_and_repair() {
    print_header "MEMPERBAIKI PANEL"

    cd "$PANEL_DIR" || { print_error "Gagal masuk ke direktori panel"; exit 1; }

    print_info "Aktifkan maintenance mode..."
    php artisan down --render="errors::503" --retry=60 >/dev/null 2>&1 || true

    print_info "Hapus tema custom (jika ada)..."
    if [ -d "resources/scripts/components/branding" ]; then
        rm -rf resources/scripts/components/branding
    fi
    if [ -f "resources/scripts/components/branding.tsx" ]; then
        rm -f resources/scripts/components/branding.tsx
    fi
    if [ -f "resources/views/layouts/admin.blade.php" ] || [ -f "resources/views/layouts/base.blade.php" ]; then
        print_warning "File tema custom terdeteksi di views/ — tidak dihapus (risiko tinggi)"
        print_info "Untuk reset penuh, pastikan tidak ada modifikasi di resources/views/"
    fi

    print_info "Download versi panel terbaru..."
    local latest_url=$(curl -s https://api.github.com/repos/pterodactyl/panel/releases/latest | grep "browser_download_url.*panel.tar.gz" | cut -d'"' -f4)
    if [ -z "$latest_url" ]; then
        print_error "Gagal mendapatkan URL rilis terbaru"
        exit 1
    fi

    curl -L "$latest_url" | tar -xz --strip-components=1 -f - 2>/dev/null
    if [ $? -ne 0 ]; then
        print_error "Gagal mengekstrak file panel"
        exit 1
    fi

    print_info "Atur izin direktori..."
    chown -R www-data:www-data storage/ bootstrap/cache/ 2>/dev/null
    chmod -R 755 storage/ bootstrap/cache/ 2>/dev/null

    print_info "Install dependensi PHP..."
    composer install --no-dev --optimize-autoloader --no-interaction >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        print_error "Gagal menginstal dependensi PHP"
        exit 1
    fi

    print_info "Bersihkan cache..."
    php artisan view:clear >/dev/null 2>&1
    php artisan config:clear >/dev/null 2>&1
    php artisan route:clear >/dev/null 2>&1
    php artisan cache:clear >/dev/null 2>&1

    print_info "Jalankan migrasi database..."
    php artisan migrate --force --no-interaction >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        print_error "Migrasi database gagal"
        exit 1
    fi

    print_info "Restart layanan..."
    php artisan queue:restart >/dev/null 2>&1
    if [ -n "$WEB_SERVER" ]; then
        systemctl reload "$WEB_SERVER" >/dev/null 2>&1
    fi

    php artisan up >/dev/null 2>&1

    print_status "Panel berhasil diperbaiki dan dikembalikan ke tema default"
    echo ""
}

confirm_repair() {
    print_header "KONFIRMASI REPAIR"

    echo -e "${YELLOW}Peringatan:${NC}"
    echo -e "  • Tema custom akan dihapus (file di resources/scripts/components/branding)"
    echo -e "  • File panel akan diganti dengan versi resmi terbaru"
    echo -e "  • Data user, server, dan database TIDAK akan terhapus"
    echo -e "  • Backup otomatis dibuat sebelum perubahan"
    echo ""

    while true; do
        read -rp "Lanjutkan? (y/n): " choice
        case $choice in
            [Yy]*)
                echo ""
                return 0
                ;;
            [Nn]*)
                print_status "Dibatalkan oleh pengguna"
                exit 0
                ;;
            *)
                echo "Masukkan y atau n"
                ;;
        esac
    done
}

show_final_results() {
    clear
    print_header "REPAIR BERHASIL"

    echo -e "${GREEN}Panel Pterodactyl telah dikembalikan ke kondisi default resmi.${NC}"
    echo ""
    echo -e "${CYAN}Langkah selanjutnya:${NC}"
    echo -e "  • Login ke panel dan verifikasi fungsionalitas"
    echo -e "  • Jika ingin tema baru, gunakan metode yang kompatibel dengan update"
    echo -e "  • Backup lama tersimpan di: $BACKUP_DIR"
    echo ""
    echo -e "${GRAY}Support: @senkaliwirya${NC}"
}

main() {
    touch "$LOG_FILE"
    log_message "Repair script dimulai oleh $(whoami)"

    display_welcome
    check_root
    detect_system
    show_system_info
    pre_flight_checks
    confirm_repair

    create_backup
    reset_theme_and_repair
    show_final_results

    log_message "Repair selesai"
}

main "$@"
