package cmd

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/installer"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
	"github.com/spf13/cobra"
)

var statusCmd = &cobra.Command{
	Use:   "status",
	Short: "Verificar status das ferramentas",
	Long: `Verifica o status de instalação de todas as ferramentas DevOps no sistema.

Mostra quais ferramentas estão instaladas e quais ainda precisam ser instaladas.`,
	RunE: runStatus,
}

func init() {
	rootCmd.AddCommand(statusCmd)
}

func runStatus(cmd *cobra.Command, args []string) error {
	// Obter informações do sistema
	osInfo, err := utils.GetOSInfo()
	if err != nil {
		return fmt.Errorf("erro ao obter informações do sistema: %w", err)
	}

	color.Blue("🚀 Setup DevOps Tools - Status")
	color.Blue("Sistema: %s (%s)", osInfo["type"], osInfo["version"])
	color.Blue("Arquitetura: %s", osInfo["arch"])
	fmt.Println()

	// Verificar ferramentas essenciais
	color.Cyan("📦 Ferramentas Essenciais:")
	essentialTools := installer.GetEssentialTools()
	checkToolsStatus(essentialTools)

	fmt.Println()

	// Verificar ferramentas Cloud & DevOps
	color.Cyan("☁️  Ferramentas Cloud & DevOps:")
	cloudDevOpsTools := installer.GetCloudDevOpsTools()
	checkToolsStatus(cloudDevOpsTools)

	fmt.Println()

	// Resumo
	allTools := installer.GetAllTools()
	installedCount := 0
	for _, tool := range allTools {
		if installer.IsToolInstalled(tool) {
			installedCount++
		}
	}

	color.Green("📊 Resumo: %d/%d ferramentas instaladas", installedCount, len(allTools))

	if installedCount == len(allTools) {
		color.Green("🎉 Todas as ferramentas estão instaladas!")
	} else {
		color.Yellow("💡 Use 'setup-devops setup' para instalar as ferramentas restantes")
	}

	return nil
}

func checkToolsStatus(tools []string) {
	for _, tool := range tools {
		status := "❌"
		statusColor := color.RedString

		if installer.IsToolInstalled(tool) {
			status = "✅"
			statusColor = color.GreenString
		}

		fmt.Printf("  %s %s\n", statusColor(status), tool)
	}
}
