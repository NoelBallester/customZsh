#!/usr/bin/env bash

# Script de verificación de compatibilidad para personalizarTerminal.sh
# Detecta sistema operativo y verifica disponibilidad de paquetes

set -eo pipefail

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
echo -e "${BLUE}   Verificación de Sistema - personalizarTerminal.sh${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Detectar sistema operativo
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID="$ID"
    DISTRO_VERSION="$VERSION_ID"
    DISTRO_NAME="$PRETTY_NAME"
    
    echo -e "${GREEN}✓ Sistema detectado:${NC} $DISTRO_NAME"
    echo -e "${GREEN}✓ Distribución:${NC} $DISTRO_ID"
    echo -e "${GREEN}✓ Versión:${NC} $DISTRO_VERSION"
else
    echo -e "${RED}✗ No se pudo detectar la versión del sistema${NC}"
    exit 1
fi

# Validar distribución compatible
if [[ "$DISTRO_ID" != "ubuntu" && "$DISTRO_ID" != "debian" ]]; then
    echo -e "${YELLOW}⚠️  Distribución: $DISTRO_ID${NC}"
    echo -e "${YELLOW}   Este script está optimizado para Ubuntu y Debian${NC}"
fi

echo ""

# Verificar sintaxis del script principal
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
    echo -e "${YELLOW}⚠️  personalizarTerminal.sh no encontrado en directorio actual${NC}"
fi

echo ""

# Verificar comandos básicos requeridos
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

if [[ ${#missing_commands[@]} -gt 0 ]]; then
    echo ""
    echo -e "${YELLOW}Instalar comandos faltantes:${NC}"
    echo -e "${GREEN}sudo apt install -y ${missing_commands[*]}${NC}"
fi

echo ""

# Verificar disponibilidad de paquetes en repos
if [[ "$MODE" == "detallado" ]]; then
    echo -e "${CYAN}═══ Disponibilidad de Paquetes ═══${NC}"
    
    packages=("bat" "lsd" "build-essential" "zsh" "fontconfig")
    descriptions=("bat/batcat" "lsd" "build-essential" "zsh" "fontconfig")
    
    for i in "${!packages[@]}"; do
        pkg="${packages[$i]}"
        desc="${descriptions[$i]}"
        if apt-cache show "$pkg" &>/dev/null 2>&1; then
            version=$(apt-cache policy "$pkg" 2>/dev/null | grep "Candidate:" | awk '{print $2}')
            echo -e "${GREEN}✓${NC} $desc ${YELLOW}($version)${NC}"
        else
            echo -e "${RED}✗${NC} $desc ${YELLOW}(no en repos)${NC}"
        fi
    done
    
    echo ""
fi

# Determinar configuración recomendada según sistema
echo -e "${CYAN}═══ Configuración Recomendada ═══${NC}"

# lsd
if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "24.04" ]] || \
   [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" -ge "12" ]]; then
    echo -e "${GREEN}✓ lsd:${NC} Instalación desde repositorios APT"
else
    echo -e "${YELLOW}⚠ lsd:${NC} Instalación desde Snap/GitHub"
    echo -e "  ${BLUE}→${NC} sudo snap install lsd"
fi

# bat/batcat
if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "24.04" ]] || \
   [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" -ge "12" ]]; then
    echo -e "${GREEN}✓ bat:${NC} Comando disponible como 'bat'"
else
    echo -e "${YELLOW}⚠ bat:${NC} Comando disponible como 'batcat'"
    echo -e "  ${BLUE}→${NC} Alias automático creado por el script"
fi

# Neovim y GLIBC
glibc_version=$(ldd --version 2>/dev/null | head -n1 | grep -oP '\d+\.\d+' || echo "desconocida")

if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "22.04" ]] || \
   [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" == "11" ]]; then
    echo -e "${YELLOW}⚠ Neovim:${NC} Versión 0.9.5 (GLIBC $glibc_version)"
    echo -e "  ${BLUE}→${NC} Compatible con sistemas GLIBC 2.31-2.35"
else
    echo -e "${GREEN}✓ Neovim:${NC} Versión 0.11.4 (GLIBC $glibc_version)"
    echo -e "  ${BLUE}→${NC} Última versión disponible"
fi

echo ""

# Advertencias específicas por versión
if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "22.04" ]] || \
   [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" == "11" ]]; then
    echo -e "${CYAN}═══ Notas para $DISTRO_NAME ═══${NC}"
    echo -e "${YELLOW}ℹ${NC}  Este sistema requiere adaptaciones automáticas"
    echo -e "${YELLOW}ℹ${NC}  El script detectará y aplicará las configuraciones apropiadas"
    echo ""
    
    if [[ "$MODE" == "detallado" ]]; then
        echo -e "${BLUE}Adaptaciones que se aplicarán:${NC}"
        echo -e "  1. lsd → Instalación vía Snap o descarga directa"
        echo -e "  2. batcat → Creación de aliases para 'bat'"
        echo -e "  3. Neovim 0.9.5 → Compatible con GLIBC $glibc_version"
        echo -e "  4. rsync → Verificación e instalación si falta"
        echo ""
    fi
fi

# Resumen final
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [[ ${#missing_commands[@]} -eq 0 ]]; then
    echo -e "${GREEN}✅ Sistema compatible - Listo para ejecutar${NC}"
    echo ""
    echo -e "${CYAN}Ejecutar:${NC} bash personalizarTerminal.sh"
else
    echo -e "${YELLOW}⚠️  Instalar comandos faltantes antes de continuar${NC}"
    echo ""
    echo -e "${CYAN}Comando:${NC} sudo apt install -y ${missing_commands[*]}"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Mostrar ayuda
if [[ "$MODE" == "simple" ]]; then
    echo -e "${CYAN}Tip:${NC} Ejecuta '$0 detallado' para ver más información"
fi
