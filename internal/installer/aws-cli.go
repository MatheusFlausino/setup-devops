package installer

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
)

// installAWSCLI instala o AWS CLI no sistema
func installAWSCLI(osType utils.OSType) error {
	if isCommandAvailable("aws") {
		color.Yellow("⚠️  AWS CLI já está instalado")
		return nil
	}

	color.Green("☁️  Instalando AWS CLI...")

	switch osType {
	case utils.Ubuntu:
		return installAWSCLIUbuntu()
	case utils.CentOS:
		return installAWSCLICentOS()
	case utils.MacOS:
		return installAWSCLIMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do AWS CLI: %s", osType)
	}
}

// installAWSCLIUbuntu instala AWS CLI no Ubuntu
func installAWSCLIUbuntu() error {
	color.Blue("📦 Instalando AWS CLI no Ubuntu...")

	// Baixar o instalador
	if err := utils.RunCommand("curl", "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip", "-o", "awscliv2.zip"); err != nil {
		return fmt.Errorf("erro ao baixar AWS CLI: %w", err)
	}

	// Instalar unzip se não estiver disponível
	if !isCommandAvailable("unzip") {
		if err := utils.RunCommand("sudo", "apt-get", "update"); err != nil {
			return fmt.Errorf("erro ao atualizar repositórios: %w", err)
		}
		if err := utils.RunCommand("sudo", "apt-get", "install", "-y", "unzip"); err != nil {
			return fmt.Errorf("erro ao instalar unzip: %w", err)
		}
	}

	// Extrair o instalador
	if err := utils.RunCommand("unzip", "awscliv2.zip"); err != nil {
		return fmt.Errorf("erro ao extrair AWS CLI: %w", err)
	}

	// Instalar AWS CLI
	if err := utils.RunCommand("sudo", "./aws/install"); err != nil {
		return fmt.Errorf("erro ao instalar AWS CLI: %w", err)
	}

	// Limpar arquivos temporários
	utils.RunCommandSilent("rm", "-rf", "awscliv2.zip", "aws")

	color.Green("✅ AWS CLI instalado com sucesso no Ubuntu!")
	return nil
}

// installAWSCLICentOS instala AWS CLI no CentOS/RHEL
func installAWSCLICentOS() error {
	color.Blue("📦 Instalando AWS CLI no CentOS/RHEL...")

	// Baixar o instalador
	if err := utils.RunCommand("curl", "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip", "-o", "awscliv2.zip"); err != nil {
		return fmt.Errorf("erro ao baixar AWS CLI: %w", err)
	}

	// Instalar unzip se não estiver disponível
	if !isCommandAvailable("unzip") {
		if err := utils.RunCommand("sudo", "yum", "install", "-y", "unzip"); err != nil {
			return fmt.Errorf("erro ao instalar unzip: %w", err)
		}
	}

	// Extrair o instalador
	if err := utils.RunCommand("unzip", "awscliv2.zip"); err != nil {
		return fmt.Errorf("erro ao extrair AWS CLI: %w", err)
	}

	// Instalar AWS CLI
	if err := utils.RunCommand("sudo", "./aws/install"); err != nil {
		return fmt.Errorf("erro ao instalar AWS CLI: %w", err)
	}

	// Limpar arquivos temporários
	utils.RunCommandSilent("rm", "-rf", "awscliv2.zip", "aws")

	color.Green("✅ AWS CLI instalado com sucesso no CentOS/RHEL!")
	return nil
}

// installAWSCLIMacOS instala AWS CLI no macOS
func installAWSCLIMacOS() error {
	color.Blue("📦 Instalando AWS CLI no macOS...")

	// Verificar se Homebrew está instalado
	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	// Instalar AWS CLI via Homebrew
	if err := utils.RunCommand("brew", "install", "awscli"); err != nil {
		return fmt.Errorf("erro ao instalar AWS CLI: %w", err)
	}

	color.Green("✅ AWS CLI instalado com sucesso no macOS!")
	return nil
}
