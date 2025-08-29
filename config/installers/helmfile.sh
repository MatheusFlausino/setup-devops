#!/bin/bash

# Helmfile Installer Script
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

# Função para verificar se Helmfile está instalado
is_helmfile_installed() {
    command -v helmfile &> /dev/null
}

# Função para obter a versão mais recente do Helmfile
get_latest_helmfile_version() {
    curl -s https://api.github.com/repos/helmfile/helmfile/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Função para instalar Helmfile no Linux
install_helmfile_linux() {
    log "Instalando Helmfile no Linux..."

    # Determinar arquitetura
    local arch="linux_amd64"
    if [[ $(uname -m) == "aarch64" ]]; then
        arch="linux_arm64"
    fi

    # Obter versão mais recente
    local version=$(get_latest_helmfile_version)
    log "Baixando Helmfile versão: $version"

    # Criar diretório temporário
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Download do Helmfile
    local download_url="https://github.com/helmfile/helmfile/releases/download/${version}/helmfile_${version}_${arch}.tar.gz"
    log "Download de: $download_url"

    if ! curl -fsSL "$download_url" -o helmfile.tar.gz; then
        error "Falha no download do Helmfile"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi

    # Extrair e instalar
    tar -xzf helmfile.tar.gz
    sudo install -o root -g root -m 0755 helmfile /usr/local/bin/helmfile

    # Limpar arquivos temporários
    cd - > /dev/null
    rm -rf "$temp_dir"

    log "Helmfile instalado com sucesso no Linux!"
}

# Função para instalar Helmfile no macOS
install_helmfile_macos() {
    log "Instalando Helmfile no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar Helmfile via Homebrew
    brew install helmfile

    log "Helmfile instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_helmfile_installed; then
        log "Verificação: Helmfile instalado com sucesso!"
        helmfile --version
        return 0
    else
        error "Falha na instalação do Helmfile"
        return 1
    fi
}

# Função para instalação standalone do Helmfile
install_helmfile_standalone() {
    local os=$1

    # Verificar se Helmfile já está instalado
    if is_helmfile_installed; then
        warning "Helmfile já está instalado"
        helmfile --version
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu"|"centos")
            install_helmfile_linux
            ;;
        "macos")
            install_helmfile_macos
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

    install_helmfile_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
