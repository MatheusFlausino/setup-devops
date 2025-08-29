package utils

import (
	"os/exec"
)

// RunCommand executa um comando do sistema
func RunCommand(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Stdout = nil
	cmd.Stderr = nil
	return cmd.Run()
}

// RunCommandSilent executa um comando do sistema sem retornar erro (para operações de limpeza)
func RunCommandSilent(name string, args ...string) {
	_ = RunCommand(name, args...)
}
