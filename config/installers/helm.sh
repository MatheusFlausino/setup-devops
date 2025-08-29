#!/bin/bash

# Helm Installer Script
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

# Função para verificar se Helm está instalado
is_helm_installed() {
    command -v helm &> /dev/null
}

# Função para obter a versão mais recente do Helm
get_latest_helm_version() {
    curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Função para instalar Helm no Linux
install_helm_linux() {
    log "Instalando Helm no Linux..."

    # Determinar arquitetura
    local arch="linux-amd64"
    if [[ $(uname -m) == "aarch64" ]]; then
        arch="linux-arm64"
    fi

    # Obter versão mais recente
    local version=$(get_latest_helm_version)
    log "Baixando Helm versão: $version"

    # Criar diretório temporário
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Download do Helm
    local download_url="https://get.helm.sh/helm-${version}-${arch}.tar.gz"
    log "Download de: $download_url"

    if ! curl -fsSL "$download_url" -o helm.tar.gz; then
        error "Falha no download do Helm"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi

    # Extrair e instalar
    tar -xzf helm.tar.gz
    sudo install -o root -g root -m 0755 "${arch}/helm" /usr/local/bin/helm

    # Limpar arquivos temporários
    cd - > /dev/null
    rm -rf "$temp_dir"

    log "Helm instalado com sucesso no Linux!"
}

# Função para instalar Helm no macOS
install_helm_macos() {
    log "Instalando Helm no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar Helm via Homebrew
    brew install helm

    log "Helm instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_helm_installed; then
        log "Verificação: Helm instalado com sucesso!"
        helm version
        return 0
    else
        error "Falha na instalação do Helm"
        return 1
    fi
}

# Função para instalação standalone do Helm
install_helm_standalone() {
    local os=$1

    # Verificar se Helm já está instalado
    if is_helm_installed; then
        warning "Helm já está instalado"
        helm version
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu"|"centos")
            install_helm_linux
            ;;
        "macos")
            install_helm_macos
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

    install_helm_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
