package cmd

import (
	"fmt"
	"runtime"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
)

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Mostrar informações de versão da CLI",
	Long: `Mostra informações detalhadas sobre a versão da CLI Setup DevOps Tools,
incluindo versão, commit, data de build e informações do sistema.`,
	Run: runVersion,
}

func init() {
	rootCmd.AddCommand(versionCmd)
}

func runVersion(cmd *cobra.Command, args []string) {
	color.Blue("🚀 Setup DevOps CLI")
	fmt.Printf("Version:     %s\n", version)
	fmt.Printf("Build Date:  %s\n", date)
	fmt.Printf("Go Version:  %s\n", runtime.Version())
	fmt.Printf("OS/Arch:     %s/%s\n", runtime.GOOS, runtime.GOARCH)

	// Informações adicionais
	fmt.Println()
	color.Cyan("📦 Ferramentas Suportadas:")
	fmt.Println("  • Essenciais: Docker, Git, net-tools")
	fmt.Println("  • Cloud & DevOps: Terraform, AWS CLI, kubectl, watch, Helm, Helmfile, K9s")

	fmt.Println()
	color.Cyan("🖥️  Sistemas Suportados:")
	fmt.Println("  • Ubuntu 20.04+")
	fmt.Println("  • CentOS/RHEL 8+")
	fmt.Println("  • macOS 12+")

	fmt.Println()
	color.Green("💡 Para mais informações, visite:")
	fmt.Println("  https://github.com/matheusflausino/setup-devops-cli")
}
