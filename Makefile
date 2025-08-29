# Makefile para Setup DevOps Tools
# Facilita o uso do script de onboarding

.PHONY: help setup setup-auto install test clean

# Variáveis
SCRIPT = ./setup-devops.sh
TEST_SCRIPT = ./test-setup.sh

# Comando padrão
help:
	@echo "Setup DevOps Tools - Comandos disponíveis:"
	@echo ""
	@echo "  make setup        - Setup interativo (menu para escolher ferramentas)"
	@echo "  make setup-auto   - Setup automático (instala todas as ferramentas)"
	@echo "  make install      - Instalação individual (especifique a ferramenta)"
	@echo "  make test         - Testa se as ferramentas foram instaladas corretamente"
	@echo "  make clean        - Remove arquivos de log"
	@echo "  make help         - Mostra esta ajuda"
	@echo ""
	@echo "Exemplos:"
	@echo "  make install TOOL=docker"
	@echo "  make install TOOL=terraform"
	@echo ""

# Setup interativo
setup:
	@echo "Iniciando setup interativo..."
	$(SCRIPT) setup

# Setup automático
setup-auto:
	@echo "Iniciando setup automático..."
	$(SCRIPT) setup -y

# Instalação individual
install:
	@if [ -z "$(TOOL)" ]; then \
		echo "Erro: Especifique a ferramenta com TOOL=<nome>"; \
		echo "Exemplo: make install TOOL=docker"; \
		exit 1; \
	fi
	@echo "Instalando $(TOOL)..."
	$(SCRIPT) install $(TOOL)

# Instalação individual automática
install-auto:
	@if [ -z "$(TOOL)" ]; then \
		echo "Erro: Especifique a ferramenta com TOOL=<nome>"; \
		echo "Exemplo: make install-auto TOOL=docker"; \
		exit 1; \
	fi
	@echo "Instalando $(TOOL) automaticamente..."
	$(SCRIPT) install $(TOOL) -y

# Teste das ferramentas
test:
	@echo "Testando instalação das ferramentas..."
	$(TEST_SCRIPT)

# Limpeza de logs
clean:
	@echo "Removendo arquivos de log..."
	@rm -f setup.log test-results.log
	@echo "Logs removidos!"

# Verificar se o script é executável
check:
	@if [ ! -x "$(SCRIPT)" ]; then \
		echo "Tornando script executável..."; \
		chmod +x $(SCRIPT); \
	fi
	@if [ ! -x "$(TEST_SCRIPT)" ]; then \
		echo "Tornando script de teste executável..."; \
		chmod +x $(TEST_SCRIPT); \
	fi
	@echo "Scripts verificados!"

# Instalação completa (setup + teste)
all: check setup-auto test

# Instalação das ferramentas essenciais
essentials: check
	@echo "Instalando ferramentas essenciais..."
	$(SCRIPT) install docker
	$(SCRIPT) install git
	$(SCRIPT) install net-tools

# Instalação das ferramentas Cloud & DevOps
cloud-devops: check
	@echo "Instalando ferramentas Cloud & DevOps..."
	$(SCRIPT) install terraform
	$(SCRIPT) install aws-cli
	$(SCRIPT) install kubectl
	$(SCRIPT) install watch
	$(SCRIPT) install helm
	$(SCRIPT) install helmfile
	$(SCRIPT) install k9s

# Mostrar status das ferramentas
status:
	@echo "Verificando status das ferramentas..."
	@echo "Docker: $$(command -v docker >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "Git: $$(command -v git >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "Terraform: $$(command -v terraform >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "AWS CLI: $$(command -v aws >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "kubectl: $$(command -v kubectl >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "watch: $$(command -v watch >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "Helm: $$(command -v helm >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "Helmfile: $$(command -v helmfile >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "net-tools: $$(command -v netstat >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"
	@echo "K9s: $$(command -v k9s >/dev/null 2>&1 && echo '✅ Instalado' || echo '❌ Não instalado')"

# Atualizar scripts
update:
	@echo "Atualizando scripts..."
	@git pull origin main 2>/dev/null || echo "Não é um repositório git ou não há atualizações"
	@chmod +x $(SCRIPT) $(TEST_SCRIPT)
	@echo "Scripts atualizados!"
