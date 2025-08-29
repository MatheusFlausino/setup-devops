package installer

import (
	"fmt"
	"os/exec"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
)

// Tool representa uma ferramenta que pode ser instalada
type Tool struct {
	Name        string
	Description string
	Category    string
	Installed   bool
}

// Lista de ferramentas essenciais
var essentialTools = []string{"docker", "git", "net-tools"}

// Lista de ferramentas Cloud & DevOps
var cloudDevOpsTools = []string{"terraform", "aws-cli", "kubectl", "watch", "helm", "helmfile", "k9s"}

// GetAllTools retorna todas as ferramentas disponíveis
func GetAllTools() []string {
	return append(essentialTools, cloudDevOpsTools...)
}

// GetEssentialTools retorna as ferramentas essenciais
func GetEssentialTools() []string {
	return essentialTools
}

// GetCloudDevOpsTools retorna as ferramentas Cloud & DevOps
func GetCloudDevOpsTools() []string {
	return cloudDevOpsTools
}

// IsToolInstalled verifica se uma ferramenta está instalada
func IsToolInstalled(tool string) bool {
	switch tool {
	case "docker":
		return isCommandAvailable("docker")
	case "git":
		return isCommandAvailable("git")
	case "terraform":
		return isCommandAvailable("terraform")
	case "aws-cli":
		return isCommandAvailable("aws")
	case "kubectl":
		return isCommandAvailable("kubectl")
	case "watch":
		return isCommandAvailable("watch")
	case "helm":
		return isCommandAvailable("helm")
	case "helmfile":
		return isCommandAvailable("helmfile")
	case "net-tools":
		return isCommandAvailable("netstat") || isCommandAvailable("ifconfig") || isCommandAvailable("route")
	case "k9s":
		return isCommandAvailable("k9s")
	default:
		return false
	}
}

// isCommandAvailable verifica se um comando está disponível no PATH
func isCommandAvailable(command string) bool {
	_, err := exec.LookPath(command)
	return err == nil
}

// CheckPrerequisites verifica os pré-requisitos do sistema
func CheckPrerequisites(osType utils.OSType) error {
	color.Blue("🔍 Verificando pré-requisitos...")

	switch osType {
	case utils.MacOS:
		if !isCommandAvailable("brew") {
			return fmt.Errorf("Homebrew não está instalado. Instale primeiro: https://brew.sh")
		}
		color.Green("✅ Homebrew encontrado")
	case utils.Ubuntu, utils.CentOS:
		// Verificar se curl está disponível
		if !isCommandAvailable("curl") {
			return fmt.Errorf("curl não está instalado. Instale primeiro: sudo apt-get install curl (Ubuntu) ou sudo yum install curl (CentOS)")
		}
		color.Green("✅ curl encontrado")
	}

	return nil
}

// InstallEssentials instala as ferramentas essenciais
func InstallEssentials(osType utils.OSType) error {
	color.Green("📦 Instalando ferramentas essenciais...")

	for _, tool := range essentialTools {
		if err := InstallTool(tool, osType); err != nil {
			color.Red("❌ Erro ao instalar %s: %v", tool, err)
			// Continue com as outras ferramentas
		}
	}

	return nil
}

// InstallCloudDevOps instala as ferramentas Cloud & DevOps
func InstallCloudDevOps(osType utils.OSType) error {
	color.Green("☁️  Instalando ferramentas Cloud & DevOps...")

	for _, tool := range cloudDevOpsTools {
		if err := InstallTool(tool, osType); err != nil {
			color.Red("❌ Erro ao instalar %s: %v", tool, err)
			// Continue com as outras ferramentas
		}
	}

	return nil
}

// InstallAll instala todas as ferramentas
func InstallAll(osType utils.OSType) error {
	color.Green("🔧 Instalando todas as ferramentas...")

	allTools := GetAllTools()
	for i, tool := range allTools {
		utils.ShowProgress(i+1, len(allTools), fmt.Sprintf("Instalando %s", tool))
		if err := InstallTool(tool, osType); err != nil {
			color.Red("❌ Erro ao instalar %s: %v", tool, err)
			// Continue com as outras ferramentas
		}
	}

	return nil
}

// InstallTool instala uma ferramenta específica
func InstallTool(tool string, osType utils.OSType) error {
	if IsToolInstalled(tool) {
		color.Yellow("⚠️  %s já está instalado", tool)
		return nil
	}

	color.Green("🔧 Instalando %s...", tool)

	switch tool {
	case "docker":
		return installDocker(osType)
	case "git":
		return installGit(osType)
	case "terraform":
		return installTerraform(osType)
	case "aws-cli":
		return installAWSCLI(osType)
	case "kubectl":
		return installKubectl(osType)
	case "watch":
		return installWatch(osType)
	case "helm":
		return installHelm(osType)
	case "helmfile":
		return installHelmfile(osType)
	case "net-tools":
		return installNetTools(osType)
	case "k9s":
		return installK9s(osType)
	default:
		return fmt.Errorf("ferramenta não reconhecida: %s", tool)
	}
}

// Funções de instalação específicas (serão implementadas em arquivos separados)
