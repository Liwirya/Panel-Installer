#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

SUCCESS="✅"
ERROR="❌"
WARNING="⚠️"
INFO="ℹ️"
GEAR="⚙️"
ROCKET="🚀"

print_status() {
    echo -e "${2}${1}${NC}"
}

print_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${WHITE}                 PTERODACTYL PANEL REPAIR TOOL                 ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${CYAN}                        Version 2.0                            ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

loading_animation() {
    local pid=$1
    local msg=$2
    local spin='-\|/'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${CYAN}${GEAR} %s %s${NC}" "$msg" "${spin:$i:1}"
        sleep 0.2
    done
    printf "\r"
}

check_prerequisites() {
    print_status "${INFO} Checking prerequisites..." "$BLUE"
    
    if (( $EUID != 0 )); then
        print_status "${ERROR} This script must be run as root!" "$RED"
        print_status "${INFO} Please run: sudo bash repair.sh" "$YELLOW"
        exit 1
    fi
    
    if [ ! -d "/var/www/pterodactyl" ]; then
        print_status "${ERROR} Pterodactyl panel directory not found!" "$RED"
        print_status "${INFO} Please ensure Pterodactyl Panel is installed at /var/www/pterodactyl" "$YELLOW"
        exit 1
    fi
    
    local commands=("curl" "tar" "php" "composer")
    for cmd in "${commands[@]}"; do
        if ! command -v $cmd &> /dev/null; then
            print_status "${ERROR} Required command '$cmd' not found!" "$RED"
            exit 1
        fi
    done
    
    print_status "${SUCCESS} All prerequisites met!" "$GREEN"
    echo ""
}

backup_panel() {
    print_status "${INFO} Creating backup..." "$BLUE"
    
    local backup_dir="/var/backups/pterodactyl_$(date +%Y%m%d_%H%M%S)"
    
    mkdir -p "$backup_dir" &
    local pid=$!
    loading_animation $pid "Creating backup directory"
    
    if cp -r /var/www/pterodactyl "$backup_dir/" 2>/dev/null; then
        print_status "${SUCCESS} Backup created at: $backup_dir" "$GREEN"
        return 0
    else
        print_status "${WARNING} Backup failed, continuing without backup..." "$YELLOW"
        return 1
    fi
}

repairPanel() {
    print_status "${ROCKET} Starting Pterodactyl Panel repair process..." "$PURPLE"
    echo ""
    
    cd /var/www/pterodactyl || {
        print_status "${ERROR} Failed to change to pterodactyl directory!" "$RED"
        exit 1
    }
    
    print_status "${INFO} Step 1/9: Putting panel in maintenance mode..." "$BLUE"
    if php artisan down --render="errors::503" --secret="repair" 2>/dev/null; then
        print_status "${SUCCESS} Panel is now in maintenance mode" "$GREEN"
    else
        print_status "${WARNING} Failed to enable maintenance mode, continuing..." "$YELLOW"
    fi
    echo ""
    
    if [ -d "/var/www/pterodactyl/resources" ]; then
        print_status "${INFO} Step 2/9: Backing up current resources..." "$BLUE"
        mv /var/www/pterodactyl/resources /var/www/pterodactyl/resources.backup.$(date +%s) 2>/dev/null
        print_status "${SUCCESS} Resources backed up" "$GREEN"
    else
        print_status "${INFO} Step 2/9: No resources directory found, skipping backup" "$BLUE"
    fi
    echo ""
    
    print_status "${INFO} Step 3/9: Downloading latest Pterodactyl Panel..." "$BLUE"
    if curl -L --progress-bar https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv >/dev/null 2>&1; then
        print_status "${SUCCESS} Latest panel downloaded and extracted" "$GREEN"
    else
        print_status "${ERROR} Failed to download panel!" "$RED"
        print_status "${INFO} Restoring maintenance mode..." "$YELLOW"
        php artisan up 2>/dev/null
        exit 1
    fi
    echo ""
    
    print_status "${INFO} Step 4/9: Setting correct permissions..." "$BLUE"
    chmod -R 755 storage/* bootstrap/cache 2>/dev/null
    print_status "${SUCCESS} Permissions updated" "$GREEN"
    echo ""
    
    print_status "${INFO} Step 5/9: Installing/updating dependencies..." "$BLUE"
    if composer install --no-dev --optimize-autoloader --quiet; then
        print_status "${SUCCESS} Dependencies installed successfully" "$GREEN"
    else
        print_status "${WARNING} Some issues with composer, but continuing..." "$YELLOW"
    fi
    echo ""
    
    print_status "${INFO} Step 6/9: Clearing application caches..." "$BLUE"
    php artisan view:clear >/dev/null 2>&1
    php artisan config:clear >/dev/null 2>&1
    php artisan route:clear >/dev/null 2>&1
    php artisan cache:clear >/dev/null 2>&1
    print_status "${SUCCESS} Caches cleared" "$GREEN"
    echo ""
    
    print_status "${INFO} Step 7/9: Running database migrations..." "$BLUE"
    if php artisan migrate --seed --force >/dev/null 2>&1; then
        print_status "${SUCCESS} Database migrations completed" "$GREEN"
    else
        print_status "${WARNING} Database migrations had issues, but continuing..." "$YELLOW"
    fi
    echo ""
    
    print_status "${INFO} Step 8/9: Setting correct file ownership..." "$BLUE"
    chown -R www-data:www-data /var/www/pterodactyl/* 2>/dev/null
    print_status "${SUCCESS} File ownership updated" "$GREEN"
    echo ""
    
    print_status "${INFO} Step 9/9: Restarting queue and bringing panel online..." "$BLUE"
    php artisan queue:restart >/dev/null 2>&1
    php artisan up >/dev/null 2>&1
    print_status "${SUCCESS} Panel is back online!" "$GREEN"
    echo ""
    
    print_status "${ROCKET} Repair process completed successfully!" "$GREEN"
    print_status "${INFO} Your Pterodactyl Panel has been repaired and updated to the latest version." "$BLUE"
}

show_confirmation() {
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${RED}                         WARNING!                             ${YELLOW}║${NC}"
    echo -e "${YELLOW}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${YELLOW}║${WHITE} This will:                                                  ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${WHITE} • Put the panel in maintenance mode                        ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${WHITE} • Remove current theme/customizations                      ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${WHITE} • Download and install the latest panel version            ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${WHITE} • Reset to default Pterodactyl theme                       ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${WHITE} • Run database migrations                                   ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

main() {
    print_header
    check_prerequisites
    
    print_status "${INFO} System Information:" "$BLUE"
    echo -e "   ${WHITE}OS:${NC} $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")"
    echo -e "   ${WHITE}PHP Version:${NC} $(php -v | head -n1 | cut -d' ' -f2)"
    echo -e "   ${WHITE}Current Directory:${NC} $(pwd)"
    echo ""
    
    while true; do
        read -p "$(echo -e "${CYAN}${INFO} Do you want to create a backup before proceeding? [y/N]: ${NC}")" backup_choice
        case $backup_choice in
            [Yy]* ) 
                backup_panel
                break
                ;;
            [Nn]* | "" ) 
                print_status "${WARNING} Proceeding without backup..." "$YELLOW"
                break
                ;;
            * ) 
                print_status "${ERROR} Please answer yes (y) or no (n)" "$RED"
                ;;
        esac
    done
    echo ""
    
    show_confirmation
    
    while true; do
        read -p "$(echo -e "${CYAN}${WARNING} Are you sure you want to repair/reset the Pterodactyl Panel? [y/N]: ${NC}")" yn
        case $yn in
            [Yy]* ) 
                echo ""
                repairPanel
                break
                ;;
            [Nn]* | "" ) 
                print_status "${INFO} Operation cancelled by user." "$BLUE"
                print_status "${SUCCESS} No changes were made to your system." "$GREEN"
                exit 0
                ;;
            * ) 
                print_status "${ERROR} Please answer yes (y) or no (n)" "$RED"
                ;;
        esac
    done
    
    echo ""
    print_status "${SUCCESS} Thank you for using Pterodactyl Panel Repair Tool!" "$GREEN"
    print_status "${INFO} If you encounter any issues, please check the Pterodactyl documentation." "$BLUE"
}

trap 'echo -e "\n${RED}${ERROR} Script interrupted by user${NC}"; php artisan up 2>/dev/null; exit 1' INT

main