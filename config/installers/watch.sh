#!/bin/bash

# watch Installer Script
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

# Função para verificar se watch está instalado
is_watch_installed() {
    command -v watch &> /dev/null
}

# Função para instalar watch no Ubuntu
install_watch_ubuntu() {
    log "Instalando watch no Ubuntu..."

    sudo apt-get update
    sudo apt-get install -y procps

    log "watch instalado com sucesso no Ubuntu!"
}

# Função para instalar watch no CentOS/RHEL
install_watch_centos() {
    log "Instalando watch no CentOS/RHEL..."

    sudo yum install -y procps-ng

    log "watch instalado com sucesso no CentOS/RHEL!"
}

# Função para instalar watch no macOS
install_watch_macos() {
    log "Instalando watch no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar watch via Homebrew
    brew install watch

    log "watch instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_watch_installed; then
        log "Verificação: watch instalado com sucesso!"
        watch --version
        return 0
    else
        error "Falha na instalação do watch"
        return 1
    fi
}

# Função para instalação standalone do watch
install_watch_standalone() {
    local os=$1

    # Verificar se watch já está instalado
    if is_watch_installed; then
        warning "watch já está instalado"
        watch --version
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu")
            install_watch_ubuntu
            ;;
        "centos")
            install_watch_centos
            ;;
        "macos")
            install_watch_macos
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

    install_watch_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
