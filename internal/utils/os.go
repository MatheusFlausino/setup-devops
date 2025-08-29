package utils

import (
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"strings"
)

// OSType representa o tipo de sistema operacional
type OSType string

const (
	Ubuntu OSType = "ubuntu"
	CentOS OSType = "centos"
	MacOS  OSType = "macos"
)

// DetectOS detecta o sistema operacional
func DetectOS() (OSType, error) {
	switch runtime.GOOS {
	case "linux":
		return detectLinuxDistro()
	case "darwin":
		return MacOS, nil
	default:
		return "", fmt.Errorf("sistema operacional não suportado: %s", runtime.GOOS)
	}
}

// detectLinuxDistro detecta a distribuição Linux
func detectLinuxDistro() (OSType, error) {
	// Verificar se é Ubuntu/Debian
	if _, err := exec.LookPath("apt-get"); err == nil {
		return Ubuntu, nil
	}

	// Verificar se é CentOS/RHEL
	if _, err := exec.LookPath("yum"); err == nil {
		return CentOS, nil
	}

	if _, err := exec.LookPath("dnf"); err == nil {
		return CentOS, nil
	}

	return "", fmt.Errorf("distribuição Linux não suportada")
}

// IsRoot verifica se o processo está rodando como root
func IsRoot() bool {
	return os.Geteuid() == 0
}

// GetOSInfo retorna informações detalhadas do sistema operacional
func GetOSInfo() (map[string]string, error) {
	info := make(map[string]string)

	osType, err := DetectOS()
	if err != nil {
		return nil, err
	}

	info["type"] = string(osType)
	info["arch"] = runtime.GOARCH
	info["goos"] = runtime.GOOS

	// Informações específicas por OS
	switch osType {
	case Ubuntu:
		if version, err := getUbuntuVersion(); err == nil {
			info["version"] = version
		}
	case CentOS:
		if version, err := getCentOSVersion(); err == nil {
			info["version"] = version
		}
	case MacOS:
		if version, err := getMacOSVersion(); err == nil {
			info["version"] = version
		}
	}

	return info, nil
}

// getUbuntuVersion obtém a versão do Ubuntu
func getUbuntuVersion() (string, error) {
	cmd := exec.Command("lsb_release", "-r", "-s")
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(output)), nil
}

// getCentOSVersion obtém a versão do CentOS
func getCentOSVersion() (string, error) {
	cmd := exec.Command("cat", "/etc/redhat-release")
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(output)), nil
}

// getMacOSVersion obtém a versão do macOS
func getMacOSVersion() (string, error) {
	cmd := exec.Command("sw_vers", "-productVersion")
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(output)), nil
}
