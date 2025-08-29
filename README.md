# Setup DevOps CLI

Uma CLI moderna e intuitiva para automatizar a instalação de ferramentas essenciais para desenvolvedores DevOps durante o processo de onboarding.

## 🚀 Características

- **CLI Moderna**: Interface de linha de comando intuitiva e colorida
- **Instalação Simples**: Instale via release do GitHub com um comando
- **Multiplataforma**: Suporte para Linux (Ubuntu/CentOS) e macOS
- **Atualizações Automáticas**: Sistema de atualização integrado
- **Interface Interativa**: Menus interativos para facilitar o uso
- **Instalação Seletiva**: Instale apenas as ferramentas que você precisa

## 🛠️ Ferramentas Suportadas

### Essenciais
- **Docker** - Plataforma de containerização
- **Git** - Sistema de controle de versão
- **net-tools** - Ferramentas de rede (netstat, ifconfig, route)

### Cloud & DevOps
- **Terraform** - Infraestrutura como código
- **AWS CLI v2** - Interface da Amazon Web Services
- **kubectl** - Gerenciamento de clusters Kubernetes
- **watch** - Monitoramento de comandos
- **Helm** - Gerenciador de pacotes para Kubernetes
- **Helmfile** - Gerenciamento declarativo de releases Helm
- **K9s** - Interface TUI para gerenciamento de Kubernetes

## 🖥️ Sistemas Operacionais Suportados

- **Ubuntu 20.04+** - com apt + repositórios oficiais
- **CentOS/RHEL 8+** - com yum/dnf + repositórios oficiais
- **macOS 12+** - com Homebrew + instaladores oficiais

## 📦 Instalação

### Instalação Rápida

```bash
# Instalar via script de instalação
curl -sSL https://raw.githubusercontent.com/matheusflausino/setup-devops-cli/main/install.sh | bash
```

### Instalação Manual

```bash
# 1. Baixar o binário para sua plataforma
# Linux AMD64
curl -L -o setup-devops https://github.com/matheusflausino/setup-devops-cli/releases/latest/download/setup-devops-linux-amd64

# macOS AMD64
curl -L -o setup-devops https://github.com/matheusflausino/setup-devops-cli/releases/latest/download/setup-devops-darwin-amd64

# macOS ARM64 (Apple Silicon)
curl -L -o setup-devops https://github.com/matheusflausino/setup-devops-cli/releases/latest/download/setup-devops-darwin-arm64

# 2. Tornar executável
chmod +x setup-devops

# 3. Mover para PATH
sudo mv setup-devops /usr/local/bin/
```

## 🚀 Como Usar

### Comandos Principais

```bash
# Ver ajuda
setup-devops --help

# Setup interativo (recomendado)
setup-devops setup

# Setup automático (todas as ferramentas)
setup-devops setup --yes

# Setup específico
setup-devops setup --type essentials    # Apenas ferramentas essenciais
setup-devops setup --type cloud-devops  # Apenas ferramentas Cloud & DevOps
setup-devops setup --type all           # Todas as ferramentas

# Instalar ferramenta específica
setup-devops install docker
setup-devops install terraform --yes

# Verificar status das ferramentas
setup-devops status

# Atualizar a CLI
setup-devops update
```

### Exemplos de Uso

#### Onboarding completo para novo desenvolvedor
```bash
# Instalar CLI
curl -sSL https://raw.githubusercontent.com/matheusflausino/setup-devops-cli/main/install.sh | bash

# Setup completo automático
setup-devops setup --yes
```

#### Instalação seletiva
```bash
# Setup interativo (escolher ferramentas)
setup-devops setup

# Apenas Docker
setup-devops install docker

# Apenas Terraform sem confirmação
setup-devops install terraform --yes
```

#### Verificar o que está instalado
```bash
# Ver status de todas as ferramentas
setup-devops status
```

## 📋 Pré-requisitos

### Para macOS
- [Homebrew](https://brew.sh) instalado (a CLI verificará automaticamente)

### Para todos os sistemas
- Acesso sudo (para instalação de pacotes)
- Conexão com internet
- curl (geralmente já instalado)

## 🔧 Desenvolvimento

### Pré-requisitos para Desenvolvimento
- Go 1.21+
- Make

### Build Local

```bash
# Clone o repositório
git clone https://github.com/matheusflausino/setup-devops-cli.git
cd setup-devops-cli

# Instalar dependências
go mod tidy

# Build para plataforma atual
make build

# Build para todas as plataformas
make build-all

# Instalar localmente
make install

# Executar testes
make test
```

### Comandos de Desenvolvimento

```bash
# Ver todos os comandos disponíveis
make help

# Build e executar
make dev

# Formatar código
make fmt

# Executar lint
make lint

# Testar CLI
make test-cli

# Preparar release
make release
```

## 🔒 Segurança

- A CLI não deve ser executada como root
- Usa repositórios oficiais quando possível
- Downloads de fontes confiáveis (HashiCorp, AWS, Kubernetes)
- Verificação de integridade quando disponível

## 🐛 Solução de Problemas

### Erro: "Homebrew não está instalado"
```bash
# Instale o Homebrew primeiro
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Erro: "Sistema Linux não suportado"
- A CLI suporta apenas Ubuntu e CentOS/RHEL
- Para outras distribuições, considere adaptar o código

### Erro de permissão
```bash
# Verifique se a CLI é executável
ls -la $(which setup-devops)

# Torne executável se necessário
chmod +x $(which setup-devops)
```

### Docker não funciona após instalação
```bash
# No Linux, adicione o usuário ao grupo docker
sudo usermod -aG docker $USER

# Faça logout e login novamente, ou execute:
newgrp docker
```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Changelog

### v1.0.0
- CLI moderna em Go
- Interface interativa
- Suporte multiplataforma
- Sistema de atualização
- Comandos intuitivos

## 🔗 Links Úteis

- [Releases](https://github.com/matheusflausino/setup-devops-cli/releases)
- [Issues](https://github.com/matheusflausino/setup-devops-cli/issues)
- [Discussions](https://github.com/matheusflausino/setup-devops-cli/discussions)
