#!/bin/bash

# Test Setup Script - Verifica se as ferramentas foram instaladas corretamente
# Suporte: Ubuntu, CentOS/RHEL, macOS

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis globais
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/test-results.log"

# Lista de ferramentas para testar
TOOLS=("docker" "git" "terraform" "aws" "kubectl" "watch" "helm" "helmfile" "net-tools" "k9s")

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Função para verificar se uma ferramenta está instalada
check_tool() {
    local tool=$1
    local command_name=$2

    if command -v "$command_name" &> /dev/null; then
        local version=$($command_name --version 2>/dev/null || echo "versão não disponível")
        success "$tool está instalado: $version"
        return 0
    else
        error "$tool não está instalado ou não está no PATH"
        return 1
    fi
}

# Função para testar Docker
test_docker() {
    log "Testando Docker..."

    if check_tool "Docker" "docker"; then
        # Testar se o daemon do Docker está rodando
        if docker info &> /dev/null; then
            success "Docker daemon está rodando"
        else
            warning "Docker está instalado mas o daemon não está rodando"
            info "Execute: sudo systemctl start docker (Linux) ou inicie o Docker Desktop (macOS)"
        fi

        # Testar comando básico
        if docker --version &> /dev/null; then
            success "Docker responde corretamente"
        else
            error "Docker não responde corretamente"
        fi
    fi
}

# Função para testar Git
test_git() {
    log "Testando Git..."

    if check_tool "Git" "git"; then
        # Testar configuração básica
        if git config --global user.name &> /dev/null; then
            success "Git configurado com nome de usuário"
        else
            warning "Git não tem nome de usuário configurado"
            info "Execute: git config --global user.name 'Seu Nome'"
        fi

        if git config --global user.email &> /dev/null; then
            success "Git configurado com email"
        else
            warning "Git não tem email configurado"
            info "Execute: git config --global user.email 'seu.email@exemplo.com'"
        fi
    fi
}

# Função para testar Terraform
test_terraform() {
    log "Testando Terraform..."

    if check_tool "Terraform" "terraform"; then
        # Testar comando básico
        if terraform version &> /dev/null; then
            success "Terraform responde corretamente"
        else
            error "Terraform não responde corretamente"
        fi
    fi
}

# Função para testar AWS CLI
test_aws_cli() {
    log "Testando AWS CLI..."

    if check_tool "AWS CLI" "aws"; then
        # Testar comando básico
        if aws --version &> /dev/null; then
            success "AWS CLI responde corretamente"
        else
            error "AWS CLI não responde corretamente"
        fi

        # Verificar se está configurado
        if aws configure list &> /dev/null; then
            success "AWS CLI está configurado"
        else
            warning "AWS CLI não está configurado"
            info "Execute: aws configure"
        fi
    fi
}

# Função para testar kubectl
test_kubectl() {
    log "Testando kubectl..."

    if check_tool "kubectl" "kubectl"; then
        # Testar comando básico
        if kubectl version --client &> /dev/null; then
            success "kubectl responde corretamente"
        else
            error "kubectl não responde corretamente"
        fi

        # Verificar se há contexto configurado
        if kubectl config current-context &> /dev/null 2>&1; then
            success "kubectl tem contexto configurado"
        else
            warning "kubectl não tem contexto configurado"
            info "Configure um cluster Kubernetes ou execute: kubectl config set-cluster"
        fi
    fi
}

# Função para testar watch
test_watch() {
    log "Testando watch..."

    if check_tool "watch" "watch"; then
        # Testar comando básico
        if timeout 2s watch -n 1 echo "test" &> /dev/null; then
            success "watch responde corretamente"
        else
            error "watch não responde corretamente"
        fi
    fi
}

# Função para testar Helm
test_helm() {
    log "Testando Helm..."

    if check_tool "Helm" "helm"; then
        # Testar comando básico
        if helm version &> /dev/null; then
            success "Helm responde corretamente"
        else
            error "Helm não responde corretamente"
        fi

        # Verificar se há repositórios configurados
        if helm repo list &> /dev/null; then
            success "Helm tem repositórios configurados"
        else
            warning "Helm não tem repositórios configurados"
            info "Execute: helm repo add stable https://charts.helm.sh/stable"
        fi
    fi
}

# Função para testar Helmfile
test_helmfile() {
    log "Testando Helmfile..."

    if check_tool "Helmfile" "helmfile"; then
        # Testar comando básico
        if helmfile --version &> /dev/null; then
            success "Helmfile responde corretamente"
        else
            error "Helmfile não responde corretamente"
        fi
    fi
}

# Função para testar net-tools
test_net_tools() {
    log "Testando net-tools..."

    if check_tool "net-tools" "netstat"; then
        # Testar comando básico
        if command -v netstat &> /dev/null; then
            success "netstat responde corretamente"
        else
            error "netstat não responde corretamente"
        fi

        # Verificar outros comandos disponíveis
        if command -v ifconfig &> /dev/null; then
            success "ifconfig disponível"
        else
            warning "ifconfig não disponível"
        fi

        if command -v route &> /dev/null; then
            success "route disponível"
        else
            warning "route não disponível"
        fi
    fi
}

# Função para testar K9s
test_k9s() {
    log "Testando K9s..."

    if check_tool "K9s" "k9s"; then
        # Testar comando básico
        if k9s version &> /dev/null; then
            success "K9s responde corretamente"
        else
            error "K9s não responde corretamente"
        fi

        # Verificar se há contexto kubectl configurado
        if kubectl config current-context &> /dev/null 2>&1; then
            success "K9s pode usar contexto kubectl configurado"
        else
            warning "K9s não tem contexto kubectl configurado"
            info "Configure um cluster Kubernetes ou execute: kubectl config set-cluster"
        fi
    fi
}

# Função para testar conectividade de rede
test_network() {
    log "Testando conectividade de rede..."

    local endpoints=(
        "https://download.docker.com"
        "https://releases.hashicorp.com"
        "https://awscli.amazonaws.com"
        "https://dl.k8s.io"
        "https://api.github.com"
    )

    for endpoint in "${endpoints[@]}"; do
        if curl -fsSL --connect-timeout 5 "$endpoint" &> /dev/null; then
            success "Conectividade com $endpoint: OK"
        else
            warning "Conectividade com $endpoint: FALHA"
        fi
    done
}

# Função para testar permissões
test_permissions() {
    log "Testando permissões..."

    # Verificar se não está rodando como root
    if [[ $EUID -eq 0 ]]; then
        warning "Script está rodando como root (não recomendado)"
    else
        success "Script não está rodando como root"
    fi

    # Verificar acesso sudo
    if sudo -n true 2>/dev/null; then
        success "Acesso sudo disponível"
    else
        warning "Acesso sudo pode ser necessário para algumas operações"
    fi

    # Verificar permissões de escrita no diretório atual
    if [[ -w "$SCRIPT_DIR" ]]; then
        success "Permissão de escrita no diretório atual"
    else
        error "Sem permissão de escrita no diretório atual"
    fi
}

# Função para gerar relatório
generate_report() {
    local total_tools=${#TOOLS[@]}
    local installed_count=0
    local failed_count=0

    log "Gerando relatório de teste..."

    echo -e "\n${BLUE}=== RELATÓRIO DE TESTE ===${NC}" | tee -a "$LOG_FILE"
    echo "Data: $(date)" | tee -a "$LOG_FILE"
    echo "Sistema: $(uname -s) $(uname -r)" | tee -a "$LOG_FILE"
    echo "Arquitetura: $(uname -m)" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    for tool in "${TOOLS[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo "✅ $tool: INSTALADO" | tee -a "$LOG_FILE"
            ((installed_count++))
        else
            echo "❌ $tool: NÃO INSTALADO" | tee -a "$LOG_FILE"
            ((failed_count++))
        fi
    done

    echo "" | tee -a "$LOG_FILE"
    echo "Resumo:" | tee -a "$LOG_FILE"
    echo "- Total de ferramentas: $total_tools" | tee -a "$LOG_FILE"
    echo "- Instaladas: $installed_count" | tee -a "$LOG_FILE"
    echo "- Falharam: $failed_count" | tee -a "$LOG_FILE"
    echo "- Taxa de sucesso: $(( (installed_count * 100) / total_tools ))%" | tee -a "$LOG_FILE"

    if [[ $failed_count -eq 0 ]]; then
        echo -e "\n${GREEN}🎉 TODAS AS FERRAMENTAS FORAM INSTALADAS COM SUCESSO!${NC}" | tee -a "$LOG_FILE"
    else
        echo -e "\n${YELLOW}⚠️  ALGUMAS FERRAMENTAS FALHARAM NA INSTALAÇÃO${NC}" | tee -a "$LOG_FILE"
        echo "Verifique o log para mais detalhes: $LOG_FILE" | tee -a "$LOG_FILE"
    fi

    echo -e "${BLUE}========================${NC}" | tee -a "$LOG_FILE"
}

# Função principal
main() {
    log "Iniciando testes de verificação..."

    # Limpar arquivo de log anterior
    > "$LOG_FILE"

    # Testes básicos
    test_permissions
    test_network

    # Testes específicos das ferramentas
    test_docker
    test_git
    test_terraform
    test_aws_cli
    test_kubectl
    test_watch
    test_helm
    test_helmfile
    test_net_tools
    test_k9s

    # Gerar relatório final
    generate_report

    log "Testes concluídos. Verifique o relatório acima."
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
