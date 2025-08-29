#!/bin/bash

# AWS CLI Installer Script
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

# Função para verificar se AWS CLI está instalado
is_aws_cli_installed() {
    command -v aws &> /dev/null
}

# Função para instalar AWS CLI no Linux
install_aws_cli_linux() {
    log "Instalando AWS CLI v2 no Linux..."

    # Determinar arquitetura
    local arch="x86_64"
    if [[ $(uname -m) == "aarch64" ]]; then
        arch="aarch64"
    fi

    # Criar diretório temporário
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Download do AWS CLI v2
    local download_url="https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip"
    log "Download de: $download_url"

    if ! curl -fsSL "$download_url" -o awscliv2.zip; then
        error "Falha no download do AWS CLI"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi

    # Verificar se unzip está instalado
    if ! command -v unzip &> /dev/null; then
        log "Instalando unzip..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y unzip
        elif command -v yum &> /dev/null || command -v dnf &> /dev/null; then
            sudo yum install -y unzip
        fi
    fi

    # Extrair e instalar
    unzip -o awscliv2.zip
    sudo ./aws/install

    # Limpar arquivos temporários
    cd - > /dev/null
    rm -rf "$temp_dir"

    log "AWS CLI v2 instalado com sucesso no Linux!"
}

# Função para instalar AWS CLI no macOS
install_aws_cli_macos() {
    log "Instalando AWS CLI no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar AWS CLI via Homebrew
    brew install awscli

    log "AWS CLI instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_aws_cli_installed; then
        log "Verificação: AWS CLI instalado com sucesso!"
        aws --version
        return 0
    else
        error "Falha na instalação do AWS CLI"
        return 1
    fi
}

# Função para instalação standalone do AWS CLI
install_aws_cli_standalone() {
    local os=$1

    # Verificar se AWS CLI já está instalado
    if is_aws_cli_installed; then
        warning "AWS CLI já está instalado"
        aws --version
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu"|"centos")
            install_aws_cli_linux
            ;;
        "macos")
            install_aws_cli_macos
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

    install_aws_cli_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
