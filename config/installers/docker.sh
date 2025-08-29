#!/bin/bash

# Docker Installer Script
# Suporte: Ubuntu, CentOS/RHEL, macOS

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Função para verificar se Docker está instalado
is_docker_installed() {
    command -v docker &> /dev/null
}

# Função para instalar Docker no Ubuntu
install_docker_ubuntu() {
    log "Instalando Docker no Ubuntu..."

    # Atualizar repositórios
    sudo apt-get update

    # Instalar dependências
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

    # Adicionar chave GPG oficial do Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Adicionar repositório do Docker
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Atualizar repositórios novamente
    sudo apt-get update

    # Instalar Docker CE
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Adicionar usuário ao grupo docker
    sudo usermod -aG docker $USER

    # Iniciar e habilitar serviço Docker
    sudo systemctl start docker
    sudo systemctl enable docker

    log "Docker instalado com sucesso no Ubuntu!"
    warning "IMPORTANTE: Faça logout e login novamente para que as permissões do grupo docker sejam aplicadas, ou execute: newgrp docker"
}

# Função para instalar Docker no CentOS/RHEL
install_docker_centos() {
    log "Instalando Docker no CentOS/RHEL..."

    # Instalar yum-utils
    sudo yum install -y yum-utils

    # Adicionar repositório do Docker
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # Instalar Docker CE
    sudo yum install -y docker-ce docker-ce-cli containerd.io

    # Iniciar e habilitar serviço Docker
    sudo systemctl start docker
    sudo systemctl enable docker

    # Adicionar usuário ao grupo docker
    sudo usermod -aG docker $USER

    log "Docker instalado com sucesso no CentOS/RHEL!"
    warning "IMPORTANTE: Faça logout e login novamente para que as permissões do grupo docker sejam aplicadas, ou execute: newgrp docker"
}

# Função para instalar Docker no macOS
install_docker_macos() {
    log "Instalando Docker no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar Docker Desktop via Homebrew Cask
    brew install --cask docker

    log "Docker Desktop instalado com sucesso no macOS!"
    info "Inicie o Docker Desktop manualmente ou execute: open /Applications/Docker.app"
}

# Função para instalação standalone do Docker
install_docker_standalone() {
    local os=$1

    # Verificar se Docker já está instalado
    if is_docker_installed; then
        warning "Docker já está instalado"
        docker --version
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu")
            install_docker_ubuntu
            ;;
        "centos")
            install_docker_centos
            ;;
        "macos")
            install_docker_macos
            ;;
        *)
            error "Sistema operacional não suportado: $os"
            return 1
            ;;
    esac

    # Verificar instalação
    if is_docker_installed; then
        log "Verificação: Docker instalado com sucesso!"
        docker --version
    else
        error "Falha na instalação do Docker"
        return 1
    fi
}

# Função principal (para uso independente)
main() {
    local os=$1

    if [[ -z "$os" ]]; then
        error "Uso: $0 <sistema_operacional>"
        echo "Sistemas suportados: ubuntu, centos, macos"
        exit 1
    fi

    install_docker_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ -z "$1" ]]; then
        error "Uso: $0 <sistema_operacional>"
        echo "Sistemas suportados: ubuntu, centos, macos"
        exit 1
    fi
    main "$1"
fi
