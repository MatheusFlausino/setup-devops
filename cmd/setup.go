package cmd

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/matheusflausino/setup-devops-cli/internal/installer"
	"github.com/matheusflausino/setup-devops-cli/internal/utils"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var setupCmd = &cobra.Command{
	Use:   "setup",
	Short: "Instalar ferramentas DevOps",
	Long: `Instala ferramentas DevOps no sistema. Pode ser usado de forma interativa
ou automática com a flag --yes.`,
	RunE: runSetup,
}

var (
	setupType string
)

func init() {
	rootCmd.AddCommand(setupCmd)

	setupCmd.Flags().StringVarP(&setupType, "type", "t", "interactive", "Tipo de setup: interactive, essentials, cloud-devops, all")
	setupCmd.Flags().BoolP("yes", "y", false, "Skip confirmation prompts")
}

func runSetup(cmd *cobra.Command, args []string) error {
	// Verificar se está rodando como root
	if utils.IsRoot() {
		return fmt.Errorf("este comando não deve ser executado como root")
	}

	// Detectar sistema operacional
	osType, err := utils.DetectOS()
	if err != nil {
		return fmt.Errorf("erro ao detectar sistema operacional: %w", err)
	}

	color.Blue("🚀 Setup DevOps Tools")
	color.Blue("Sistema operacional detectado: %s", string(osType))

	// Verificar pré-requisitos
	if err := installer.CheckPrerequisites(osType); err != nil {
		return fmt.Errorf("erro nos pré-requisitos: %w", err)
	}

	// Determinar tipo de setup
	yes := viper.GetBool("yes") || cmd.Flag("yes").Changed
	setupMode := setupType

	if yes {
		// Setup automático
		color.Yellow("⚠️  Executando setup automático (todas as ferramentas)")
		return installer.InstallAll(osType)
	}

	// Setup interativo
	switch setupMode {
	case "interactive":
		return runInteractiveSetup(osType)
	case "essentials":
		color.Green("📦 Instalando ferramentas essenciais...")
		return installer.InstallEssentials(osType)
	case "cloud-devops":
		color.Green("☁️  Instalando ferramentas Cloud & DevOps...")
		return installer.InstallCloudDevOps(osType)
	case "all":
		color.Green("🔧 Instalando todas as ferramentas...")
		return installer.InstallAll(osType)
	default:
		return fmt.Errorf("tipo de setup inválido: %s", setupMode)
	}
}

func runInteractiveSetup(osType utils.OSType) error {
	for {
		showSetupMenu()

		choice, err := utils.GetUserChoice("Escolha uma opção", []string{
			"Ferramentas Essenciais (Docker, Git, net-tools)",
			"Ferramentas Cloud & DevOps (Terraform, AWS CLI, kubectl, etc.)",
			"Todas as ferramentas",
			"Instalar ferramenta específica",
			"Sair",
		})

		if err != nil {
			return err
		}

		switch choice {
		case 1:
			color.Green("📦 Instalando ferramentas essenciais...")
			if err := installer.InstallEssentials(osType); err != nil {
				color.Red("❌ Erro ao instalar ferramentas essenciais: %v", err)
			}
		case 2:
			color.Green("☁️  Instalando ferramentas Cloud & DevOps...")
			if err := installer.InstallCloudDevOps(osType); err != nil {
				color.Red("❌ Erro ao instalar ferramentas Cloud & DevOps: %v", err)
			}
		case 3:
			color.Green("🔧 Instalando todas as ferramentas...")
			if err := installer.InstallAll(osType); err != nil {
				color.Red("❌ Erro ao instalar todas as ferramentas: %v", err)
			}
		case 4:
			if err := runIndividualToolSetup(osType); err != nil {
				color.Red("❌ Erro no setup individual: %v", err)
			}
		case 5:
			color.Green("✅ Setup concluído!")
			return nil
		}
	}
}

func showSetupMenu() {
	color.Cyan("\n=== Setup DevOps Tools ===")
	fmt.Println("1. Ferramentas Essenciais (Docker, Git, net-tools)")
	fmt.Println("2. Ferramentas Cloud & DevOps (Terraform, AWS CLI, kubectl, etc.)")
	fmt.Println("3. Todas as ferramentas")
	fmt.Println("4. Instalar ferramenta específica")
	fmt.Println("5. Sair")
	color.Cyan("========================\n")
}

func runIndividualToolSetup(osType utils.OSType) error {
	tools := installer.GetAllTools()

	for {
		showToolsMenu(tools)

		choice, err := utils.GetUserChoice("Escolha uma ferramenta para instalar", append(tools, "Voltar"))
		if err != nil {
			return err
		}

		if choice == len(tools)+1 {
			break
		}

		if choice >= 1 && choice <= len(tools) {
			tool := tools[choice-1]
			color.Green("🔧 Instalando %s...", tool)
			if err := installer.InstallTool(tool, osType); err != nil {
				color.Red("❌ Erro ao instalar %s: %v", tool, err)
			}
		}
	}

	return nil
}

func showToolsMenu(tools []string) {
	color.Cyan("\n=== Ferramentas Disponíveis ===")
	for i, tool := range tools {
		status := "❌"
		if installer.IsToolInstalled(tool) {
			status = "✅"
		}
		fmt.Printf("%d. %s %s\n", i+1, tool, status)
	}
	fmt.Printf("%d. Voltar\n", len(tools)+1)
	color.Cyan("==============================\n")
}
