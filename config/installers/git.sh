#!/bin/bash

# Git Installer Script
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

# Função para verificar se Git está instalado
is_git_installed() {
    command -v git &> /dev/null
}

# Função para instalar Git no Ubuntu
install_git_ubuntu() {
    log "Instalando Git no Ubuntu..."

    sudo apt-get update
    sudo apt-get install -y git

    log "Git instalado com sucesso no Ubuntu!"
}

# Função para instalar Git no CentOS/RHEL
install_git_centos() {
    log "Instalando Git no CentOS/RHEL..."

    sudo yum install -y git

    log "Git instalado com sucesso no CentOS/RHEL!"
}

# Função para instalar Git no macOS
install_git_macos() {
    log "Instalando Git no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar Git via Homebrew
    brew install git

    log "Git instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_git_installed; then
        log "Verificação: Git instalado com sucesso!"
        git --version
        return 0
    else
        error "Falha na instalação do Git"
        return 1
    fi
}

# Função para instalação standalone do Git
install_git_standalone() {
    local os=$1

    # Verificar se Git já está instalado
    if is_git_installed; then
        warning "Git já está instalado"
        git --version
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu")
            install_git_ubuntu
            ;;
        "centos")
            install_git_centos
            ;;
        "macos")
            install_git_macos
            ;;
        *)
            error "Sistema operacional não suportado: $os"
            return 1
            ;;
    esac

    # Verificar instalação
    verify_installation
}

# Função principal (para uso independente)
main() {
    local os=$1

    if [[ -z "$os" ]]; then
        error "Uso: $0 <sistema_operacional>"
        echo "Sistemas suportados: ubuntu, centos, macos"
        exit 1
    fi

    install_git_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
