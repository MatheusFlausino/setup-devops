package cmd

import (
	"fmt"
	"os"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var (
	cfgFile string
	version string
	commit  string
	date    string
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "setup-devops",
	Short: "Setup DevOps Tools - CLI para instalação de ferramentas DevOps",
	Long: `Setup DevOps Tools é uma CLI moderna para automatizar a instalação
de ferramentas essenciais para desenvolvedores DevOps durante o processo de onboarding.

Ferramentas suportadas:
• Essenciais: Docker, Git, net-tools
• Cloud & DevOps: Terraform, AWS CLI, kubectl, watch, Helm, Helmfile, K9s

Sistemas suportados: Ubuntu 20.04+, CentOS/RHEL 8+, macOS 12+`,
	Version: version,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Setup DevOps CLI v%s\n", version)
		fmt.Printf("Commit: %s\n", commit)
		fmt.Printf("Build Date: %s\n", date)
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
func Execute() error {
	return rootCmd.Execute()
}

// SetVersionInfo configura as informações de versão
func SetVersionInfo(v, c, d string) {
	version = v
	commit = c
	date = d
}

func init() {
	cobra.OnInitialize(initConfig)

	// Flags globais
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.setup-devops.yaml)")
	rootCmd.PersistentFlags().BoolP("verbose", "v", false, "verbose output")
	rootCmd.PersistentFlags().BoolP("yes", "y", false, "skip confirmation prompts")

	// Bind flags to viper
	viper.BindPFlag("verbose", rootCmd.PersistentFlags().Lookup("verbose"))
	viper.BindPFlag("yes", rootCmd.PersistentFlags().Lookup("yes"))

	// Configurar cores
	color.NoColor = false
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := os.UserHomeDir()
		cobra.CheckErr(err)

		// Search config in home directory with name ".setup-devops" (without extension).
		viper.AddConfigPath(home)
		viper.SetConfigType("yaml")
		viper.SetConfigName(".setup-devops")
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		fmt.Fprintln(os.Stderr, "Using config file:", viper.ConfigFileUsed())
	}
}
