package installer

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
)

// installTerraform instala o Terraform no sistema
func installTerraform(osType utils.OSType) error {
	if isCommandAvailable("terraform") {
		color.Yellow("⚠️  Terraform já está instalado")
		return nil
	}

	color.Green("🏗️  Instalando Terraform...")

	switch osType {
	case utils.Ubuntu:
		return installTerraformUbuntu()
	case utils.CentOS:
		return installTerraformCentOS()
	case utils.MacOS:
		return installTerraformMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do Terraform: %s", osType)
	}
}

// installTerraformUbuntu instala Terraform no Ubuntu
func installTerraformUbuntu() error {
	color.Blue("📦 Instalando Terraform no Ubuntu...")

	// Adicionar chave GPG do HashiCorp
	if err := utils.RunCommand("wget", "-O-", "https://apt.releases.hashicorp.com/gpg", "|", "sudo", "gpg", "--dearmor", "-o", "/usr/share/keyrings/hashicorp-archive-keyring.gpg"); err != nil {
		return fmt.Errorf("erro ao adicionar chave GPG do HashiCorp: %w", err)
	}

	// Adicionar repositório do HashiCorp
	if err := utils.RunCommand("bash", "-c", `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`); err != nil {
		return fmt.Errorf("erro ao adicionar repositório do HashiCorp: %w", err)
	}

	// Atualizar repositórios
	if err := utils.RunCommand("sudo", "apt-get", "update"); err != nil {
		return fmt.Errorf("erro ao atualizar repositórios: %w", err)
	}

	// Instalar Terraform
	if err := utils.RunCommand("sudo", "apt-get", "install", "-y", "terraform"); err != nil {
		return fmt.Errorf("erro ao instalar Terraform: %w", err)
	}

	color.Green("✅ Terraform instalado com sucesso no Ubuntu!")
	return nil
}

// installTerraformCentOS instala Terraform no CentOS/RHEL
func installTerraformCentOS() error {
	color.Blue("📦 Instalando Terraform no CentOS/RHEL...")

	// Adicionar repositório do HashiCorp
	if err := utils.RunCommand("sudo", "yum-config-manager", "--add-repo", "https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo"); err != nil {
		return fmt.Errorf("erro ao adicionar repositório do HashiCorp: %w", err)
	}

	// Instalar Terraform
	if err := utils.RunCommand("sudo", "yum", "-y", "install", "terraform"); err != nil {
		return fmt.Errorf("erro ao instalar Terraform: %w", err)
	}

	color.Green("✅ Terraform instalado com sucesso no CentOS/RHEL!")
	return nil
}

// installTerraformMacOS instala Terraform no macOS
func installTerraformMacOS() error {
	color.Blue("📦 Instalando Terraform no macOS...")

	// Verificar se Homebrew está instalado
	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	// Instalar Terraform via Homebrew
	if err := utils.RunCommand("brew", "install", "terraform"); err != nil {
		return fmt.Errorf("erro ao instalar Terraform: %w", err)
	}

	color.Green("✅ Terraform instalado com sucesso no macOS!")
	return nil
}
