# Setup DevOps Tools - Script de Onboarding

Script bash para automatizar a instalação de ferramentas essenciais para desenvolvedores DevOps durante o processo de onboarding.

## 🚀 Ferramentas Suportadas

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

## 🖥️ Sistemas Operacionais Suportados

- **Ubuntu 20.04+** - com apt + repositórios oficiais
- **CentOS/RHEL 8+** - com yum/dnf + repositórios oficiais
- **macOS 12+** - com Homebrew + instaladores oficiais

## 📋 Pré-requisitos

### Para macOS
- [Homebrew](https://brew.sh) instalado (o script verificará automaticamente)

### Para todos os sistemas
- Acesso sudo (para instalação de pacotes)
- Conexão com internet
- curl (geralmente já instalado)

## 🛠️ Como Usar

### 1. Tornar o script executável
```bash
chmod +x setup-devops.sh
```

### 2. Comandos disponíveis

#### Setup Interativo
```bash
./setup-devops.sh setup
```
- Menu interativo para escolher quais ferramentas instalar
- Opções: ferramentas essenciais, cloud & DevOps, todas as ferramentas, ou ferramenta específica

#### Setup Automático
```bash
./setup-devops.sh setup -y
```
- Instala todas as ferramentas automaticamente sem perguntas

#### Instalação Individual
```bash
./setup-devops.sh install [FERRAMENTA]
```
- Instala uma ferramenta específica
- Exemplo: `./setup-devops.sh install docker`

#### Instalação Individual Automática
```bash
./setup-devops.sh install [FERRAMENTA] -y
```
- Instala uma ferramenta específica sem confirmação
- Exemplo: `./setup-devops.sh install terraform -y`

#### Ajuda
```bash
./setup-devops.sh help
```

## 📝 Exemplos de Uso

### Onboarding completo para novo desenvolvedor
```bash
# Clone o repositório
git clone <repository-url>
cd setup-devops

# Execute o setup completo
./setup-devops.sh setup -y
```

### Instalação seletiva
```bash
# Apenas ferramentas essenciais
./setup-devops.sh setup
# Escolha opção 1 no menu

# Apenas Docker
./setup-devops.sh install docker

# Apenas Terraform
./setup-devops.sh install terraform -y
```

## 🔧 Detalhes Técnicos

### Arquitetura Modular
O script utiliza uma arquitetura modular com instaladores específicos:
- **Script principal** (`setup-devops.sh`) - Orquestra a instalação
- **Instaladores específicos** (`config/installers/`) - Cada ferramenta tem seu próprio instalador
- **Configurações** (`config/versions.conf`) - Versões e configurações centralizadas

### Detecção Automática de Sistema
O script detecta automaticamente:
- Ubuntu (apt-get disponível)
- CentOS/RHEL (yum/dnf disponível)
- macOS (darwin)

### Verificação de Instalação
O script verifica se cada ferramenta já está instalada antes de tentar instalá-la novamente.

### Logs
Todas as operações são registradas em `setup.log` no diretório do script.

### Tratamento de Erros
- Verificação de sistema operacional suportado
- Verificação de pré-requisitos (Homebrew no macOS)
- Tratamento de erros de instalação
- Logs detalhados de erros

## 🔒 Segurança

- O script não deve ser executado como root
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
- O script suporta apenas Ubuntu e CentOS/RHEL
- Para outras distribuições, considere adaptar o script

### Erro de permissão
```bash
# Verifique se o script é executável
ls -la setup-devops.sh

# Torne executável se necessário
chmod +x setup-devops.sh
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
