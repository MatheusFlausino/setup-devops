#!/bin/bash

# K9s Installer Script
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

# Função para verificar se K9s está instalado
is_k9s_installed() {
    command -v k9s &> /dev/null
}

# Função para obter a versão mais recente do K9s
get_latest_k9s_version() {
    curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Função para instalar K9s no Linux
install_k9s_linux() {
    log "Instalando K9s no Linux..."

    # Determinar arquitetura
    local arch="linux_x86_64"
    if [[ $(uname -m) == "aarch64" ]]; then
        arch="linux_arm64"
    fi

    # Obter versão mais recente
    local version=$(get_latest_k9s_version)
    log "Baixando K9s versão: $version"

    # Criar diretório temporário
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    # Download do K9s
    local download_url="https://github.com/derailed/k9s/releases/download/${version}/k9s_${arch}.tar.gz"
    log "Download de: $download_url"

    if ! curl -fsSL "$download_url" -o k9s.tar.gz; then
        error "Falha no download do K9s"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi

    # Extrair e instalar
    tar -xzf k9s.tar.gz
    sudo install -o root -g root -m 0755 k9s /usr/local/bin/k9s

    # Limpar arquivos temporários
    cd - > /dev/null
    rm -rf "$temp_dir"

    log "K9s instalado com sucesso no Linux!"
}

# Função para instalar K9s no macOS
install_k9s_macos() {
    log "Instalando K9s no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar K9s via Homebrew
    brew install derailed/k9s/k9s

    log "K9s instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_k9s_installed; then
        log "Verificação: K9s instalado com sucesso!"
        k9s version
        return 0
    else
        error "Falha na instalação do K9s"
        return 1
    fi
}

# Função para instalação standalone do K9s
install_k9s_standalone() {
    local os=$1

    # Verificar se K9s já está instalado
    if is_k9s_installed; then
        warning "K9s já está instalado"
        k9s version
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu"|"centos")
            install_k9s_linux
            ;;
        "macos")
            install_k9s_macos
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

    install_k9s_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
