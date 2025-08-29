package utils

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// GetUserChoice apresenta um menu e retorna a escolha do usuário
func GetUserChoice(prompt string, options []string) (int, error) {
	fmt.Printf("\n%s:\n", prompt)
	for i, option := range options {
		fmt.Printf("%d. %s\n", i+1, option)
	}

	for {
		fmt.Print("\nEscolha uma opção: ")
		reader := bufio.NewReader(os.Stdin)
		input, err := reader.ReadString('\n')
		if err != nil {
			return 0, fmt.Errorf("erro ao ler entrada: %w", err)
		}

		choice, err := strconv.Atoi(strings.TrimSpace(input))
		if err != nil {
			fmt.Println("❌ Por favor, digite um número válido")
			continue
		}

		if choice < 1 || choice > len(options) {
			fmt.Printf("❌ Por favor, escolha um número entre 1 e %d\n", len(options))
			continue
		}

		return choice, nil
	}
}

// ConfirmPrompt apresenta uma pergunta de confirmação
func ConfirmPrompt(prompt string) (bool, error) {
	for {
		fmt.Printf("%s (y/N): ", prompt)
		reader := bufio.NewReader(os.Stdin)
		input, err := reader.ReadString('\n')
		if err != nil {
			return false, fmt.Errorf("erro ao ler entrada: %w", err)
		}

		response := strings.ToLower(strings.TrimSpace(input))

		switch response {
		case "y", "yes", "s", "sim":
			return true, nil
		case "n", "no", "":
			return false, nil
		default:
			fmt.Println("❌ Por favor, responda com 'y' (sim) ou 'n' (não)")
		}
	}
}

// GetUserInput solicita entrada do usuário
func GetUserInput(prompt string) (string, error) {
	fmt.Print(prompt + ": ")
	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')
	if err != nil {
		return "", fmt.Errorf("erro ao ler entrada: %w", err)
	}

	return strings.TrimSpace(input), nil
}

// ShowProgress mostra uma barra de progresso simples
func ShowProgress(current, total int, message string) {
	percentage := float64(current) / float64(total) * 100
	barLength := 30
	filled := int(float64(barLength) * percentage / 100)

	bar := "["
	for i := 0; i < barLength; i++ {
		if i < filled {
			bar += "="
		} else {
			bar += " "
		}
	}
	bar += "]"

	fmt.Printf("\r%s %s %.1f%% (%d/%d)", message, bar, percentage, current, total)

	if current == total {
		fmt.Println()
	}
}
