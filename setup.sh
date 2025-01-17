#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Utility functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    log_error "This script must be run as root"
    exit 1
fi

# Function to check system requirements
check_system_requirements() {
    log_info "Checking system requirements..."
    
    # Check CPU cores
    CPU_CORES=$(nproc)
    if [ "$CPU_CORES" -lt 4 ]; then
        log_warn "Minimum 4 CPU cores recommended (found: $CPU_CORES)"
    fi
    
    # Check RAM
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$TOTAL_RAM" -lt 8 ]; then
        log_warn "Minimum 8GB RAM recommended (found: ${TOTAL_RAM}GB)"
    fi
    
    # Check disk space
    FREE_SPACE=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$FREE_SPACE" -lt 50 ]; then
        log_warn "Minimum 50GB free space recommended (found: ${FREE_SPACE}GB)"
    fi
}

# Function to update system
update_system() {
    log_info "Updating system packages..."
    apt update && apt upgrade -y
}

# Function to install dependencies
install_dependencies() {
    log_info "Installing required packages..."
    
    # Install basic tools
    apt install -y curl wget git gnupg2 ca-certificates \
                   lsb-release apt-transport-https dialog \
                   ufw fail2ban

    # Install Docker
    log_info "Installing Docker..."
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Install Node.js
    log_info "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs

    # Install global npm packages
    log_info "Installing global npm packages..."
    npm install -g vite
}

# Function to configure firewall
configure_firewall() {
    log_info "Configuring firewall..."
    
    # Configure UFW
    ufw default deny incoming
    ufw default allow outgoing
    
    # Allow SSH
    ufw allow ssh
    
    # Allow HTTP/HTTPS
    ufw allow http
    ufw allow https
    
    # Allow specific ports for services
    ufw allow 3000 # Main application
    ufw allow 8080 # Nextcloud
    ufw allow 3478 # Jitsi Meet
    
    # Enable firewall
    ufw --force enable
}

# Function to setup application
setup_application() {
    log_info "Setting up application..."
    
    # Create application directory
    mkdir -p /opt/innovation
    cd /opt/innovation
    
    # Clone repository
    git clone https://github.com/atreyu1968/ir-final-7 .
    
    # Create required directories
    mkdir -p secrets uploads logs backups \
            docker/{mariadb,phpmyadmin}/{conf.d,init} \
            docker/{rocketchat,discourse,nextcloud}
    
    # Set permissions
    chown -R 1000:1000 uploads logs backups
    chmod -R 755 docker uploads logs backups
}

# Function to start services
start_services() {
    log_info "Starting services..."
    
    cd /opt/innovation
    docker compose up -d
    
    # Wait for services to be ready
    sleep 30
    
    # Check service status
    docker compose ps
}

# Main installation function
main() {
    log_info "Starting installation..."
    
    check_system_requirements
    update_system
    install_dependencies
    configure_firewall
    setup_application
    start_services
    
    log_info "Installation completed successfully!"
}

# Run main function
main