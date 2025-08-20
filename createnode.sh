#!/bin/bash

# =============================================================================
# PTERODACTYL NODE & LOCATION CREATOR
# Versi: 2.0 Enhanced - Compatible dengan Pterodactyl v1.11+
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
    else
        return 1
    fi
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
    print_status "🔍 Memeriksa koneksi database..."
    
    cd /var/www/pterodactyl || {
        print_error "Direktori Pterodactyl tidak ditemukan!"
        return 1
    }
    
    php artisan migrate:status > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_status "✅ Koneksi database berhasil!"
        return 0
    else
        print_error "❌ Koneksi database gagal!"
        print_error "Pastikan database sudah dikonfigurasi dengan benar."
        return 1
    fi
}

check_location_exists() {
    local location_name=$1
    cd /var/www/pterodactyl
    
    if php artisan tinker --execute "echo \App\Models\Location::where('short', '$location_name')->exists() ? 'exists' : 'not_exists';" 2>/dev/null | grep -q "exists"; then
        return 0
    else
        return 1
    fi
}

list_existing_locations() {
    print_status "📍 Lokasi yang sudah tersedia:"
    cd /var/www/pterodactyl
    
    php artisan tinker --execute "
        \$locations = \App\Models\Location::all();
        foreach(\$locations as \$location) {
            echo 'ID: ' . \$location->id . ' | Short: ' . \$location->short . ' | Long: ' . \$location->long . PHP_EOL;
        }
    " 2>/dev/null | grep -E "ID: [0-9]+" || echo "Belum ada lokasi yang dibuat."
}

get_system_info() {
    print_header "                    INFORMASI SISTEM                    "
    
    echo -e "${CYAN}🖥️  Hostname:${NC} $(hostname)"
    echo -e "${CYAN}🌐 IP Publik:${NC} $(curl -s ifconfig.me 2>/dev/null || echo "Tidak dapat dideteksi")"
    echo -e "${CYAN}💾 RAM Total:${NC} $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "${CYAN}💿 Disk Tersedia:${NC} $(df -h / | awk 'NR==2 {print $4}')"
    echo -e "${CYAN}🐧 OS:${NC} $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo ""
}

display_welcome() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}                                                                      ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}            ${WHITE}🚀 PTERODACTYL NODE & LOCATION CREATOR 🚀${NC}            ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}                         ${CYAN}© Liwirya 2025${NC}                         ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}                                                                      ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}Script ini akan membantu Anda membuat Node dan Lokasi baru${NC}"
    echo -e "${WHITE}untuk Pterodactyl Panel dengan mudah dan otomatis.${NC}"
    echo ""
    echo -e "${CYAN}📱 Telegram: @senkaliwirya${NC}"
    echo -e "${CYAN}💼 Support : Clorinde ID Team${NC}"
    echo ""
}

select_operation_mode() {
    echo -e "${YELLOW}Pilih operasi yang ingin dilakukan:${NC}"
    echo -e "${CYAN}1.${NC} 🏗️  Buat Lokasi dan Node baru"
    echo -e "${CYAN}2.${NC} 🖥️  Buat Node saja (gunakan lokasi yang ada)"
    echo -e "${CYAN}3.${NC} 📍 Buat Lokasi saja"
    echo -e "${CYAN}4.${NC} 📋 Lihat lokasi yang ada"
    echo -e "${CYAN}5.${NC} ❌ Keluar"
    echo ""
    
    while true; do
        echo -e "${YELLOW}Masukkan pilihan (1-5):${NC}"
        read -r operation_mode
        
        case $operation_mode in
            1|2|3|4|5)
                break
                ;;
            *)
                print_error "Pilihan tidak valid! Masukkan angka 1-5."
                ;;
        esac
    done
}

create_location() {
    local location_name=$1
    local location_description=$2
    
    print_status "📍 Membuat lokasi: $location_name..."
    
    cd /var/www/pterodactyl || {
        print_error "Direktori Pterodactyl tidak ditemukan!"
        return 1
    }
    
    if php artisan p:location:make --no-interaction <<EOF
$location_name
$location_description
EOF
    then
        print_status "✅ Lokasi '$location_name' berhasil dibuat!"
        return 0
    else
        print_error "❌ Gagal membuat lokasi '$location_name'!"
        return 1
    fi
}

create_node() {
    local node_name=$1
    local location_id=$2
    local domain=$3
    local ram=$4
    local disk_space=$5
    local daemon_port=${6:-8080}
    local daemon_sftp_port=${7:-2022}
    local daemon_base=${8:-/var/lib/pterodactyl/volumes}
    
    print_status "🖥️  Membuat node: $node_name..."
    
    cd /var/www/pterodactyl || {
        print_error "Direktori Pterodactyl tidak ditemukan!"
        return 1
    }
    
    if php artisan p:node:make --no-interaction <<EOF
$node_name
Node $node_name - Auto created
$location_id
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
$daemon_port
$daemon_sftp_port
$daemon_base
EOF
    then
        print_status "✅ Node '$node_name' berhasil dibuat!"
        return 0
    else
        print_error "❌ Gagal membuat node '$node_name'!"
        return 1
    fi
}

input_location_data() {
    while true; do
        echo -e "${CYAN}📍 Masukkan nama singkat lokasi (contoh: jakarta, singapore):${NC}"
        read -r location_name
        
        if [ -z "$location_name" ]; then
            print_error "Nama lokasi tidak boleh kosong!"
            continue
        fi
        
        if [[ ! $location_name =~ ^[a-zA-Z0-9_-]+$ ]]; then
            print_error "Nama lokasi hanya boleh mengandung huruf, angka, underscore, dan dash!"
            continue
        fi
        
        if check_location_exists "$location_name"; then
            print_error "Lokasi '$location_name' sudah ada!"
            continue
        fi
        
        break
    done
    
    while true; do
        echo -e "${CYAN}📝 Masukkan deskripsi lokasi:${NC}"
        read -r location_description
        
        if [ -z "$location_description" ]; then
            print_error "Deskripsi lokasi tidak boleh kosong!"
            continue
        fi
        
        break
    done
}

input_node_data() {
    while true; do
        echo -e "${CYAN}🖥️  Masukkan nama node:${NC}"
        read -r node_name
        
        if [ -z "$node_name" ]; then
            print_error "Nama node tidak boleh kosong!"
            continue
        fi
        
        break
    done
    
    while true; do
        echo -e "${CYAN}🌐 Masukkan domain atau IP node (contoh: node1.domain.com):${NC}"
        read -r domain
        
        if [ -z "$domain" ]; then
            print_error "Domain/IP tidak boleh kosong!"
            continue
        fi
        
        if ! validate_domain "$domain"; then
            if [[ ! $domain =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                print_error "Format domain/IP tidak valid!"
                continue
            fi
        fi
        
        break
    done
    
    while true; do
        echo -e "${CYAN}💾 Masukkan total RAM dalam MB (contoh: 4096):${NC}"
        read -r ram
        
        if ! validate_number "$ram"; then
            print_error "RAM harus berupa angka positif!"
            continue
        fi
        
        if [ "$ram" -lt 512 ]; then
            print_warning "RAM terlalu kecil! Minimal 512MB."
            continue
        fi
        
        break
    done
    
    while true; do
        echo -e "${CYAN}💿 Masukkan total disk space dalam MB (contoh: 20480):${NC}"
        read -r disk_space
        
        if ! validate_number "$disk_space"; then
            print_error "Disk space harus berupa angka positif!"
            continue
        fi
        
        if [ "$disk_space" -lt 1024 ]; then
            print_warning "Disk space terlalu kecil! Minimal 1024MB."
            continue
        fi
        
        break
    done
    
    echo -e "${YELLOW}🔧 Konfigurasi lanjutan (tekan Enter untuk default):${NC}"
    
    while true; do
        echo -e "${CYAN}🔌 Port daemon (default: 8080):${NC}"
        read -r daemon_port
        
        if [ -z "$daemon_port" ]; then
            daemon_port=8080
            break
        fi
        
        if ! validate_port "$daemon_port"; then
            print_error "Port tidak valid! Gunakan port 1-65535."
            continue
        fi
        
        break
    done
    
    while true; do
        echo -e "${CYAN}📁 Port SFTP (default: 2022):${NC}"
        read -r daemon_sftp_port
        
        if [ -z "$daemon_sftp_port" ]; then
            daemon_sftp_port=2022
            break
        fi
        
        if ! validate_port "$daemon_sftp_port"; then
            print_error "Port tidak valid! Gunakan port 1-65535."
            continue
        fi
        
        break
    done
    
    echo -e "${CYAN}📂 Direktori base daemon (default: /var/lib/pterodactyl/volumes):${NC}"
    read -r daemon_base
    
    if [ -z "$daemon_base" ]; then
        daemon_base="/var/lib/pterodactyl/volumes"
    fi
}

select_existing_location() {
    print_status "📍 Mengambil daftar lokasi yang tersedia..."
    
    cd /var/www/pterodactyl
    
    temp_file=$(mktemp)
    php artisan tinker --execute "
        \$locations = \App\Models\Location::all();
        foreach(\$locations as \$location) {
            echo \$location->id . '|' . \$location->short . '|' . \$location->long . PHP_EOL;
        }
    " 2>/dev/null > "$temp_file"
    
    if [ ! -s "$temp_file" ]; then
        print_error "Tidak ada lokasi yang tersedia!"
        print_status "Silakan buat lokasi terlebih dahulu."
        rm -f "$temp_file"
        return 1
    fi
    
    echo -e "${YELLOW}📍 Lokasi yang tersedia:${NC}"
    echo ""
    
    local counter=1
    declare -A location_map
    
    while IFS='|' read -r id short long; do
        if [ -n "$id" ] && [ -n "$short" ] && [ -n "$long" ]; then
            echo -e "${CYAN}$counter.${NC} ID: $id | $short - $long"
            location_map[$counter]=$id
            ((counter++))
        fi
    done < "$temp_file"
    
    echo ""
    
    while true; do
        echo -e "${YELLOW}Pilih nomor lokasi:${NC}"
        read -r location_choice
        
        if [[ -n ${location_map[$location_choice]} ]]; then
            selected_location_id=${location_map[$location_choice]}
            break
        else
            print_error "Pilihan tidak valid!"
        fi
    done
    
    rm -f "$temp_file"
}

confirm_data() {
    echo ""
    print_header "                    KONFIRMASI DATA                    "
    
    case $operation_mode in
        1)
            echo -e "${CYAN}📍 Lokasi:${NC}"
            echo -e "   Nama: $location_name"
            echo -e "   Deskripsi: $location_description"
            echo ""
            echo -e "${CYAN}🖥️  Node:${NC}"
            echo -e "   Nama: $node_name"
            echo -e "   Domain: $domain"
            echo -e "   RAM: ${ram}MB"
            echo -e "   Disk: ${disk_space}MB"
            echo -e "   Port Daemon: $daemon_port"
            echo -e "   Port SFTP: $daemon_sftp_port"
            echo -e "   Base Directory: $daemon_base"
            ;;
        2)
            echo -e "${CYAN}🖥️  Node:${NC}"
            echo -e "   Nama: $node_name"
            echo -e "   Domain: $domain"
            echo -e "   RAM: ${ram}MB"
            echo -e "   Disk: ${disk_space}MB"
            echo -e "   Port Daemon: $daemon_port"
            echo -e "   Port SFTP: $daemon_sftp_port"
            echo -e "   Base Directory: $daemon_base"
            echo -e "   Location ID: $selected_location_id"
            ;;
        3)
            echo -e "${CYAN}📍 Lokasi:${NC}"
            echo -e "   Nama: $location_name"
            echo -e "   Deskripsi: $location_description"
            ;;
    esac
    
    echo ""
    echo -e "${YELLOW}❓ Apakah data sudah benar? (y/n):${NC}"
    read -r confirm
    
    if [[ $confirm != "y" && $confirm != "Y" ]]; then
        print_status "Operasi dibatalkan."
        return 1
    fi
    
    return 0
}

display_results() {
    echo ""
    print_header "                    HASIL OPERASI                    "
    
    case $operation_mode in
        1)
            if [ $location_created -eq 0 ] && [ $node_created -eq 0 ]; then
                print_status "✅ Lokasi dan Node berhasil dibuat!"
                echo ""
                echo -e "${GREEN}📋 Informasi lengkap:${NC}"
                echo -e "${CYAN}📍 Lokasi: $location_name - $location_description${NC}"
                echo -e "${CYAN}🖥️  Node: $node_name${NC}"
                echo -e "${CYAN}🌐 Domain: $domain${NC}"
                echo -e "${CYAN}💾 RAM: ${ram}MB${NC}"
                echo -e "${CYAN}💿 Disk: ${disk_space}MB${NC}"
                
                print_status "🔧 Langkah selanjutnya:"
                echo -e "${YELLOW}1. Login ke panel admin${NC}"
                echo -e "${YELLOW}2. Pergi ke Admin -> Nodes${NC}"
                echo -e "${YELLOW}3. Klik node '$node_name'${NC}"
                echo -e "${YELLOW}4. Copy konfigurasi dan jalankan di server node${NC}"
                echo -e "${YELLOW}5. Install Wings di server node${NC}"
            else
                print_error "❌ Ada kesalahan dalam proses pembuatan!"
            fi
            ;;
        2)
            if [ $node_created -eq 0 ]; then
                print_status "✅ Node berhasil dibuat!"
                echo ""
                echo -e "${GREEN}📋 Informasi Node:${NC}"
                echo -e "${CYAN}🖥️  Node: $node_name${NC}"
                echo -e "${CYAN}🌐 Domain: $domain${NC}"
                echo -e "${CYAN}💾 RAM: ${ram}MB${NC}"
                echo -e "${CYAN}💿 Disk: ${disk_space}MB${NC}"
            else
                print_error "❌ Gagal membuat node!"
            fi
            ;;
        3)
            if [ $location_created -eq 0 ]; then
                print_status "✅ Lokasi berhasil dibuat!"
                echo ""
                echo -e "${GREEN}📋 Informasi Lokasi:${NC}"
                echo -e "${CYAN}📍 Nama: $location_name${NC}"
                echo -e "${CYAN}📝 Deskripsi: $location_description${NC}"
            else
                print_error "❌ Gagal membuat lokasi!"
            fi
            ;;
    esac
    
    echo ""
}

main() {
    touch "$LOG_FILE"
    log_message "Node creator script started"
    
    if [[ $EUID -ne 0 ]]; then
        print_error "Script ini harus dijalankan sebagai root!"
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
            print_header "              BUAT LOKASI DAN NODE BARU              "
            input_location_data
            input_node_data
            
            if confirm_data; then
                create_location "$location_name" "$location_description"
                location_created=$?
                
                if [ $location_created -eq 0 ]; then
                    cd /var/www/pterodactyl
                    location_id=$(php artisan tinker --execute "echo \App\Models\Location::where('short', '$location_name')->first()->id;" 2>/dev/null | tail -1)
                    
                    create_node "$node_name" "$location_id" "$domain" "$ram" "$disk_space" "$daemon_port" "$daemon_sftp_port" "$daemon_base"
                    node_created=$?
                else
                    node_created=1
                fi
                
                display_results
            fi
            ;;
        2)
            print_header "                BUAT NODE BARU                "
            
            if ! select_existing_location; then
                exit 1
            fi
            
            input_node_data
            
            if confirm_data; then
                create_node "$node_name" "$selected_location_id" "$domain" "$ram" "$disk_space" "$daemon_port" "$daemon_sftp_port" "$daemon_base"
                node_created=$?
                
                display_results
            fi
            ;;
        3)
            print_header "               BUAT LOKASI BARU               "
            input_location_data
            
            if confirm_data; then
                create_location "$location_name" "$location_description"
                location_created=$?
                
                display_results
            fi
            ;;
        4)
            print_header "               LOKASI YANG TERSEDIA               "
            list_existing_locations
            ;;
        5)
            # Exit
            print_status "👋 Terima kasih telah menggunakan Liwirya Node Creator!"
            exit 0
            ;;
    esac
    
    log_message "Node creator script completed"
}

main "$@"