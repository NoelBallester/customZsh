#!/usr/bin/env bash

set -euo pipefail

# Colores
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
ZSHRC="$HOME/.zshrc"
LOG="$HOME/.zsh_installer.log"

# Función para preguntar al usuario (sí/no)
preguntar() {
    local mensaje="$1"
    read -rp "$(echo -e "${YELLOW}${mensaje} [s/N]: ${NC}")" respuesta
    [[ "$respuesta" =~ ^[sS]$ ]]
}

# Verificar si zsh está instalado
if ! command -v zsh &>/dev/null; then
    echo -e "${YELLOW}Zsh no está instalado. Instalando...${NC}"
    sudo apt update && sudo apt install -y zsh
else
    echo -e "${GREEN}Zsh ya está instalado.${NC}"
fi

# Cambiar shell por defecto del usuario actual
if preguntar "¿Quieres usar Zsh como tu shell por defecto?"; then
    ZSH_PATH="$(command -v zsh)"
    CURRENT_USER="$(whoami)"
    if [[ "$SHELL" != "$ZSH_PATH" ]]; then
        echo -e "${GREEN}Cambiando shell por defecto a Zsh para el usuario ${CURRENT_USER}...${NC}"
        chsh -s "$ZSH_PATH" "$CURRENT_USER" || echo -e "${YELLOW}No se pudo cambiar el shell. Ejecuta 'chsh -s $ZSH_PATH $CURRENT_USER' manualmente.${NC}"
    else
        echo -e "${YELLOW}Zsh ya es tu shell por defecto.${NC}"
    fi
fi

# Instalar Oh My Zsh
if [[ ! -d "$ZSH" ]] && preguntar "¿Quieres instalar Oh My Zsh?"; then
    echo -e "${GREEN}Instalando Oh My Zsh...${NC}"
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Oh My Zsh instalado" >> "$LOG"
fi

# Plugins de Oh My Zsh
declare -A plugins_git=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
)

plugins_activados=(git sudo)

if preguntar "¿Quieres instalar plugins adicionales de Oh My Zsh?"; then
    for plugin in "${!plugins_git[@]}"; do
        destino="${ZSH_CUSTOM}/plugins/${plugin}"
        if [[ ! -d "$destino" ]]; then
            echo -e "${GREEN}Instalando ${plugin}...${NC}"
            git clone --depth=1 "${plugins_git[$plugin]}" "$destino"
            echo "${plugin} instalado" >> "$LOG"
        fi
        plugins_activados+=("$plugin")
    done
fi

# Instalar Powerlevel10k
usar_p10k=false
if preguntar "¿Quieres instalar Powerlevel10k como tema para Zsh?"; then
    usar_p10k=true
    if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
        echo -e "${GREEN}Instalando Powerlevel10k...${NC}"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        echo "Powerlevel10k instalado" >> "$LOG"
    fi
fi

# Instalar batcat
usar_batcat=false
if preguntar "¿Quieres usar batcat como reemplazo de cat?"; then
    usar_batcat=true
    if ! command -v batcat &>/dev/null; then
        echo -e "${GREEN}Instalando batcat...${NC}"
        sudo apt install -y bat
    fi
fi

# Instalar lsd
usar_lsd=false
if preguntar "¿Quieres usar lsd como reemplazo de ls?"; then
    usar_lsd=true
    if ! command -v lsd &>/dev/null; then
        echo -e "${GREEN}Instalando lsd...${NC}"
        sudo apt install -y lsd
    fi

    # Instalar Hack Nerd Fonts si no están
    if ! fc-list | grep -qi "Hack Nerd Font"; then
        echo -e "${GREEN}Instalando Hack Nerd Fonts para compatibilidad con íconos...${NC}"
        mkdir -p "$HOME/.local/share/fonts"
        wget -qO /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
        unzip -o /tmp/Hack.zip -d "$HOME/.local/share/fonts/"
        fc-cache -fv
        echo "Hack Nerd Font instalada" >> "$LOG"
    fi
fi

# Instalar Neovim + NvChad
if preguntar "¿Quieres instalar Neovim (última versión) junto con NvChad?"; then
    instalar_nvim=true

    if command -v nvim &>/dev/null; then
        version_actual=$(nvim --version | head -n1 | awk '{print $2}')
        if [[ "$(printf '%s\n' "0.9" "$version_actual" | sort -V | head -n1)" == "0.9" ]]; then
            echo -e "${GREEN}Neovim ya está en versión $version_actual (compatible con NvChad).${NC}"
            instalar_nvim=false
        else
            echo -e "${YELLOW}Versión actual de Neovim: $version_actual. Se requiere ≥ 0.9 para NvChad.${NC}"
        fi
    fi

    if $instalar_nvim; then
        echo -e "${GREEN}Instalando Neovim v0.11.4 desde GitHub en ~/.local/nvim...${NC}"
        mkdir -p "$HOME/.local/nvim"
        curl -L https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz -o "$HOME/nvim.tar.gz"
        if ! file "$HOME/nvim.tar.gz" | grep -q 'gzip compressed data'; then
            echo -e "${YELLOW}El archivo descargado no es un .tar.gz válido. Abortando instalación.${NC}"
            exit 1
        fi
        tar -xzf "$HOME/nvim.tar.gz" -C "$HOME"
        if [[ ! -f "$HOME/nvim-linux-x86_64/bin/nvim" ]]; then
            echo -e "${YELLOW}La extracción falló o el binario no está presente. Abortando.${NC}"
            exit 1
        fi
        rsync -a "$HOME/nvim-linux-x86_64/" "$HOME/.local/nvim/"
        rm -rf "$HOME/nvim-linux-x86_64" "$HOME/nvim.tar.gz"
        echo "Neovim instalado en ~/.local/nvim" >> "$LOG"
        export PATH="$HOME/.local/nvim/bin:$PATH"
    fi

    if ! grep -q "$HOME/.local/nvim/bin" "$ZSHRC"; then
        echo 'export PATH="$HOME/.local/nvim/bin:$PATH"' >> "$ZSHRC"
        echo "PATH actualizado con Neovim local" >> "$LOG"
    fi

    if [[ -d "$HOME/.config/nvim" ]]; then
        echo -e "${YELLOW}Respaldo de configuración previa de Neovim...${NC}"
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
    fi

    echo -e "${GREEN}Instalando NvChad...${NC}"
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    if [[ ! -f "$HOME/.config/nvim/init.lua" ]]; then
        echo -e "${YELLOW}NvChad no se clonó correctamente. Reintentando...${NC}"
        rm -rf "$HOME/.config/nvim"
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    fi
    echo "NvChad instalado en ~/.config/nvim" >> "$LOG"
    echo -e "${GREEN}NvChad listo. Ejecuta 'nvim' para finalizar la instalación interactiva.${NC}"
fi

# Añadir configuración a .zshrc sin sobrescribir
{
  echo ""
  echo "# Configuración generada por el instalador"
  echo "export ZSH=\"$HOME/.oh-my-zsh\""
  echo "ZSH_THEME=\"${usar_p10k:+powerlevel10k/powerlevel10k}\""
  echo "plugins=(${plugins_activados[@]})"
  echo "source \$ZSH/oh-my-zsh.sh"
} >> "$ZSHRC"

# Añadir Powerlevel10k si se usa
if $usar_p10k; then
    echo '[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"' >> "$ZSHRC"
fi

# Añadir aliases si se usan batcat o lsd
{
  echo ""
  echo "# Aliases personalizados"
  if $usar_batcat; then
    echo "alias cat='batcat'"
    echo "alias catn='cat'"
    echo "alias catnl='batcat --paging=never'"
  fi
  if $usar_lsd; then
    echo "alias ll='lsd -lh --group-dirs=first'"
    echo "alias la='lsd -a --group-dirs=first'"
    echo "alias l='lsd --group-dirs=first'"
    echo "alias lla='lsd -lha --group-dirs=first'"
    echo "alias ls='lsd --group-dirs=first'"
  fi
} >> "$ZSHRC"
rm -rf $HOME/.config/nvim
git clone https://github.com/NvChad/starter ~/.config/nvim
# Mensaje final
echo -e "${GREEN}✅ Instalación completada. Reinicia la terminal o ejecuta:${NC}"
echo -e "${GREEN}source ~/.zshrc${NC}"
echo -e "${YELLOW}ℹ️ Si el cambio de shell no surtió efecto, ejecuta manualmente:${NC}"
echo -e "${GREEN}chsh -s $(command -v zsh) $(whoami)${NC}"
echo -e "${YELLOW}📦 Si instalaste Neovim + NvChad, ejecuta 'nvim' para completar la configuración inicial.${NC}"
