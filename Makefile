# Makefile para Setup DevOps CLI
# Facilita o build, teste e release da CLI

.PHONY: help build build-all clean test install uninstall release

# Variáveis
BINARY_NAME = setup-devops
VERSION ?= $(shell git describe --tags --always --dirty)
COMMIT = $(shell git rev-parse --short HEAD)
DATE = $(shell date -u '+%Y-%m-%d_%H:%M:%S')
LDFLAGS = -ldflags "-X main.version=$(VERSION) -X main.commit=$(COMMIT) -X main.date=$(DATE)"

# Plataformas para build
PLATFORMS = linux-amd64 darwin-amd64 darwin-arm64

# Comando padrão
help:
	@echo "Setup DevOps CLI - Comandos disponíveis:"
	@echo ""
	@echo "  make build        - Build para a plataforma atual"
	@echo "  make build-all    - Build para todas as plataformas"
	@echo "  make test         - Executar testes"
	@echo "  make clean        - Limpar arquivos de build"
	@echo "  make install      - Instalar CLI localmente"
	@echo "  make uninstall    - Desinstalar CLI"
	@echo "  make release      - Preparar release"
	@echo "  make help         - Mostra esta ajuda"
	@echo ""

# Build para a plataforma atual
build:
	@echo "🔨 Buildando $(BINARY_NAME) v$(VERSION)..."
	go build $(LDFLAGS) -o bin/$(BINARY_NAME) .

# Build para todas as plataformas
build-all:
	@echo "🔨 Buildando $(BINARY_NAME) v$(VERSION) para todas as plataformas..."
	@mkdir -p bin
	@for platform in $(PLATFORMS); do \
		os=$${platform%-*}; \
		arch=$${platform#*-}; \
		echo "Buildando para $$os/$$arch..."; \
		GOOS=$$os GOARCH=$$arch go build $(LDFLAGS) -o bin/$(BINARY_NAME)-$$platform .; \
	done
	@echo "✅ Build concluído!"

# Testes
test:
	@echo "🧪 Executando testes..."
	go test -v ./...

# Limpeza
clean:
	@echo "🧹 Limpando arquivos de build..."
	@rm -rf bin/
	@go clean
	@echo "✅ Limpeza concluída!"

# Instalação local
install: build
	@echo "📦 Instalando CLI localmente..."
	@cp bin/$(BINARY_NAME) /usr/local/bin/
	@chmod +x /usr/local/bin/$(BINARY_NAME)
	@echo "✅ CLI instalada em /usr/local/bin/$(BINARY_NAME)"

# Desinstalação
uninstall:
	@echo "🗑️  Desinstalando CLI..."
	@rm -f /usr/local/bin/$(BINARY_NAME)
	@echo "✅ CLI desinstalada"

# Preparar release
release: build-all
	@echo "🚀 Preparando release v$(VERSION)..."
	@echo "Binários criados em bin/:"
	@ls -la bin/
	@echo ""
	@echo "Para criar um release no GitHub:"
	@echo "1. git tag v$(VERSION)"
	@echo "2. git push origin v$(VERSION)"
	@echo "3. Criar release no GitHub com os binários da pasta bin/"

# Desenvolvimento
dev: build
	@echo "🚀 Executando CLI em modo desenvolvimento..."
	./bin/$(BINARY_NAME) --help

# Verificar dependências
deps:
	@echo "📦 Verificando dependências..."
	go mod tidy
	go mod verify

# Lint
lint:
	@echo "🔍 Executando lint..."
	golangci-lint run

# Formatar código
fmt:
	@echo "🎨 Formatando código..."
	go fmt ./...
	goimports -w .

# Verificar se há mudanças não commitadas
check-dirty:
	@if [ -n "$(shell git status --porcelain)" ]; then \
		echo "❌ Há mudanças não commitadas. Faça commit antes de fazer release."; \
		exit 1; \
	fi

# Build para release (com verificação de mudanças)
release-build: check-dirty build-all
	@echo "✅ Build para release concluído!"

# Instalar ferramentas de desenvolvimento
install-tools:
	@echo "🔧 Instalando ferramentas de desenvolvimento..."
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	go install golang.org/x/tools/cmd/goimports@latest

# Verificar versão
version:
	@echo "📦 Versão atual: $(VERSION)"
	@echo "📝 Commit: $(COMMIT)"
	@echo "📅 Data: $(DATE)"

# Executar CLI local
run: build
	@./bin/$(BINARY_NAME) $(ARGS)

# Testar CLI
test-cli: build
	@echo "🧪 Testando CLI..."
	@./bin/$(BINARY_NAME) version
	@./bin/$(BINARY_NAME) --help
	@./bin/$(BINARY_NAME) status
	@echo "✅ Testes da CLI concluídos!"
