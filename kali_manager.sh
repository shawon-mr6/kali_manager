#!/bin/bash

# ==========================================================
# Kali Linux System Management Menu (Improved)
# ==========================================================

# ---------- Colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Root check
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Please run this script as root:${NC}"
    echo "  sudo $0"
    exit 1
fi

info()    { echo -e "${CYAN}[+] $*${NC}"; }
success() { echo -e "${GREEN}[✓] $*${NC}"; }
warn()    { echo -e "${YELLOW}[!] $*${NC}"; }
error()   { echo -e "${RED}[-] $*${NC}"; }

pause() {
    echo
    read -rp "Press Enter to continue..."
}

run_or_warn() {
    # Runs a command; prints a clear success/failure message
    if "$@"; then
        return 0
    else
        error "Command failed: $*"
        return 1
    fi
}

show_menu() {
    clear
    echo -e "${BOLD}${CYAN}=================================================="
    echo "          KALI LINUX MANAGEMENT MENU"
    echo -e "==================================================${NC}"
    echo
    echo -e "${BOLD}  SYSTEM${NC}"
    echo "  1. Update package list"
    echo "  2. Full system upgrade"
    echo "  3. Update + Full Upgrade"
    echo "  4. Clean packages"
    echo "  5. Autoremove unused packages"
    echo
    echo -e "${BOLD}  SERVICES${NC}"
    echo "  6. Start Apache"
    echo "  7. Stop Apache"
    echo "  8. Restart Apache"
    echo "  9. Apache Status"
    echo " 10. Start PostgreSQL"
    echo " 11. Stop PostgreSQL"
    echo " 12. Restart PostgreSQL"
    echo " 13. PostgreSQL Status"
    echo " 14. Start Metasploit Database"
    echo
    echo -e "${BOLD}  NETWORK / SYSTEM INFO${NC}"
    echo " 15. Show IP Address"
    echo " 16. Show Routing Table"
    echo " 17. Show Public IP"
    echo " 18. Disk Usage"
    echo " 19. Memory Usage"
    echo " 20. CPU Information"
    echo " 21. Running Services"
    echo
    echo -e "${BOLD}  PACKAGES${NC}"
    echo " 22. Search Package"
    echo " 23. Install Package"
    echo " 24. Remove Package"
    echo
    echo -e "${BOLD}  POWER${NC}"
    echo " 25. Reboot System"
    echo " 26. Shutdown System"
    echo
    echo "  0. Exit"
    echo
    echo -e "${BOLD}${CYAN}==================================================${NC}"
}

# Ctrl+C should return to the menu instead of quitting the whole terminal session
trap 'echo; warn "Interrupted. Returning to menu..."; sleep 1' SIGINT

while true; do

    show_menu
    read -rp "Enter your choice: " choice

    case "$choice" in

        1)
            echo
            info "Updating package list..."
            run_or_warn apt update
            pause
            ;;

        2)
            echo
            info "Performing full system upgrade..."
            run_or_warn apt full-upgrade -y
            pause
            ;;

        3)
            echo
            info "Updating package list..."
            run_or_warn apt update

            echo
            info "Performing full upgrade..."
            run_or_warn apt full-upgrade -y
            pause
            ;;

        4)
            echo
            info "Cleaning package cache..."
            run_or_warn apt clean
            run_or_warn apt autoclean
            pause
            ;;

        5)
            echo
            info "Removing unused packages..."
            run_or_warn apt autoremove -y
            pause
            ;;

        6)
            echo
            info "Starting Apache..."
            if run_or_warn systemctl start apache2; then
                success "Apache started."
            fi
            systemctl status apache2 --no-pager
            pause
            ;;

        7)
            echo
            info "Stopping Apache..."
            if run_or_warn systemctl stop apache2; then
                success "Apache stopped."
            fi
            systemctl status apache2 --no-pager
            pause
            ;;

        8)
            echo
            info "Restarting Apache..."
            if run_or_warn systemctl restart apache2; then
                success "Apache restarted."
            fi
            systemctl status apache2 --no-pager
            pause
            ;;

        9)
            echo
            info "Apache Status:"
            systemctl status apache2 --no-pager
            pause
            ;;

        10)
            echo
            info "Starting PostgreSQL..."
            if run_or_warn systemctl start postgresql; then
                success "PostgreSQL started."
            fi
            systemctl status postgresql --no-pager
            pause
            ;;

        11)
            echo
            info "Stopping PostgreSQL..."
            if run_or_warn systemctl stop postgresql; then
                success "PostgreSQL stopped."
            fi
            systemctl status postgresql --no-pager
            pause
            ;;

        12)
            echo
            info "Restarting PostgreSQL..."
            if run_or_warn systemctl restart postgresql; then
                success "PostgreSQL restarted."
            fi
            systemctl status postgresql --no-pager
            pause
            ;;

        13)
            echo
            info "PostgreSQL Status:"
            systemctl status postgresql --no-pager
            pause
            ;;

        14)
            echo
            info "Starting Metasploit Database..."
            # msfdb needs to be initialized once before it can start cleanly
            if ! msfdb status &>/dev/null; then
                warn "Metasploit DB not initialized yet, initializing..."
                msfdb init
            fi
            run_or_warn msfdb start
            pause
            ;;

        15)
            echo
            info "Network Interfaces / IP Addresses:"
            ip -br addr
            pause
            ;;

        16)
            echo
            info "Routing Table:"
            ip route
            pause
            ;;

        17)
            echo
            info "Public IP:"
            # timeout added so this doesn't hang forever with no internet
            public_ip=$(curl -s --max-time 5 https://api.ipify.org)
            if [[ -n "$public_ip" ]]; then
                echo "$public_ip"
            else
                error "Could not reach the internet (timed out)."
            fi
            pause
            ;;

        18)
            echo
            info "Disk Usage:"
            df -h
            pause
            ;;

        19)
            echo
            info "Memory Usage:"
            free -h
            pause
            ;;

        20)
            echo
            info "CPU Information:"
            lscpu
            pause
            ;;

        21)
            echo
            info "Running Services:"
            systemctl list-units --type=service --state=running --no-pager
            pause
            ;;

        22)
            echo
            read -rp "Enter package name to search: " package
            if [[ -n "$package" ]]; then
                echo
                info "Searching for: $package"
                apt search "$package"
            else
                error "Package name cannot be empty."
            fi
            pause
            ;;

        23)
            echo
            read -rp "Enter package name to install: " package

            if [[ -n "$package" ]]; then
                echo
                info "Installing: $package"
                if run_or_warn apt install "$package"; then
                    success "Installed: $package"
                fi
            else
                error "Package name cannot be empty."
            fi

            pause
            ;;

        24)
            echo
            read -rp "Enter package name to remove: " package

            if [[ -n "$package" ]]; then
                echo
                info "Removing: $package"
                if run_or_warn apt remove "$package"; then
                    success "Removed: $package"
                fi
            else
                error "Package name cannot be empty."
            fi

            pause
            ;;

        25)
            echo
            read -rp "Are you sure you want to reboot? (y/N): " confirm

            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                info "Rebooting..."
                reboot
            else
                warn "Reboot cancelled."
                pause
            fi
            ;;

        26)
            echo
            read -rp "Are you sure you want to shutdown? (y/N): " confirm

            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                info "Shutting down..."
                shutdown now
            else
                warn "Shutdown cancelled."
                pause
            fi
            ;;

        0)
            echo
            success "Goodbye!"
            exit 0
            ;;

        *)
            echo
            error "Invalid option. Please choose a number from 0-26."
            pause
            ;;

    esac

done
