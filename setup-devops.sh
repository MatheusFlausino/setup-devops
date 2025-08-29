#!/bin/bash

# Setup DevOps Tools - Script de Onboarding
# Suporte: Ubuntu 20.04+, CentOS/RHEL 8+, macOS 12+

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis globais
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
LOG_FILE="$SCRIPT_DIR/setup.log"
AUTO_YES=false
INTERACTIVE=true

# Lista de ferramentas
ESSENTIAL_TOOLS=("docker" "git" "net-tools")
CLOUD_DEVOPS_TOOLS=("terraform" "aws-cli" "kubectl" "watch" "helm" "helmfile" "k9s")
ALL_TOOLS=("${ESSENTIAL_TOOLS[@]}" "${CLOUD_DEVOPS_TOOLS[@]}")

# Função para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Função para detectar o sistema operacional
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            echo "ubuntu"
        elif command -v yum &> /dev/null || command -v dnf &> /dev/null; then
            echo "centos"
        else
            error "Sistema Linux não suportado"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        error "Sistema operacional não suportado: $OSTYPE"
        exit 1
    fi
}

# Função para verificar se uma ferramenta está instalada
is_installed() {
    local tool=$1
    case $tool in
        "docker")
            command -v docker &> /dev/null
            ;;
        "git")
            command -v git &> /dev/null
            ;;
        "terraform")
            command -v terraform &> /dev/null
            ;;
        "aws-cli")
            command -v aws &> /dev/null
            ;;
        "kubectl")
            command -v kubectl &> /dev/null
            ;;
        "watch")
            command -v watch &> /dev/null
            ;;
        "helm")
            command -v helm &> /dev/null
            ;;
        "helmfile")
            command -v helmfile &> /dev/null
            ;;
        "net-tools")
            command -v netstat &> /dev/null || command -v ifconfig &> /dev/null || command -v route &> /dev/null
            ;;
        "k9s")
            command -v k9s &> /dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

# Funções de instalação removidas - agora usando instaladores específicos em config/installers/

# Função para carregar instaladores específicos
load_installers() {
    local installer_dir="$CONFIG_DIR/installers"

    # Carregar instaladores se existirem
    if [[ -f "$installer_dir/docker.sh" ]]; then
        source "$installer_dir/docker.sh"
    fi
    if [[ -f "$installer_dir/git.sh" ]]; then
        source "$installer_dir/git.sh"
    fi
    if [[ -f "$installer_dir/terraform.sh" ]]; then
        source "$installer_dir/terraform.sh"
    fi
    if [[ -f "$installer_dir/aws-cli.sh" ]]; then
        source "$installer_dir/aws-cli.sh"
    fi
    if [[ -f "$installer_dir/kubectl.sh" ]]; then
        source "$installer_dir/kubectl.sh"
    fi
    if [[ -f "$installer_dir/watch.sh" ]]; then
        source "$installer_dir/watch.sh"
    fi
    if [[ -f "$installer_dir/helm.sh" ]]; then
        source "$installer_dir/helm.sh"
    fi
    if [[ -f "$installer_dir/helmfile.sh" ]]; then
        source "$installer_dir/helmfile.sh"
    fi
    if [[ -f "$installer_dir/net-tools.sh" ]]; then
        source "$installer_dir/net-tools.sh"
    fi
    if [[ -f "$installer_dir/k9s.sh" ]]; then
        source "$installer_dir/k9s.sh"
    fi
}

# Função para instalar uma ferramenta específica
install_tool() {
    local tool=$1
    local os=$2

    if is_installed "$tool"; then
        warning "$tool já está instalado"
        return 0
    fi

    # Usar instalador específico
    case $tool in
        "docker")
            if command -v install_docker_standalone &> /dev/null; then
                install_docker_standalone "$os"
            else
                error "Instalador do Docker não encontrado. Verifique se config/installers/docker.sh existe."
                return 1
            fi
            ;;
        "git")
            if command -v install_git_standalone &> /dev/null; then
                install_git_standalone "$os"
            else
                error "Instalador do Git não encontrado. Verifique se config/installers/git.sh existe."
                return 1
            fi
            ;;
        "terraform")
            if command -v install_terraform_standalone &> /dev/null; then
                install_terraform_standalone "$os"
            else
                error "Instalador do Terraform não encontrado. Verifique se config/installers/terraform.sh existe."
                return 1
            fi
            ;;
        "aws-cli")
            if command -v install_aws_cli_standalone &> /dev/null; then
                install_aws_cli_standalone "$os"
            else
                error "Instalador do AWS CLI não encontrado. Verifique se config/installers/aws-cli.sh existe."
                return 1
            fi
            ;;
        "kubectl")
            if command -v install_kubectl_standalone &> /dev/null; then
                install_kubectl_standalone "$os"
            else
                error "Instalador do kubectl não encontrado. Verifique se config/installers/kubectl.sh existe."
                return 1
            fi
            ;;
        "watch")
            if command -v install_watch_standalone &> /dev/null; then
                install_watch_standalone "$os"
            else
                error "Instalador do watch não encontrado. Verifique se config/installers/watch.sh existe."
                return 1
            fi
            ;;
        "helm")
            if command -v install_helm_standalone &> /dev/null; then
                install_helm_standalone "$os"
            else
                error "Instalador do Helm não encontrado. Verifique se config/installers/helm.sh existe."
                return 1
            fi
            ;;
        "helmfile")
            if command -v install_helmfile_standalone &> /dev/null; then
                install_helmfile_standalone "$os"
            else
                error "Instalador do Helmfile não encontrado. Verifique se config/installers/helmfile.sh existe."
                return 1
            fi
            ;;
        "net-tools")
            if command -v install_net_tools_standalone &> /dev/null; then
                install_net_tools_standalone "$os"
            else
                error "Instalador do net-tools não encontrado. Verifique se config/installers/net-tools.sh existe."
                return 1
            fi
            ;;
        "k9s")
            if command -v install_k9s_standalone &> /dev/null; then
                install_k9s_standalone "$os"
            else
                error "Instalador do K9s não encontrado. Verifique se config/installers/k9s.sh existe."
                return 1
            fi
            ;;
        *)
            error "Ferramenta não reconhecida: $tool"
            return 1
            ;;
    esac
}

# Função para mostrar menu interativo
show_menu() {
    echo -e "\n${BLUE}=== Setup DevOps Tools ===${NC}"
    echo "1. Ferramentas Essenciais (Docker, Git)"
    echo "2. Ferramentas Cloud & DevOps (Terraform, AWS CLI, kubectl, watch)"
    echo "3. Todas as ferramentas"
    echo "4. Instalar ferramenta específica"
    echo "5. Sair"
    echo -e "${BLUE}========================${NC}\n"
}

# Função para mostrar ferramentas específicas
show_tools_menu() {
    echo -e "\n${BLUE}=== Ferramentas Disponíveis ===${NC}"
    local i=1
    for tool in "${ALL_TOOLS[@]}"; do
        local status=""
        if is_installed "$tool"; then
            status="${GREEN}[INSTALADO]${NC}"
        else
            status="${YELLOW}[NÃO INSTALADO]${NC}"
        fi
        echo "$i. $tool $status"
        ((i++))
    done
    echo "$i. Voltar"
    echo -e "${BLUE}==============================${NC}\n"
}

# Função para setup interativo
setup_interactive() {
    local os=$1

    while true; do
        show_menu
        read -p "Escolha uma opção: " choice

        case $choice in
            1)
                log "Instalando ferramentas essenciais..."
                for tool in "${ESSENTIAL_TOOLS[@]}"; do
                    install_tool "$tool" "$os"
                done
                ;;
            2)
                log "Instalando ferramentas Cloud & DevOps..."
                for tool in "${CLOUD_DEVOPS_TOOLS[@]}"; do
                    install_tool "$tool" "$os"
                done
                ;;
            3)
                log "Instalando todas as ferramentas..."
                for tool in "${ALL_TOOLS[@]}"; do
                    install_tool "$tool" "$os"
                done
                ;;
            4)
                setup_individual_interactive "$os"
                ;;
            5)
                log "Setup concluído!"
                exit 0
                ;;
            *)
                warning "Opção inválida. Tente novamente."
                ;;
        esac
    done
}

# Função para setup individual interativo
setup_individual_interactive() {
    local os=$1

    while true; do
        show_tools_menu
        read -p "Escolha uma ferramenta para instalar: " choice

        if [[ $choice -eq $((${#ALL_TOOLS[@]} + 1)) ]]; then
            break
        elif [[ $choice -ge 1 && $choice -le ${#ALL_TOOLS[@]} ]]; then
            local tool=${ALL_TOOLS[$((choice-1))]}
            install_tool "$tool" "$os"
        else
            warning "Opção inválida. Tente novamente."
        fi
    done
}

# Função para setup automático
setup_auto() {
    local os=$1
    log "Instalando todas as ferramentas automaticamente..."

    for tool in "${ALL_TOOLS[@]}"; do
        install_tool "$tool" "$os"
    done

    log "Setup automático concluído!"
}

# Função para instalar ferramenta específica
install_specific() {
    local tool=$1
    local os=$2

    if [[ " ${ALL_TOOLS[@]} " =~ " ${tool} " ]]; then
        install_tool "$tool" "$os"
    else
        error "Ferramenta não reconhecida: $tool"
        echo "Ferramentas disponíveis: ${ALL_TOOLS[*]}"
        exit 1
    fi
}

# Função para mostrar ajuda
show_help() {
    echo -e "${BLUE}Setup DevOps Tools - Script de Onboarding${NC}"
    echo ""
    echo "Uso: $0 [COMANDO] [OPÇÕES]"
    echo ""
    echo "Comandos:"
    echo "  setup              Instalação interativa de ferramentas"
    echo "  setup -y           Instalação automática de todas as ferramentas"
    echo "  install TOOL       Instalação de ferramenta específica"
    echo "  install TOOL -y    Instalação de ferramenta específica sem confirmação"
    echo "  help               Mostra esta ajuda"
    echo ""
    echo "Ferramentas disponíveis:"
    echo "  Essenciais:        ${ESSENTIAL_TOOLS[*]}"
    echo "  Cloud & DevOps:    ${CLOUD_DEVOPS_TOOLS[*]}"
    echo ""
    echo "Sistemas suportados:"
    echo "  - Ubuntu 20.04+"
    echo "  - CentOS/RHEL 8+"
    echo "  - macOS 12+"
    echo ""
    echo "Exemplos:"
    echo "  $0 setup"
    echo "  $0 setup -y"
    echo "  $0 install docker"
    echo "  $0 install terraform -y"
}

# Função principal
main() {
    # Verificar se está rodando como root
    if [[ $EUID -eq 0 ]]; then
        error "Este script não deve ser executado como root"
        exit 1
    fi

    # Carregar instaladores específicos
    load_installers

    # Detectar sistema operacional
    local os=$(detect_os)
    log "Sistema operacional detectado: $os"

    # Processar argumentos
    case "${1:-}" in
        "setup")
            if [[ "${2:-}" == "-y" ]]; then
                setup_auto "$os"
            else
                setup_interactive "$os"
            fi
            ;;
        "install")
            if [[ -z "${2:-}" ]]; then
                error "Especifique uma ferramenta para instalar"
                show_help
                exit 1
            fi

            local tool=$2
            if [[ "${3:-}" == "-y" ]]; then
                install_specific "$tool" "$os"
            else
                if $INTERACTIVE; then
                    read -p "Deseja instalar $tool? (y/N): " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        install_specific "$tool" "$os"
                    else
                        log "Instalação cancelada pelo usuário"
                    fi
                else
                    install_specific "$tool" "$os"
                fi
            fi
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        "")
            show_help
            ;;
        *)
            error "Comando não reconhecido: $1"
            show_help
            exit 1
            ;;
    esac
}

# Executar função principal
main "$@"
