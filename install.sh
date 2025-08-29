#!/bin/bash

# Setup DevOps CLI - Script de Instalação
# Instala a CLI Setup DevOps Tools via releases do GitHub

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis
REPO="matheusflausino/setup-devops-cli"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="setup-devops"

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

# Função para detectar o sistema operacional
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            echo "linux-amd64"
        elif command -v yum &> /dev/null || command -v dnf &> /dev/null; then
            echo "linux-amd64"
        else
            error "Sistema Linux não suportado"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ $(uname -m) == "arm64" ]]; then
            echo "darwin-arm64"
        else
            echo "darwin-amd64"
        fi
    else
        error "Sistema operacional não suportado: $OSTYPE"
        exit 1
    fi
}

# Função para obter a versão mais recente
get_latest_version() {
    local version
    version=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [[ -z "$version" ]]; then
        error "Não foi possível obter a versão mais recente"
        exit 1
    fi
    echo "$version"
}

# Função para baixar e instalar
install_cli() {
    local os_arch=$1
    local version=$2

    log "Instalando Setup DevOps CLI v$version para $os_arch"

    # URL do release
    local download_url="https://github.com/$REPO/releases/download/$version/setup-devops-$os_arch"

    # Criar diretório temporário
    local temp_dir=$(mktemp -d)
    local binary_path="$temp_dir/$BINARY_NAME"

    # Baixar o binário
    log "Baixando binário..."
    if ! curl -L -o "$binary_path" "$download_url"; then
        error "Falha ao baixar o binário"
        rm -rf "$temp_dir"
        exit 1
    fi

    # Tornar executável
    chmod +x "$binary_path"

    # Verificar se o binário é válido
    if ! "$binary_path" version &> /dev/null; then
        error "Binário inválido ou corrompido"
        rm -rf "$temp_dir"
        exit 1
    fi

    # Instalar no diretório do sistema
    log "Instalando em $INSTALL_DIR..."
    if [[ ! -w "$INSTALL_DIR" ]]; then
        warning "Permissão de escrita necessária para $INSTALL_DIR"
        if command -v sudo &> /dev/null; then
            sudo cp "$binary_path" "$INSTALL_DIR/"
        else
            error "sudo não disponível. Instale manualmente:"
            echo "cp $binary_path $INSTALL_DIR/"
            rm -rf "$temp_dir"
            exit 1
        fi
    else
        cp "$binary_path" "$INSTALL_DIR/"
    fi

    # Limpar arquivos temporários
    rm -rf "$temp_dir"

    log "Setup DevOps CLI instalado com sucesso!"
}

# Função para verificar se já está instalado
check_installed() {
    if command -v "$BINARY_NAME" &> /dev/null; then
        local current_version
        current_version=$("$BINARY_NAME" version 2>/dev/null || echo "unknown")
        warning "$BINARY_NAME já está instalado (versão: $current_version)"

        read -p "Deseja reinstalar? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Instalação cancelada"
            exit 0
        fi
    fi
}

# Função principal
main() {
    log "🚀 Setup DevOps CLI - Instalador"

    # Verificar dependências
    if ! command -v curl &> /dev/null; then
        error "curl não está instalado. Instale primeiro."
        exit 1
    fi

    # Verificar se já está instalado
    check_installed

    # Detectar sistema operacional
    local os_arch
    os_arch=$(detect_os)
    info "Sistema detectado: $os_arch"

    # Obter versão mais recente
    local version
    version=$(get_latest_version)
    info "Versão mais recente: $version"

    # Instalar CLI
    install_cli "$os_arch" "$version"

    # Verificar instalação
    if command -v "$BINARY_NAME" &> /dev/null; then
        log "✅ Instalação concluída com sucesso!"
        echo
        echo "Uso:"
        echo "  $BINARY_NAME --help"
        echo "  $BINARY_NAME setup"
        echo "  $BINARY_NAME status"
        echo
        echo "Para mais informações, visite:"
        echo "  https://github.com/$REPO"
    else
        error "❌ Falha na instalação"
        exit 1
    fi
}

# Executar função principal
main "$@"
