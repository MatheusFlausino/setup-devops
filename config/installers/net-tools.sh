#!/bin/bash

# net-tools Installer Script
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

# Função para verificar se net-tools está instalado
is_net_tools_installed() {
    command -v netstat &> /dev/null || command -v ifconfig &> /dev/null || command -v route &> /dev/null
}

# Função para instalar net-tools no Ubuntu
install_net_tools_ubuntu() {
    log "Instalando net-tools no Ubuntu..."

    sudo apt-get update
    sudo apt-get install -y net-tools

    log "net-tools instalado com sucesso no Ubuntu!"
}

# Função para instalar net-tools no CentOS/RHEL
install_net_tools_centos() {
    log "Instalando net-tools no CentOS/RHEL..."

    sudo yum install -y net-tools

    log "net-tools instalado com sucesso no CentOS/RHEL!"
}

# Função para instalar net-tools no macOS
install_net_tools_macos() {
    log "Instalando net-tools no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar net-tools via Homebrew
    brew install net-tools

    log "net-tools instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_net_tools_installed; then
        log "Verificação: net-tools instalado com sucesso!"

        # Verificar comandos disponíveis
        if command -v netstat &> /dev/null; then
            info "netstat disponível"
        fi
        if command -v ifconfig &> /dev/null; then
            info "ifconfig disponível"
        fi
        if command -v route &> /dev/null; then
            info "route disponível"
        fi

        return 0
    else
        error "Falha na instalação do net-tools"
        return 1
    fi
}

# Função para instalação standalone do net-tools
install_net_tools_standalone() {
    local os=$1

    # Verificar se net-tools já está instalado
    if is_net_tools_installed; then
        warning "net-tools já está instalado"
        verify_installation
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu")
            install_net_tools_ubuntu
            ;;
        "centos")
            install_net_tools_centos
            ;;
        "macos")
            install_net_tools_macos
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

    install_net_tools_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
