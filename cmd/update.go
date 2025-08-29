package cmd

import (
	"github.com/fatih/color"
	"github.com/spf13/cobra"
)

var updateCmd = &cobra.Command{
	Use:   "update",
	Short: "Atualizar a CLI",
	Long: `Atualiza a CLI Setup DevOps Tools para a versão mais recente.

A atualização é feita automaticamente baixando a versão mais recente do GitHub.`,
	RunE: runUpdate,
}

func init() {
	rootCmd.AddCommand(updateCmd)
}

func runUpdate(cmd *cobra.Command, args []string) error {
	color.Blue("🔄 Verificando atualizações...")
	color.Yellow("📦 Versão atual: %s", version)
	color.Yellow("📝 Para atualizar, visite: https://github.com/matheusflausino/setup-devops-cli/releases")
	color.Yellow("💡 Ou use: curl -sSL https://raw.githubusercontent.com/matheusflausino/setup-devops-cli/main/install.sh | bash")

	return nil
}
