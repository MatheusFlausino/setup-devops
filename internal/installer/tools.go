package installer

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
)

// installKubectl instala o kubectl no sistema
func installKubectl(osType utils.OSType) error {
	if isCommandAvailable("kubectl") {
		color.Yellow("⚠️  kubectl já está instalado")
		return nil
	}

	color.Green("☸️  Instalando kubectl...")

	switch osType {
	case utils.Ubuntu:
		return installKubectlUbuntu()
	case utils.CentOS:
		return installKubectlCentOS()
	case utils.MacOS:
		return installKubectlMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do kubectl: %s", osType)
	}
}

func installKubectlUbuntu() error {
	color.Blue("📦 Instalando kubectl no Ubuntu...")

	// Baixar kubectl
	if err := runCommand("curl", "-LO", "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl"); err != nil {
		return fmt.Errorf("erro ao baixar kubectl: %w", err)
	}

	// Tornar executável
	if err := runCommand("chmod", "+x", "kubectl"); err != nil {
		return fmt.Errorf("erro ao tornar kubectl executável: %w", err)
	}

	// Mover para PATH
	if err := runCommand("sudo", "mv", "kubectl", "/usr/local/bin/"); err != nil {
		return fmt.Errorf("erro ao instalar kubectl: %w", err)
	}

	color.Green("✅ kubectl instalado com sucesso no Ubuntu!")
	return nil
}

func installKubectlCentOS() error {
	color.Blue("📦 Instalando kubectl no CentOS/RHEL...")

	// Baixar kubectl
	if err := runCommand("curl", "-LO", "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl"); err != nil {
		return fmt.Errorf("erro ao baixar kubectl: %w", err)
	}

	// Tornar executável
	if err := runCommand("chmod", "+x", "kubectl"); err != nil {
		return fmt.Errorf("erro ao tornar kubectl executável: %w", err)
	}

	// Mover para PATH
	if err := runCommand("sudo", "mv", "kubectl", "/usr/local/bin/"); err != nil {
		return fmt.Errorf("erro ao instalar kubectl: %w", err)
	}

	color.Green("✅ kubectl instalado com sucesso no CentOS/RHEL!")
	return nil
}

func installKubectlMacOS() error {
	color.Blue("📦 Instalando kubectl no macOS...")

	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	if err := runCommand("brew", "install", "kubectl"); err != nil {
		return fmt.Errorf("erro ao instalar kubectl: %w", err)
	}

	color.Green("✅ kubectl instalado com sucesso no macOS!")
	return nil
}

// installWatch instala o watch no sistema
func installWatch(osType utils.OSType) error {
	if isCommandAvailable("watch") {
		color.Yellow("⚠️  watch já está instalado")
		return nil
	}

	color.Green("👀 Instalando watch...")

	switch osType {
	case utils.Ubuntu:
		return installWatchUbuntu()
	case utils.CentOS:
		return installWatchCentOS()
	case utils.MacOS:
		return installWatchMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do watch: %s", osType)
	}
}

func installWatchUbuntu() error {
	color.Blue("📦 Instalando watch no Ubuntu...")

	if err := runCommand("sudo", "apt-get", "update"); err != nil {
		return fmt.Errorf("erro ao atualizar repositórios: %w", err)
	}

	if err := runCommand("sudo", "apt-get", "install", "-y", "procps"); err != nil {
		return fmt.Errorf("erro ao instalar watch: %w", err)
	}

	color.Green("✅ watch instalado com sucesso no Ubuntu!")
	return nil
}

func installWatchCentOS() error {
	color.Blue("📦 Instalando watch no CentOS/RHEL...")

	if err := runCommand("sudo", "yum", "install", "-y", "procps-ng"); err != nil {
		return fmt.Errorf("erro ao instalar watch: %w", err)
	}

	color.Green("✅ watch instalado com sucesso no CentOS/RHEL!")
	return nil
}

func installWatchMacOS() error {
	color.Blue("📦 Instalando watch no macOS...")

	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	if err := runCommand("brew", "install", "watch"); err != nil {
		return fmt.Errorf("erro ao instalar watch: %w", err)
	}

	color.Green("✅ watch instalado com sucesso no macOS!")
	return nil
}

// installHelm instala o Helm no sistema
func installHelm(osType utils.OSType) error {
	if isCommandAvailable("helm") {
		color.Yellow("⚠️  Helm já está instalado")
		return nil
	}

	color.Green("⚓ Instalando Helm...")

	switch osType {
	case utils.Ubuntu:
		return installHelmUbuntu()
	case utils.CentOS:
		return installHelmCentOS()
	case utils.MacOS:
		return installHelmMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do Helm: %s", osType)
	}
}

func installHelmUbuntu() error {
	color.Blue("📦 Instalando Helm no Ubuntu...")

	// Baixar Helm
	if err := runCommand("curl", "https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz", "-o", "helm.tar.gz"); err != nil {
		return fmt.Errorf("erro ao baixar Helm: %w", err)
	}

	// Extrair
	if err := runCommand("tar", "-xzf", "helm.tar.gz"); err != nil {
		return fmt.Errorf("erro ao extrair Helm: %w", err)
	}

	// Mover para PATH
	if err := runCommand("sudo", "mv", "linux-amd64/helm", "/usr/local/bin/"); err != nil {
		return fmt.Errorf("erro ao instalar Helm: %w", err)
	}

	// Limpar
	runCommand("rm", "-rf", "helm.tar.gz", "linux-amd64")

	color.Green("✅ Helm instalado com sucesso no Ubuntu!")
	return nil
}

func installHelmCentOS() error {
	color.Blue("📦 Instalando Helm no CentOS/RHEL...")

	// Baixar Helm
	if err := runCommand("curl", "https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz", "-o", "helm.tar.gz"); err != nil {
		return fmt.Errorf("erro ao baixar Helm: %w", err)
	}

	// Extrair
	if err := runCommand("tar", "-xzf", "helm.tar.gz"); err != nil {
		return fmt.Errorf("erro ao extrair Helm: %w", err)
	}

	// Mover para PATH
	if err := runCommand("sudo", "mv", "linux-amd64/helm", "/usr/local/bin/"); err != nil {
		return fmt.Errorf("erro ao instalar Helm: %w", err)
	}

	// Limpar
	runCommand("rm", "-rf", "helm.tar.gz", "linux-amd64")

	color.Green("✅ Helm instalado com sucesso no CentOS/RHEL!")
	return nil
}

func installHelmMacOS() error {
	color.Blue("📦 Instalando Helm no macOS...")

	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	if err := runCommand("brew", "install", "helm"); err != nil {
		return fmt.Errorf("erro ao instalar Helm: %w", err)
	}

	color.Green("✅ Helm instalado com sucesso no macOS!")
	return nil
}

// installHelmfile instala o Helmfile no sistema
func installHelmfile(osType utils.OSType) error {
	if isCommandAvailable("helmfile") {
		color.Yellow("⚠️  Helmfile já está instalado")
		return nil
	}

	color.Green("📋 Instalando Helmfile...")

	switch osType {
	case utils.Ubuntu:
		return installHelmfileUbuntu()
	case utils.CentOS:
		return installHelmfileCentOS()
	case utils.MacOS:
		return installHelmfileMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do Helmfile: %s", osType)
	}
}

func installHelmfileUbuntu() error {
	color.Blue("📦 Instalando Helmfile no Ubuntu...")

	// Baixar Helmfile
	if err := runCommand("curl", "-L", "https://github.com/helmfile/helmfile/releases/latest/download/helmfile_linux_amd64", "-o", "helmfile"); err != nil {
		return fmt.Errorf("erro ao baixar Helmfile: %w", err)
	}

	// Tornar executável
	if err := runCommand("chmod", "+x", "helmfile"); err != nil {
		return fmt.Errorf("erro ao tornar Helmfile executável: %w", err)
	}

	// Mover para PATH
	if err := runCommand("sudo", "mv", "helmfile", "/usr/local/bin/"); err != nil {
		return fmt.Errorf("erro ao instalar Helmfile: %w", err)
	}

	color.Green("✅ Helmfile instalado com sucesso no Ubuntu!")
	return nil
}

func installHelmfileCentOS() error {
	color.Blue("📦 Instalando Helmfile no CentOS/RHEL...")

	// Baixar Helmfile
	if err := runCommand("curl", "-L", "https://github.com/helmfile/helmfile/releases/latest/download/helmfile_linux_amd64", "-o", "helmfile"); err != nil {
		return fmt.Errorf("erro ao baixar Helmfile: %w", err)
	}

	// Tornar executável
	if err := runCommand("chmod", "+x", "helmfile"); err != nil {
		return fmt.Errorf("erro ao tornar Helmfile executável: %w", err)
	}

	// Mover para PATH
	if err := runCommand("sudo", "mv", "helmfile", "/usr/local/bin/"); err != nil {
		return fmt.Errorf("erro ao instalar Helmfile: %w", err)
	}

	color.Green("✅ Helmfile instalado com sucesso no CentOS/RHEL!")
	return nil
}

func installHelmfileMacOS() error {
	color.Blue("📦 Instalando Helmfile no macOS...")

	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	if err := runCommand("brew", "install", "helmfile"); err != nil {
		return fmt.Errorf("erro ao instalar Helmfile: %w", err)
	}

	color.Green("✅ Helmfile instalado com sucesso no macOS!")
	return nil
}

// installNetTools instala o net-tools no sistema
func installNetTools(osType utils.OSType) error {
	if isCommandAvailable("netstat") || isCommandAvailable("ifconfig") || isCommandAvailable("route") {
		color.Yellow("⚠️  net-tools já está instalado")
		return nil
	}

	color.Green("🌐 Instalando net-tools...")

	switch osType {
	case utils.Ubuntu:
		return installNetToolsUbuntu()
	case utils.CentOS:
		return installNetToolsCentOS()
	case utils.MacOS:
		return installNetToolsMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do net-tools: %s", osType)
	}
}

func installNetToolsUbuntu() error {
	color.Blue("📦 Instalando net-tools no Ubuntu...")

	if err := runCommand("sudo", "apt-get", "update"); err != nil {
		return fmt.Errorf("erro ao atualizar repositórios: %w", err)
	}

	if err := runCommand("sudo", "apt-get", "install", "-y", "net-tools"); err != nil {
		return fmt.Errorf("erro ao instalar net-tools: %w", err)
	}

	color.Green("✅ net-tools instalado com sucesso no Ubuntu!")
	return nil
}

func installNetToolsCentOS() error {
	color.Blue("📦 Instalando net-tools no CentOS/RHEL...")

	if err := runCommand("sudo", "yum", "install", "-y", "net-tools"); err != nil {
		return fmt.Errorf("erro ao instalar net-tools: %w", err)
	}

	color.Green("✅ net-tools instalado com sucesso no CentOS/RHEL!")
	return nil
}

func installNetToolsMacOS() error {
	color.Blue("📦 Instalando net-tools no macOS...")

	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	if err := runCommand("brew", "install", "net-tools"); err != nil {
		return fmt.Errorf("erro ao instalar net-tools: %w", err)
	}

	color.Green("✅ net-tools instalado com sucesso no macOS!")
	return nil
}

// installK9s instala o K9s no sistema
func installK9s(osType utils.OSType) error {
	if isCommandAvailable("k9s") {
		color.Yellow("⚠️  K9s já está instalado")
		return nil
	}

	color.Green("🐕 Instalando K9s...")

	switch osType {
	case utils.Ubuntu:
		return installK9sUbuntu()
	case utils.CentOS:
		return installK9sCentOS()
	case utils.MacOS:
		return installK9sMacOS()
	default:
		return fmt.Errorf("sistema operacional não suportado para instalação do K9s: %s", osType)
	}
}

func installK9sUbuntu() error {
	color.Blue("📦 Instalando K9s no Ubuntu...")

	// Baixar K9s
	if err := runCommand("curl", "-sS", "https://webinstall.dev/k9s", "|", "bash"); err != nil {
		return fmt.Errorf("erro ao instalar K9s: %w", err)
	}

	color.Green("✅ K9s instalado com sucesso no Ubuntu!")
	return nil
}

func installK9sCentOS() error {
	color.Blue("📦 Instalando K9s no CentOS/RHEL...")

	// Baixar K9s
	if err := runCommand("curl", "-sS", "https://webinstall.dev/k9s", "|", "bash"); err != nil {
		return fmt.Errorf("erro ao instalar K9s: %w", err)
	}

	color.Green("✅ K9s instalado com sucesso no CentOS/RHEL!")
	return nil
}

func installK9sMacOS() error {
	color.Blue("📦 Instalando K9s no macOS...")

	if !isCommandAvailable("brew") {
		return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
	}

	if err := runCommand("brew", "install", "k9s"); err != nil {
		return fmt.Errorf("erro ao instalar K9s: %w", err)
	}

	color.Green("✅ K9s instalado com sucesso no macOS!")
	return nil
}
