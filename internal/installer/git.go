package installer

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
)

// installGit instala o Git no sistema
func installGit(osType utils.OSType) error {
	if isCommandAvailable("git") {
		color.Yellow("⚠️  Git já está instalado")
		return nil
	}

	color.Green("📝 Instalando Git...")

	switch osType {
	case utils.Ubuntu:
		return installGitUbuntu()
	case utils.CentOS:
		return installGitCentOS()
	case utils.MacOS:
		return installGitMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do Git: %s", osType)
	}
}

// installGitUbuntu instala Git no Ubuntu
func installGitUbuntu() error {
	color.Blue("📦 Instalando Git no Ubuntu...")

	// Atualizar repositórios
	if err := utils.RunCommand("sudo", "apt-get", "update"); err != nil {
		return fmt.Errorf("erro ao atualizar repositórios: %w", err)
	}

	// Instalar Git
	if err := utils.RunCommand("sudo", "apt-get", "install", "-y", "git"); err != nil {
		return fmt.Errorf("erro ao instalar Git: %w", err)
	}

	color.Green("✅ Git instalado com sucesso no Ubuntu!")
	return nil
}

// installGitCentOS instala Git no CentOS/RHEL
func installGitCentOS() error {
	color.Blue("📦 Instalando Git no CentOS/RHEL...")

	// Instalar Git
	if err := utils.RunCommand("sudo", "yum", "install", "-y", "git"); err != nil {
		return fmt.Errorf("erro ao instalar Git: %w", err)
	}

	color.Green("✅ Git instalado com sucesso no CentOS/RHEL!")
	return nil
}

// installGitMacOS instala Git no macOS
func installGitMacOS() error {
	color.Blue("📦 Instalando Git no macOS...")

	// Verificar se Homebrew está instalado
	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	// Instalar Git via Homebrew
	if err := utils.RunCommand("brew", "install", "git"); err != nil {
		return fmt.Errorf("erro ao instalar Git: %w", err)
	}

	color.Green("✅ Git instalado com sucesso no macOS!")
	return nil
}
