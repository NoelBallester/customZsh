#!/usr/bin/env bash

# Script para verificar compatibilidad entre Ubuntu 24.04 y 22.04

set -eo pipefail

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Verificación de compatibilidad Ubuntu 24.04 vs 22.04${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Detectar versión de Ubuntu
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo -e "${GREEN}Sistema detectado:${NC} $PRETTY_NAME"
    echo -e "${GREEN}Versión:${NC} $VERSION_ID"
    echo ""
else
    echo -e "${RED}No se pudo detectar la versión del sistema${NC}"
    exit 1
fi

UBUNTU_VERSION="$VERSION_ID"

echo -e "${BLUE}═══ Verificando disponibilidad de paquetes ═══${NC}"
echo ""

# Verificar paquetes críticos
packages=("bat" "lsd" "build-essential" "zsh" "git" "curl" "wget" "unzip" "fontconfig" "rsync")
descriptions=("batcat (visualizador de archivos)" "lsd (reemplazo moderno de ls)" "Compiladores y herramientas" "Z Shell" "Control de versiones" "Herramienta de descarga" "Herramienta de descarga" "Descompresor" "Gestión de fuentes" "Sincronización de archivos")

for i in "${!packages[@]}"; do
    pkg="${packages[$i]}"
    desc="${descriptions[$i]}"
    if apt-cache show "$pkg" &>/dev/null 2>&1; then
        version=$(apt-cache policy "$pkg" 2>/dev/null | grep "Candidate:" | awk '{print $2}')
        echo -e "  ${GREEN}✓${NC} $pkg - $desc"
        if [[ -n "$version" && "$version" != "(none)" ]]; then
            echo -e "    Versión: ${YELLOW}$version${NC}"
        fi
    else
        echo -e "  ${RED}✗${NC} $pkg - $desc"
        echo -e "    ${RED}NO DISPONIBLE en repositorios${NC}"
    fi
done

echo ""
echo -e "${BLUE}═══ Problemas conocidos en Ubuntu 22.04 ═══${NC}"
echo ""

if [[ "$UBUNTU_VERSION" == "22.04" ]]; then
    echo -e "${YELLOW}⚠️  INCOMPATIBILIDADES DETECTADAS:${NC}"
    echo ""
    
    # 1. LSD no disponible en repos oficiales de 22.04
    if ! apt-cache show lsd &>/dev/null; then
        echo -e "${RED}1. lsd NO está en los repositorios oficiales de Ubuntu 22.04${NC}"
        echo -e "   ${YELLOW}Solución:${NC} Instalar desde releases de GitHub o usar snap/cargo"
        echo -e "   ${BLUE}Comando alternativo:${NC}"
        echo -e "   snap install lsd"
        echo -e "   # O bien:"
        echo -e "   cargo install lsd"
        echo ""
    fi
    
    # 2. Batcat puede tener nombre diferente
    if command -v batcat &>/dev/null; then
        echo -e "${GREEN}2. batcat está instalado${NC}"
    elif command -v bat &>/dev/null; then
        echo -e "${YELLOW}2. Se encontró 'bat' en lugar de 'batcat'${NC}"
        echo -e "   ${YELLOW}Solución:${NC} Crear alias: ln -s \$(which bat) ~/.local/bin/batcat"
    else
        echo -e "${YELLOW}2. batcat no está instalado${NC}"
        echo -e "   En Ubuntu 22.04, puede llamarse 'bat' en lugar de 'batcat'"
    fi
    echo ""
    
    # 3. Versión de Neovim
    echo -e "${YELLOW}3. Dependencias de Neovim 0.11.4${NC}"
    echo -e "   Ubuntu 22.04 requiere GLIBC >= 2.35"
    if ldd --version | head -n1 | grep -oP '\d+\.\d+' | awk '{if ($1 >= 2.35) exit 0; else exit 1}'; then
        echo -e "   ${GREEN}✓ GLIBC compatible${NC}"
    else
        glibc_ver=$(ldd --version | head -n1 | grep -oP '\d+\.\d+')
        echo -e "   ${RED}✗ GLIBC $glibc_ver < 2.35 - Neovim 0.11.4 puede NO funcionar${NC}"
        echo -e "   ${YELLOW}Solución:${NC} Usar Neovim 0.9.x en su lugar"
    fi
    echo ""
    
    # 4. rsync
    if ! command -v rsync &>/dev/null; then
        echo -e "${RED}4. rsync NO está instalado${NC}"
        echo -e "   ${YELLOW}Solución:${NC} sudo apt install rsync"
        echo ""
    fi
    
    echo -e "${BLUE}═══ Recomendaciones para Ubuntu 22.04 ═══${NC}"
    echo ""
    echo -e "1. Instalar lsd desde snap o cargo:"
    echo -e "   ${GREEN}sudo snap install lsd${NC}"
    echo ""
    echo -e "2. Verificar versión de batcat:"
    echo -e "   ${GREEN}apt-cache policy bat${NC}"
    echo ""
    echo -e "3. Usar Neovim 0.9.x si GLIBC < 2.35:"
    echo -e "   ${GREEN}curl -L https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz${NC}"
    echo ""
    echo -e "4. Instalar rsync si no está presente:"
    echo -e "   ${GREEN}sudo apt install rsync${NC}"
    echo ""
    
elif [[ "$UBUNTU_VERSION" == "24.04" ]]; then
    echo -e "${GREEN}✓ Ubuntu 24.04 - Todos los paquetes deberían estar disponibles${NC}"
    echo ""
    echo -e "  • lsd está en los repositorios oficiales"
    echo -e "  • batcat está disponible como 'bat'"
    echo -e "  • GLIBC 2.39+ soporta Neovim 0.11.4"
    echo -e "  • Todas las dependencias están actualizadas"
    echo ""
else
    echo -e "${YELLOW}⚠️  Versión de Ubuntu no reconocida: $UBUNTU_VERSION${NC}"
    echo -e "Este script está optimizado para Ubuntu 24.04 y 22.04"
fi

echo ""
echo -e "${BLUE}═══ Verificando comandos necesarios ═══${NC}"
echo ""

commands=("git" "curl" "wget" "unzip" "fc-cache" "rsync")
for cmd in "${commands[@]}"; do
    if command -v "$cmd" &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $cmd"
    else
        echo -e "  ${RED}✗${NC} $cmd ${YELLOW}(no instalado)${NC}"
    fi
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Verificación completada${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
