package cmd

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/installer"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var installCmd = &cobra.Command{
	Use:   "install [TOOL]",
	Short: "Instalar uma ferramenta específica",
	Long: `Instala uma ferramenta DevOps específica no sistema.

Ferramentas disponíveis:
• Essenciais: docker, git, net-tools
• Cloud & DevOps: terraform, aws-cli, kubectl, watch, helm, helmfile, k9s`,
	Args: cobra.ExactArgs(1),
	RunE: runInstall,
}

func init() {
	rootCmd.AddCommand(installCmd)
	installCmd.Flags().BoolP("yes", "y", false, "Skip confirmation prompts")
}

func runInstall(cmd *cobra.Command, args []string) error {
	tool := args[0]

	// Verificar se está rodando como root
	if utils.IsRoot() {
		return fmt.Errorf("este comando não deve ser executado como root")
	}

	// Detectar sistema operacional
	osType, err := utils.DetectOS()
	if err != nil {
		return fmt.Errorf("erro ao detectar sistema operacional: %w", err)
	}

	// Verificar se a ferramenta é válida
	allTools := installer.GetAllTools()
	toolValid := false
	for _, t := range allTools {
		if t == tool {
			toolValid = true
			break
		}
	}

	if !toolValid {
		color.Red("❌ Ferramenta não reconhecida: %s", tool)
		color.Yellow("Ferramentas disponíveis:")
		color.Yellow("• Essenciais: %v", installer.GetEssentialTools())
		color.Yellow("• Cloud & DevOps: %v", installer.GetCloudDevOpsTools())
		return fmt.Errorf("ferramenta não reconhecida: %s", tool)
	}

	// Verificar pré-requisitos
	if err := installer.CheckPrerequisites(osType); err != nil {
		return fmt.Errorf("erro nos pré-requisitos: %w", err)
	}

	// Verificar se já está instalado
	if installer.IsToolInstalled(tool) {
		color.Yellow("⚠️  %s já está instalado", tool)
		return nil
	}

	// Confirmação do usuário (se não usar --yes)
	yes := viper.GetBool("yes") || cmd.Flag("yes").Changed
	if !yes {
		confirmed, err := utils.ConfirmPrompt(fmt.Sprintf("Deseja instalar %s", tool))
		if err != nil {
			return fmt.Errorf("erro ao obter confirmação: %w", err)
		}
		if !confirmed {
			color.Yellow("❌ Instalação cancelada pelo usuário")
			return nil
		}
	}

	// Instalar a ferramenta
	color.Green("🔧 Instalando %s...", tool)
	if err := installer.InstallTool(tool, osType); err != nil {
		return fmt.Errorf("erro ao instalar %s: %w", tool, err)
	}

	color.Green("✅ %s instalado com sucesso!", tool)
	return nil
}
