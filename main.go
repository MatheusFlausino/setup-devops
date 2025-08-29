package main

import (
	"fmt"
	"os"

	"github.com/matheusflausino/setup-devops-cli/cmd"
)

var (
	version = "dev"
	commit  = "unknown"
	date    = "unknown"
)

func main() {
	// Configurar informações de versão
	cmd.SetVersionInfo(version, commit, date)

	// Executar a CLI
	if err := cmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
