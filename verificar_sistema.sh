#!/usr/bin/env bash

# Script de verificación de compatibilidad para personalizarTerminal.sh
# Detecta sistema operativo y verifica disponibilidad de paquetes

set -euo pipefail

# Colores
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m"

# Modo de ejecución: simple o detallado
MODE="${1:-simple}"

# Banner
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   Verificación de Sistema - customZsh${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# =========================================================================
# 1. DETECCIÓN DEL SISTEMA Y GESTOR DE PAQUETES
# =========================================================================

DISTRO_ID="unknown"
DISTRO_VERSION="unknown"
DISTRO_NAME="Desconocida"

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID="$ID"
    DISTRO_VERSION="${VERSION_ID:-unknown}"
    DISTRO_NAME="$PRETTY_NAME"
    
    echo -e "${GREEN}✓ Sistema detectado:${NC} $DISTRO_NAME"
    echo -e "${GREEN}✓ Distribución:${NC} $DISTRO_ID"
    echo -e "${GREEN}✓ Versión:${NC} $DISTRO_VERSION"
else
    echo -e "${RED}✗ No se pudo detectar la versión del sistema${NC}"
fi

# Detectar gestor de paquetes
PKG_MANAGER=""
INSTALL_CMD=""
if command -v apt-get &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
    echo -e "${GREEN}✓ Gestor de paquetes:${NC} APT (Debian/Ubuntu)"
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    echo -e "${GREEN}✓ Gestor de paquetes:${NC} DNF (Fedora/RHEL)"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S"
    echo -e "${GREEN}✓ Gestor de paquetes:${NC} Pacman (Arch Linux)"
else
    PKG_MANAGER="unknown"
    echo -e "${YELLOW}⚠️  Gestor de paquetes no reconocido. Deberás instalar dependencias manualmente.${NC}"
fi

if [[ "$PKG_MANAGER" != "apt" ]]; then
    echo -e "${YELLOW}⚠️  Este script está optimizado para Ubuntu y Debian, pero el instalador intentará adaptarse.${NC}"
fi
echo ""

# =========================================================================
# 2. VALIDACIÓN DEL INSTALADOR
# =========================================================================

echo -e "${CYAN}═══ Validación de Sintaxis ═══${NC}"
if [[ -f "personalizarTerminal.sh" ]]; then
    if bash -n personalizarTerminal.sh 2>/dev/null; then
        echo -e "${GREEN}✓ personalizarTerminal.sh - Sintaxis correcta${NC}"
    else
        echo -e "${RED}✗ personalizarTerminal.sh - Error de sintaxis${NC}"
        bash -n personalizarTerminal.sh
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  personalizarTerminal.sh no encontrado en el directorio actual${NC}"
fi
echo ""

# =========================================================================
# 3. VERIFICACIÓN DE DEPENDENCIAS GLOBALES
# =========================================================================

echo -e "${CYAN}═══ Comandos Requeridos ═══${NC}"
commands=("git" "curl" "wget" "unzip" "fc-cache" "rsync")
missing_commands=()

for cmd in "${commands[@]}"; do
    if command -v "$cmd" &>/dev/null; then
        echo -e "${GREEN}✓${NC} $cmd"
    else
        echo -e "${RED}✗${NC} $cmd ${YELLOW}(no instalado)${NC}"
        missing_commands+=("$cmd")
    fi
done

if [[ ${#missing_commands[@]} -gt 0 && -n "$INSTALL_CMD" ]]; then
    echo ""
    echo -e "${YELLOW}Instalar comandos faltantes:${NC}"
    echo -e "${GREEN}${INSTALL_CMD} ${missing_commands[*]}${NC}"
fi
echo ""

# =========================================================================
# 4. DISPONIBILIDAD DE PAQUETES (Solo APT)
# =========================================================================

if [[ "$MODE" == "detallado" && "$PKG_MANAGER" == "apt" ]]; then
    echo -e "${CYAN}═══ Disponibilidad de Paquetes en APT ═══${NC}"
    
    declare -a packages=("bat" "lsd" "build-essential" "zsh" "fontconfig" "fzf")
    declare -a descriptions=("bat/batcat" "lsd" "build-essential" "zsh" "fontconfig" "fzf")
    
    for i in "${!packages[@]}"; do
        pkg="${packages[$i]}"
        desc="${descriptions[$i]}"
        
        if apt-cache show "$pkg" 2>/dev/null | grep -q "^Package: $pkg$"; then
            version=$(apt-cache show "$pkg" 2>/dev/null | grep "^Version:" | head -n1 | awk '{print $2}')
            echo -e "${GREEN}✓${NC} $desc ${YELLOW}($version)${NC}"
        else
            echo -e "${RED}✗${NC} $desc ${YELLOW}(no en repositorios)${NC}"
        fi
    done
    echo ""
fi

# =========================================================================
# 5. ANÁLISIS DE FZF Y CONFIGURACIÓN LOCAL
# =========================================================================

echo -e "${CYAN}═══ Comprobación específica: fzf ═══${NC}"

if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    echo -e "${GREEN}✓${NC} FZF keybindings globales encontrados"
elif [ -f "$HOME/.fzf.zsh" ] || [ -d "$HOME/.fzf" ]; then
    echo -e "${GREEN}✓${NC} FZF configuración local encontrada en ~/.fzf"
else
    echo -e "${YELLOW}⚠️${NC} FZF no parece estar instalado aún en el sistema"
fi

if [[ -f "personalizarTerminal.sh" ]]; then
    if grep -q "fzf-history-widget" personalizarTerminal.sh; then
        echo -e "${GREEN}✓${NC} 'personalizarTerminal.sh' contiene el soporte para fzf (Ctrl+r)"
    else
        echo -e "${RED}✗${NC} 'personalizarTerminal.sh' no parece contener la configuración de fzf"
    fi
fi
echo ""

# =========================================================================
# 6. CONFIGURACIÓN RECOMENDADA (GLIBC Y VERSIONES)
# =========================================================================

echo -e "${CYAN}═══ Configuración Esperada ═══${NC}"

# Neovim y GLIBC
glibc_version=$(ldd --version 2>/dev/null | head -n1 | grep -oP '\d+\.\d+' | head -n1 || echo "desconocida")

if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "22.04" ]] || \
   [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" == "11" ]]; then
    echo -e "${YELLOW}⚠️  Neovim:${NC} Se instalará v0.9.5 (GLIBC $glibc_version)"
    echo -e "   ${BLUE}→${NC} Compatible con GLIBC 2.31-2.35"
    
    if [[ "$PKG_MANAGER" == "apt" ]]; then
        echo -e "${YELLOW}⚠️  lsd:${NC} Se intentará descargar desde GitHub (no en repositorios)"
        echo -e "${YELLOW}⚠️  bat:${NC} Se configurarán alias para 'batcat'"
    fi
else
    echo -e "${GREEN}✓ Neovim:${NC} Se instalará v0.11.4 (GLIBC $glibc_version)"
    echo -e "  ${BLUE}→${NC} Última versión compatible"
fi
echo ""

# =========================================================================
# RESUMEN FINAL
# =========================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [[ ${#missing_commands[@]} -eq 0 ]]; then
    echo -e "${GREEN}✅ Sistema compatible - Listo para ejecutar${NC}"
    echo ""
    echo -e "${CYAN}Ejecuta:${NC} bash personalizarTerminal.sh"
else
    echo -e "${YELLOW}⚠️  Se recomienda instalar los comandos faltantes antes de continuar${NC}"
    if [[ -n "$INSTALL_CMD" ]]; then
        echo -e "${CYAN}Ejecuta:${NC} ${INSTALL_CMD} ${missing_commands[*]}"
    fi
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [[ "$MODE" == "simple" ]]; then
    echo -e "${CYAN}Tip:${NC} Ejecuta '$0 detallado' para ver información de repositorios"
fi