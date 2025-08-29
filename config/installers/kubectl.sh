#!/bin/bash

# kubectl Installer Script
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

# Função para verificar se kubectl está instalado
is_kubectl_installed() {
    command -v kubectl &> /dev/null
}

# Função para obter a versão mais recente do kubectl
get_latest_kubectl_version() {
    curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt
}

# Função para instalar kubectl no Linux
install_kubectl_linux() {
    log "Instalando kubectl no Linux..."

    # Obter versão mais recente
    local version=$(get_latest_kubectl_version)
    log "Baixando kubectl versão: $version"

    # Download do kubectl
    local download_url="https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl"
    log "Download de: $download_url"

    if ! curl -fsSL "$download_url" -o kubectl; then
        error "Falha no download do kubectl"
        return 1
    fi

    # Instalar kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Limpar arquivo temporário
    rm kubectl

    log "kubectl instalado com sucesso no Linux!"
}

# Função para instalar kubectl no macOS
install_kubectl_macos() {
    log "Instalando kubectl no macOS..."

    # Verificar se Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        error "Homebrew não está instalado. Instale primeiro: https://brew.sh"
        return 1
    fi

    # Instalar kubectl via Homebrew
    brew install kubectl

    log "kubectl instalado com sucesso no macOS!"
}

# Função para verificar instalação
verify_installation() {
    if is_kubectl_installed; then
        log "Verificação: kubectl instalado com sucesso!"
        kubectl version --client
        return 0
    else
        error "Falha na instalação do kubectl"
        return 1
    fi
}

# Função para instalação standalone do kubectl
install_kubectl_standalone() {
    local os=$1

    # Verificar se kubectl já está instalado
    if is_kubectl_installed; then
        warning "kubectl já está instalado"
        kubectl version --client
        return 0
    fi

    # Instalar baseado no sistema operacional
    case $os in
        "ubuntu"|"centos")
            install_kubectl_linux
            ;;
        "macos")
            install_kubectl_macos
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

    install_kubectl_standalone "$os"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
