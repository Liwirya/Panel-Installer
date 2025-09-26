#!/bin/bash

# =============================================================================
# PTERODACTYL NODE & LOCATION CREATOR
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
NC='\033[0m'

LOG_FILE="/var/log/pterodactyl-nodemaker.log"
PANEL_DIR="/var/www/pterodactyl"

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
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $1 ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
}

validate_domain() {
    local domain=$1
    if [[ $domain =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
        return 0
    elif [[ $domain =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        # Basic IPv4 check
        IFS='.' read -r a b c d <<< "$domain"
        if [ "$a" -le 255 ] && [ "$b" -le 255 ] && [ "$c" -le 255 ] && [ "$d" -le 255 ]; then
            return 0
        fi
    fi
    return 1
}

validate_number() {
    local number=$1
    if [[ $number =~ ^[0-9]+$ ]] && [ "$number" -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

validate_port() {
    local port=$1
    if [[ $port =~ ^[0-9]+$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
        return 0
    else
        return 1
    fi
}

check_database_connection() {
    print_status "Memeriksa koneksi database..."
    
    if [ ! -d "$PANEL_DIR" ]; then
        print_error "Direktori Pterodactyl tidak ditemukan di $PANEL_DIR!"
        return 1
    fi
    
    cd "$PANEL_DIR" || return 1
    
    if ! php artisan migrate:status > /dev/null 2>&1; then
        print_error "Koneksi database gagal! Pastikan .env sudah dikonfigurasi."
        return 1
    fi
    
    print_status "Koneksi database berhasil!"
    return 0
}

location_exists() {
    local short=$1
    cd "$PANEL_DIR" || return 1
    php -r "
        require 'vendor/autoload.php';
        \$app = require 'bootstrap/app.php';
        \$kernel = \$app->make(Illuminate\Contracts\Console\Kernel::class);
        \$kernel->bootstrap();
        \$exists = \App\Models\Location::where('short', '$short')->exists();
        echo \$exists ? '1' : '0';
    " 2>/dev/null | grep -q "1"
}

get_location_id() {
    local short=$1
    cd "$PANEL_DIR" || return 1
    php -r "
        require 'vendor/autoload.php';
        \$app = require 'bootstrap/app.php';
        \$kernel = \$app->make(Illuminate\Contracts\Console\Kernel::class);
        \$kernel->bootstrap();
        \$loc = \App\Models\Location::where('short', '$short')->first();
        echo \$loc ? \$loc->id : '';
    " 2>/dev/null
}

list_locations() {
    cd "$PANEL_DIR" || return 1
    php -r "
        require 'vendor/autoload.php';
        \$app = require 'bootstrap/app.php';
        \$kernel = \$app->make(Illuminate\Contracts\Console\Kernel::class);
        \$kernel->bootstrap();
        \$locs = \App\Models\Location::all();
        foreach (\$locs as \$l) {
            echo \"ID: {\$l->id} | Short: {\$l->short} | Long: {\$l->long}\n\";
        }
    " 2>/dev/null
}

get_system_info() {
    print_header "                    INFORMASI SISTEM                    "
    echo -e "${CYAN}Hostname:${NC} $(hostname)"
    echo -e "${CYAN}IP Publik:${NC} $(curl -s --max-time 5 ifconfig.me 2>/dev/null || echo "Tidak dapat dideteksi")"
    echo -e "${CYAN}RAM Total:${NC} $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "${CYAN}Disk Tersedia:${NC} $(df -h / | awk 'NR==2 {print $4}')"
    echo -e "${CYAN}OS:${NC} $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo ""
}

display_welcome() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                                                                      ${PURPLE}║${NC}"
    echo -e "${PURPLE}║            PTERODACTYL NODE & LOCATION CREATOR                        ${PURPLE}║${NC}"
    echo -e "${PURPLE}║                         © Liwirya 2025                               ${PURPLE}║${NC}"
    echo -e "${PURPLE}║                                                                      ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}Script ini akan membantu Anda membuat Node dan Lokasi baru${NC}"
    echo -e "${WHITE}untuk Pterodactyl Panel dengan mudah dan otomatis.${NC}"
    echo ""
    echo -e "${CYAN}Telegram: @senkaliwirya${NC}"
    echo -e "${CYAN}Support : Clorinde ID Team${NC}"
    echo ""
}

select_operation_mode() {
    echo -e "${YELLOW}Pilih operasi yang ingin dilakukan:${NC}"
    echo -e "${CYAN}1.${NC} Buat Lokasi dan Node baru"
    echo -e "${CYAN}2.${NC} Buat Node saja (gunakan lokasi yang ada)"
    echo -e "${CYAN}3.${NC} Buat Lokasi saja"
    echo -e "${CYAN}4.${NC} Lihat lokasi yang ada"
    echo -e "${CYAN}5.${NC} Keluar"
    echo ""

    while true; do
        read -rp "Masukkan pilihan (1-5): " operation_mode
        case $operation_mode in
            1|2|3|4|5) break ;;
            *) print_error "Pilihan tidak valid! Masukkan angka 1-5." ;;
        esac
    done
}

create_location() {
    local short=$1
    local long=$2
    cd "$PANEL_DIR" || return 1
    print_status "Membuat lokasi: $short..."
    if php artisan p:location:make --no-interaction <<< "$short
$long"; then
        print_status "Lokasi '$short' berhasil dibuat!"
        return 0
    else
        print_error "Gagal membuat lokasi '$short'!"
        return 1
    fi
}

create_node() {
    local name=$1
    local location_id=$2
    local domain=$3
    local ram=$4
    local disk=$5
    local daemon_port=${6:-8080}
    local sftp_port=${7:-2022}
    local base_dir=${8:-/var/lib/pterodactyl/volumes}

    cd "$PANEL_DIR" || return 1
    print_status "Membuat node: $name..."

    if php artisan p:node:make --no-interaction <<< "$name
Node $name - Auto created
$location_id
https
$domain
yes
no
no
$ram
$ram
$disk
$disk
100
$daemon_port
$sftp_port
$base_dir"; then
        print_status "Node '$name' berhasil dibuat!"
        return 0
    else
        print_error "Gagal membuat node '$name'!"
        return 1
    fi
}

input_location_data() {
    while true; do
        read -rp "Masukkan nama singkat lokasi (contoh: jakarta): " location_name
        if [ -z "$location_name" ]; then
            print_error "Nama lokasi tidak boleh kosong!"
            continue
        fi
        if [[ ! $location_name =~ ^[a-zA-Z0-9_-]+$ ]]; then
            print_error "Nama lokasi hanya boleh huruf, angka, underscore, dash."
            continue
        fi
        if location_exists "$location_name"; then
            print_error "Lokasi '$location_name' sudah ada!"
            continue
        fi
        break
    done

    while true; do
        read -rp "Masukkan deskripsi lokasi: " location_description
        if [ -z "$location_description" ]; then
            print_error "Deskripsi tidak boleh kosong!"
            continue
        fi
        break
    done
}

input_node_data() {
    while true; do
        read -rp "Masukkan nama node: " node_name
        [ -n "$node_name" ] && break
        print_error "Nama node tidak boleh kosong!"
    done

    while true; do
        read -rp "Masukkan domain atau IP node: " domain
        if [ -z "$domain" ]; then
            print_error "Domain/IP tidak boleh kosong!"
            continue
        fi
        if validate_domain "$domain"; then
            break
        else
            print_error "Format domain atau IP tidak valid!"
        fi
    done

    while true; do
        read -rp "Masukkan RAM dalam MB (min 512): " ram
        if validate_number "$ram" && [ "$ram" -ge 512 ]; then
            break
        else
            print_error "RAM harus angka >= 512"
        fi
    done

    while true; do
        read -rp "Masukkan disk space dalam MB (min 1024): " disk_space
        if validate_number "$disk_space" && [ "$disk_space" -ge 1024 ]; then
            break
        else
            print_error "Disk space harus angka >= 1024"
        fi
    done

    read -rp "Port daemon (default 8080): " daemon_port
    daemon_port=${daemon_port:-8080}
    if ! validate_port "$daemon_port"; then
        print_error "Port daemon tidak valid. Menggunakan default 8080."
        daemon_port=8080
    fi

    read -rp "Port SFTP (default 2022): " sftp_port
    sftp_port=${sftp_port:-2022}
    if ! validate_port "$sftp_port"; then
        print_error "Port SFTP tidak valid. Menggunakan default 2022."
        sftp_port=2022
    fi

    read -rp "Direktori base daemon (default /var/lib/pterodactyl/volumes): " daemon_base
    daemon_base=${daemon_base:-/var/lib/pterodactyl/volumes}
}

select_existing_location() {
    print_status "Mengambil daftar lokasi..."
    local locations
    locations=$(list_locations)
    if [ -z "$locations" ]; then
        print_error "Tidak ada lokasi tersedia!"
        return 1
    fi

    echo -e "${YELLOW}Lokasi yang tersedia:${NC}"
    echo "$locations"
    echo ""

    local ids=()
    while IFS= read -r line; do
        if [[ $line =~ ID:\ ([0-9]+) ]]; then
            ids+=("${BASH_REMATCH[1]}")
        fi
    done <<< "$locations"

    while true; do
        read -rp "Masukkan ID lokasi: " selected_location_id
        for id in "${ids[@]}"; do
            if [ "$id" = "$selected_location_id" ]; then
                return 0
            fi
        done
        print_error "ID lokasi tidak valid!"
    done
}

confirm_data() {
    echo ""
    print_header "                    KONFIRMASI DATA                    "

    case $operation_mode in
        1)
            echo "Lokasi:"
            echo "  Nama: $location_name"
            echo "  Deskripsi: $location_description"
            echo ""
            echo "Node:"
            echo "  Nama: $node_name"
            echo "  Domain: $domain"
            echo "  RAM: ${ram}MB"
            echo "  Disk: ${disk_space}MB"
            echo "  Port Daemon: $daemon_port"
            echo "  Port SFTP: $sftp_port"
            echo "  Base Directory: $daemon_base"
            ;;
        2)
            echo "Node:"
            echo "  Nama: $node_name"
            echo "  Domain: $domain"
            echo "  RAM: ${ram}MB"
            echo "  Disk: ${disk_space}MB"
            echo "  Port Daemon: $daemon_port"
            echo "  Port SFTP: $sftp_port"
            echo "  Base Directory: $daemon_base"
            echo "  Location ID: $selected_location_id"
            ;;
        3)
            echo "Lokasi:"
            echo "  Nama: $location_name"
            echo "  Deskripsi: $location_description"
            ;;
    esac

    echo ""
    read -rp "Apakah data sudah benar? (y/n): " confirm
    [[ $confirm == [Yy] ]]
}

display_results() {
    echo ""
    print_header "                    HASIL OPERASI                    "

    case $operation_mode in
        1)
            if [ $location_created -eq 0 ] && [ $node_created -eq 0 ]; then
                print_status "Lokasi dan Node berhasil dibuat!"
                echo ""
                echo "Informasi:"
                echo "Lokasi: $location_name - $location_description"
                echo "Node: $node_name ($domain)"
                echo "RAM: ${ram}MB | Disk: ${disk_space}MB"
                echo ""
                echo "Langkah selanjutnya:"
                echo "1. Login ke panel admin"
                echo "2. Buka Admin > Nodes"
                echo "3. Klik node '$node_name'"
                echo "4. Salin konfigurasi dan jalankan di server node"
                echo "5. Install Wings di server node"
            else
                print_error "Operasi gagal!"
            fi
            ;;
        2)
            if [ $node_created -eq 0 ]; then
                print_status "Node berhasil dibuat!"
                echo "Node: $node_name ($domain)"
            else
                print_error "Gagal membuat node!"
            fi
            ;;
        3)
            if [ $location_created -eq 0 ]; then
                print_status "Lokasi berhasil dibuat!"
                echo "Nama: $location_name"
            else
                print_error "Gagal membuat lokasi!"
            fi
            ;;
    esac
    echo ""
}

main() {
    touch "$LOG_FILE"
    log_message "Script dimulai"

    if [[ $EUID -ne 0 ]]; then
        print_error "Jalankan sebagai root!"
        exit 1
    fi

    display_welcome
    get_system_info

    if ! check_database_connection; then
        exit 1
    fi

    select_operation_mode

    case $operation_mode in
        1)
            print_header "BUAT LOKASI DAN NODE BARU"
            input_location_data
            input_node_data
            if confirm_data; then
                create_location "$location_name" "$location_description"
                location_created=$?
                if [ $location_created -eq 0 ]; then
                    location_id=$(get_location_id "$location_name")
                    if [ -z "$location_id" ]; then
                        print_error "Gagal mendapatkan ID lokasi!"
                        node_created=1
                    else
                        create_node "$node_name" "$location_id" "$domain" "$ram" "$disk_space" "$daemon_port" "$sftp_port" "$daemon_base"
                        node_created=$?
                    fi
                else
                    node_created=1
                fi
                display_results
            fi
            ;;
        2)
            print_header "BUAT NODE BARU"
            if ! select_existing_location; then
                exit 1
            fi
            input_node_data
            if confirm_data; then
                create_node "$node_name" "$selected_location_id" "$domain" "$ram" "$disk_space" "$daemon_port" "$sftp_port" "$daemon_base"
                node_created=$?
                display_results
            fi
            ;;
        3)
            print_header "BUAT LOKASI BARU"
            input_location_data
            if confirm_data; then
                create_location "$location_name" "$location_description"
                location_created=$?
                display_results
            fi
            ;;
        4)
            print_header "LOKASI YANG TERSEDIA"
            list_locations || echo "Gagal mengambil daftar lokasi."
            ;;
        5)
            print_status "Terima kasih telah menggunakan Liwirya Node Creator!"
            exit 0
            ;;
    esac

    log_message "Script selesai"
}

main "$@"
