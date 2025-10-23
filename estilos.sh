#!/usr/bin/env bash

# Script para personalizar el estilo de la terminal
# Permite cambiar el tema de Powerlevel10k y las fuentes

set -euo pipefail

# Colores
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m"

# Directorio de estilos P10k
P10K_STYLES_DIR="$(dirname "$0")/p10k-styles"
P10K_CONFIG_FILE="$HOME/.p10k.zsh"

# Función para mostrar el menú principal
mostrar_menu_principal() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}   🎨 Menú de Estilos de Terminal 🎨${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}1)${NC} Cambiar estilo de Powerlevel10k"
    echo -e "${CYAN}2)${NC} Instalar una nueva Nerd Font"
    echo -e "${CYAN}3)${NC} Cambiar tema de NvChad"
    echo -e "${CYAN}4)${NC} Salir"
    echo ""
}

# Directorio de NvChad
CHADRC_FILE="$HOME/.config/nvim/lua/custom/chadrc.lua"

# Función para cambiar el estilo de Powerlevel10k
cambiar_estilo_p10k() {
    echo -e "${YELLOW}Selecciona un estilo para Powerlevel10k:${NC}"
    
    # Leer estilos disponibles del directorio
    local estilos=()
    for f in "$P10K_STYLES_DIR"/*.p10k.zsh; do
        estilos+=("$(basename "$f" .p10k.zsh)")
    done

    select estilo in "${estilos[@]}"; do
        if [[ -n "$estilo" ]]; then
            local origen="$P10K_STYLES_DIR/$estilo.p10k.zsh"
            echo -e "${GREEN}Aplicando estilo '$estilo'...${NC}"
            
            # Hacer una copia de seguridad del .p10k.zsh actual
            if [[ -f "$P10K_CONFIG_FILE" ]]; then
                cp "$P10K_CONFIG_FILE" "${P10K_CONFIG_FILE}.backup.$(date +%s)"
                echo "Copia de seguridad creada en ${P10K_CONFIG_FILE}.backup"
            fi
            
            # Copiar el nuevo estilo
            cp "$origen" "$P10K_CONFIG_FILE"
            
            echo -e "${GREEN}✅ Estilo aplicado. Reinicia tu terminal o ejecuta 'source ~/.zshrc'${NC}"
            break
        else
            echo -e "${RED}Opción no válida. Inténtalo de nuevo.${NC}"
        fi
    done
}

# Función para instalar fuentes
instalar_fuentes() {
    echo -e "${YELLOW}Selecciona una Nerd Font para instalar:${NC}"
    
    declare -A fuentes=(
        ["FiraCode"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
        ["JetBrainsMono"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        ["Meslo"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
        ["UbuntuMono"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip"
        ["Hack"]="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
    )

    select fuente in "${!fuentes[@]}"; do
        if [[ -n "$fuente" ]]; then
            local url="${fuentes[$fuente]}"
            echo -e "${GREEN}Instalando ${fuente} Nerd Font...${NC}"
            
            local FONT_DIR="$HOME/.local/share/fonts"
            mkdir -p "$FONT_DIR"
            
            local TEMP_FONT_FILE="/tmp/${fuente}_${USER}_$$.zip"
            
            echo "Descargando desde $url..."
            if wget -qO "$TEMP_FONT_FILE" "$url"; then
                echo "Descomprimiendo en $FONT_DIR..."
                if unzip -o "$TEMP_FONT_FILE" -d "$FONT_DIR/"; then
                    echo "Actualizando caché de fuentes..."
                    fc-cache -fv
                    echo -e "${GREEN}✅ ${fuente} Nerd Font instalada.${NC}"
                    echo "   Recuerda configurar tu terminal para usar la nueva fuente."
                else
                    echo -e "${RED}Error al descomprimir la fuente.${NC}"
                fi
                rm -f "$TEMP_FONT_FILE"
            else
                echo -e "${RED}Error al descargar la fuente.${NC}"
                rm -f "$TEMP_FONT_FILE"
            fi
            break
        else
            echo -e "${RED}Opción no válida. Inténtalo de nuevo.${NC}"
        fi
    done
}

# Función para cambiar el tema de NvChad
cambiar_tema_nvchad() {
    echo -e "${YELLOW}Selecciona un tema para NvChad:${NC}"

    local temas=("onedark" "gruvbox" "dracula" "nord" "solarized-dark" "tokyonight" "catppuccin")

    select tema in "${temas[@]}"; do
        if [[ -n "$tema" ]]; then
            echo -e "${GREEN}Aplicando tema '$tema' a NvChad...${NC}"

            # Crear el directorio si no existe
            mkdir -p "$(dirname "$CHADRC_FILE")"

            # Comprobar si el fichero chadrc.lua existe
            if [[ -f "$CHADRC_FILE" ]]; then
                # Si el fichero existe, reemplazar la línea del tema
                # Usamos sed con un delimitador diferente para evitar problemas con las rutas
                if grep -q "M.ui.theme" "$CHADRC_FILE"; then
                    sed -i "s|M.ui.theme = .*|M.ui.theme = '$tema',|" "$CHADRC_FILE"
                else
                    # Si la línea no existe, la añadimos dentro de M.ui
                    if grep -q "M.ui = {" "$CHADRC_FILE"; then
                        sed -i "/M.ui = {/a \ \ theme = '$tema'," "$CHADRC_FILE"
                    else
                        # Si ni M.ui existe, lo añadimos
                        echo -e "\n-- Custom UI settings\nM.ui = {\n  theme = '$tema',\n}" >> "$CHADRC_FILE"
                    fi
                fi
            else
                # Si el fichero no existe, lo creamos con el contenido necesario
                cat > "$CHADRC_FILE" <<-EOF
-- chadrc.lua: Personaliza la configuración de NvChad

local M = {}

-- Ruta al fichero de configuración base de NvChad
M.base = "nvconfig/chadrc"

-- Configuración de la UI
M.ui = {
  theme = '$tema', -- Temas disponibles: onedark, gruvbox, dracula, etc.
}

-- Para anular plugins, consulta la documentación de NvChad
-- M.plugins = "custom.plugins"

return M
EOF
            fi

            echo -e "${GREEN}✅ Tema '$tema' aplicado. Inicia Neovim para ver los cambios.${NC}"
            break
        else
            echo -e "${RED}Opción no válida. Inténtalo de nuevo.${NC}"
        fi
    done
}

# Bucle principal del script
while true; do
    mostrar_menu_principal
    read -rp "Elige una opción: " opcion
    
    case "$opcion" in
        1)
            cambiar_estilo_p10k
            ;;
        2)
            instalar_fuentes
            ;;
        3)
            cambiar_tema_nvchad
            ;;
        4)
            echo "Saliendo..."
            break
            ;;
        *)
            echo -e "${RED}Opción no válida. Inténtalo de nuevo.${NC}"
            ;;
    esac
    echo ""
done
