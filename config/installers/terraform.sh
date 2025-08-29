#!/bin/bash

# Terraform Installer Script
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

# Função para verificar se Terraform está instalado
is_terraform_installed() {
    command -v terraform &> /dev/null
}

# Função para obter a versão mais recente do Terraform
get_latest_terraform_version() {
    curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Função para instalar Terraform no Linux
install_terraform_linux() {
    log "Instalando Terraform no Linux..."

    # Determinar arquitetura
    local arch="linux_amd64"
    if [[ $(uname -m) == "aarch64" ]]; then
        arch="linux_arm64"
    fi

    # Obter versão mais recente
    local version=$(get_latest_terraform_version)
    log "Baixando Terraform versão: $version"

    # Criar diretório temporário
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Download do Terraform
    local download_url="https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${arch}.zip"
    log "Download de: $download_url"

    if ! curl -fsSL "$download_url" -o terraform.zip; then
        error "Falha no download do Terraform"
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
    unzip -o terraform.zip
    sudo install -o root -g root -m 0755 terraform /usr/local/bin/terraform

    # Limpar arquivos temporários
    cd - > /dev/null
    rm -rf "$temp_dir"

    log "Terraform instalado com sucesso no Linux!"
}

# Função para instalar Terraform no macOS
install_terraform_macos() {
    log "Instalando Terraform no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar Terraform via Homebrew
    brew install terraform

    log "Terraform instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_terraform_installed; then
        log "Verificação: Terraform instalado com sucesso!"
        terraform --version
        return 0
    else
        error "Falha na instalação do Terraform"
        return 1
    fi
}

# Função para instalação standalone do Terraform
install_terraform_standalone() {
    local os=$1

    # Verificar se Terraform já está instalado
    if is_terraform_installed; then
        warning "Terraform já está instalado"
        terraform --version
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu"|"centos")
            install_terraform_linux
            ;;
        "macos")
            install_terraform_macos
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

    install_terraform_standalone "$os"
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
