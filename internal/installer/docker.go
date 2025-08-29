package installer

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
)

// installDocker instala o Docker no sistema
func installDocker(osType utils.OSType) error {
	if isCommandAvailable("docker") {
		color.Yellow("⚠️  Docker já está instalado")
		return nil
	}

	color.Green("🐳 Instalando Docker...")

	switch osType {
	case utils.Ubuntu:
		return installDockerUbuntu()
	case utils.CentOS:
		return installDockerCentOS()
	case utils.MacOS:
		return installDockerMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do Docker: %s", osType)
	}
}

// installDockerUbuntu instala Docker no Ubuntu
func installDockerUbuntu() error {
	color.Blue("📦 Instalando Docker no Ubuntu...")

	// Atualizar repositórios
	if err := utils.RunCommand("sudo", "apt-get", "update"); err != nil {
		return fmt.Errorf("erro ao atualizar repositórios: %w", err)
	}

	// Instalar dependências
	deps := []string{"apt-transport-https", "ca-certificates", "curl", "gnupg", "lsb-release"}
	for _, dep := range deps {
		if err := utils.RunCommand("sudo", "apt-get", "install", "-y", dep); err != nil {
			return fmt.Errorf("erro ao instalar dependência %s: %w", dep, err)
		}
	}

	// Adicionar chave GPG oficial do Docker
	if err := utils.RunCommand("curl", "-fsSL", "https://download.docker.com/linux/ubuntu/gpg", "|", "sudo", "gpg", "--dearmor", "-o", "/usr/share/keyrings/docker-archive-keyring.gpg"); err != nil {
		return fmt.Errorf("erro ao adicionar chave GPG do Docker: %w", err)
	}

	// Adicionar repositório do Docker
	if err := utils.RunCommand("bash", "-c", `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`); err != nil {
		return fmt.Errorf("erro ao adicionar repositório do Docker: %w", err)
	}

	// Atualizar repositórios novamente
	if err := utils.RunCommand("sudo", "apt-get", "update"); err != nil {
		return fmt.Errorf("erro ao atualizar repositórios: %w", err)
	}

	// Instalar Docker CE
	dockerPkgs := []string{"docker-ce", "docker-ce-cli", "containerd.io"}
	for _, pkg := range dockerPkgs {
		if err := utils.RunCommand("sudo", "apt-get", "install", "-y", pkg); err != nil {
			return fmt.Errorf("erro ao instalar %s: %w", pkg, err)
		}
	}

	// Adicionar usuário ao grupo docker
	if err := utils.RunCommand("sudo", "usermod", "-aG", "docker", "$USER"); err != nil {
		return fmt.Errorf("erro ao adicionar usuário ao grupo docker: %w", err)
	}

	// Iniciar e habilitar serviço Docker
	if err := utils.RunCommand("sudo", "systemctl", "start", "docker"); err != nil {
		return fmt.Errorf("erro ao iniciar serviço Docker: %w", err)
	}

	if err := utils.RunCommand("sudo", "systemctl", "enable", "docker"); err != nil {
		return fmt.Errorf("erro ao habilitar serviço Docker: %w", err)
	}

	color.Green("✅ Docker instalado com sucesso no Ubuntu!")
	color.Yellow("⚠️  IMPORTANTE: Faça logout e login novamente para que as permissões do grupo docker sejam aplicadas, ou execute: newgrp docker")

	return nil
}

// installDockerCentOS instala Docker no CentOS/RHEL
func installDockerCentOS() error {
	color.Blue("📦 Instalando Docker no CentOS/RHEL...")

	// Instalar yum-utils
	if err := utils.RunCommand("sudo", "yum", "install", "-y", "yum-utils"); err != nil {
		return fmt.Errorf("erro ao instalar yum-utils: %w", err)
	}

	// Adicionar repositório do Docker
	if err := utils.RunCommand("sudo", "yum-config-manager", "--add-repo", "https://download.docker.com/linux/centos/docker-ce.repo"); err != nil {
		return fmt.Errorf("erro ao adicionar repositório do Docker: %w", err)
	}

	// Instalar Docker CE
	dockerPkgs := []string{"docker-ce", "docker-ce-cli", "containerd.io"}
	for _, pkg := range dockerPkgs {
		if err := utils.RunCommand("sudo", "yum", "install", "-y", pkg); err != nil {
			return fmt.Errorf("erro ao instalar %s: %w", pkg, err)
		}
	}

	// Iniciar e habilitar serviço Docker
	if err := utils.RunCommand("sudo", "systemctl", "start", "docker"); err != nil {
		return fmt.Errorf("erro ao iniciar serviço Docker: %w", err)
	}

	if err := utils.RunCommand("sudo", "systemctl", "enable", "docker"); err != nil {
		return fmt.Errorf("erro ao habilitar serviço Docker: %w", err)
	}

	// Adicionar usuário ao grupo docker
	if err := utils.RunCommand("sudo", "usermod", "-aG", "docker", "$USER"); err != nil {
		return fmt.Errorf("erro ao adicionar usuário ao grupo docker: %w", err)
	}

	color.Green("✅ Docker instalado com sucesso no CentOS/RHEL!")
	color.Yellow("⚠️  IMPORTANTE: Faça logout e login novamente para que as permissões do grupo docker sejam aplicadas, ou execute: newgrp docker")

	return nil
}

// installDockerMacOS instala Docker no macOS
func installDockerMacOS() error {
	color.Blue("📦 Instalando Docker no macOS...")

	// Verificar se Homebrew está instalado
	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	// Instalar Docker Desktop via Homebrew
	if err := utils.RunCommand("brew", "install", "--cask", "docker"); err != nil {
		return fmt.Errorf("erro ao instalar Docker Desktop: %w", err)
	}

	color.Green("✅ Docker Desktop instalado com sucesso no macOS!")
	color.Yellow("⚠️  IMPORTANTE: Inicie o Docker Desktop manualmente ou execute: open /Applications/Docker.app")

	return nil
}
