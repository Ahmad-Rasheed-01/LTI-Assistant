#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to update system
update_system() {
    echo -e "${YELLOW}Updating system packages...${NC}"
    sudo apt update && sudo apt upgrade -y
    echo -e "${GREEN}System updated successfully.${NC}"
}

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}Installing dependencies...${NC}"
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    echo -e "${GREEN}Dependencies installed successfully.${NC}"
}

# Function to add Docker GPG key
add_gpg_key() {
    echo -e "${YELLOW}Adding Docker GPG key...${NC}"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo -e "${GREEN}GPG key added successfully.${NC}"
}

# Function to add Docker repository
add_docker_repo() {
    echo -e "${YELLOW}Adding Docker repository...${NC}"
    echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    echo -e "${GREEN}Docker repository added successfully.${NC}"
}

# Function to install Docker
install_docker() {
    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo -e "${GREEN}Docker installed successfully.${NC}"
}

# Function to add user to Docker group
add_user_to_docker_group() {
    read -p "Do you want to add your user to the Docker group? (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Adding user to Docker group...${NC}"
        sudo usermod -aG docker $USER
        echo -e "${GREEN}User added to Docker group successfully.${NC}"
    else
        echo -e "${RED}User was not added to Docker group.${NC}"
    fi
}

# Function to check Docker installation
test_docker() {
    echo -e "${YELLOW}Checking Docker version...${NC}"
    docker --version
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Docker is installed successfully.${NC}"
    else
        echo -e "${RED}Docker installation failed. Please check logs.${NC}"
    fi
}

# Function to restart WSL
restart_wsl() {
    echo -e "${YELLOW}Restarting WSL...${NC}"
    wsl --shutdown
    echo -e "${GREEN}WSL restarted. Please open Ubuntu again.${NC}"
}

# Function to install Rust
install_rust() {
    echo -e "${YELLOW}Installing Rust...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    echo -e "${GREEN}Rust installed successfully.${NC}"
}

# Function to start Docker service
start_docker() {
    echo -e "${YELLOW}Starting Docker service...${NC}"
    sudo service docker start
    echo -e "${GREEN}Docker service started.${NC}"
}

# Function to stop Docker service
stop_docker() {
    echo -e "${YELLOW}Stopping Docker service...${NC}"
    sudo service docker stop
    echo -e "${GREEN}Docker service stopped.${NC}"
}

# Menu function
display_menu() {
    while true; do
        echo -e "\n${YELLOW}Docker Installation Menu:${NC}"
        echo "1) Update System"
        echo "2) Install Dependencies"
        echo "3) Add Docker GPG Key"
        echo "4) Add Docker Repository"
        echo "5) Install Docker"
        echo "6) Add User to Docker Group"
        echo "7) Check Docker Installation"
        echo "8) Restart WSL"
        echo "9) Install Rust"
        echo "10) Start Docker Service"
        echo "11) Stop Docker Service"
        echo "12) Install All (Recommended)"
        echo "13) Exit"
        read -p "Select an option: " choice

        case $choice in
            1) update_system ;;
            2) install_dependencies ;;
            3) add_gpg_key ;;
            4) add_docker_repo ;;
            5) install_docker ;;
            6) add_user_to_docker_group ;;
            7) test_docker ;;
            8) restart_wsl ;;
            9) install_rust ;;
            10) start_docker ;;
            11) stop_docker ;;
            12) update_system && install_dependencies && add_gpg_key && add_docker_repo && install_docker && add_user_to_docker_group && restart_wsl && test_docker && install_rust ;;
            13) echo -e "${GREEN}Exiting...${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
        esac
    done
}

# Run the menu
display_menu
