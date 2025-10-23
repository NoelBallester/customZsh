#!/usr/bin/env bash

set -euo pipefail

# Detectar si se ejecuta como root y avisar al usuario
if [[ $EUID -eq 0 ]]; then
    echo -e "\033[1;33m⚠️  ADVERTENCIA: Estás ejecutando este script como root\033[0m"
    echo ""
    echo "   Las configuraciones se instalarán en: /root"
    echo "   Si quieres configurar tu usuario normal, ejecuta sin sudo"
    echo ""
    read -rp "¿Deseas continuar e instalar para el usuario root? [s/N]: " confirm_root
    if [[ ! "$confirm_root" =~ ^[sS]$ ]]; then
        echo "Instalación cancelada."
        exit 0
    fi
    echo ""
fi

# Colores
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
ZSHRC="$HOME/.zshrc"
LOG="$HOME/.zsh_installer.log"

# Opciones de línea de comando
# --yes, -y : responder sí a todas las preguntas (modo no interactivo)
AUTO_YES=false
while [[ ${1:-} != "" ]]; do
    case "$1" in
        --yes|-y)
            AUTO_YES=true
            shift
            ;;
        --help|-h)
            cat <<'USAGE'
Uso: personalizarTerminal.sh [--yes]

Opciones:
    --yes, -y    Responder 'sí' a todas las preguntas (útil para automatizar)
    --help, -h   Mostrar esta ayuda
USAGE
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

# Detectar versión de Ubuntu/Debian
DISTRO_ID=""
DISTRO_VERSION=""
DISTRO_NAME=""

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID="$ID"
    DISTRO_VERSION="$VERSION_ID"
    DISTRO_NAME="$PRETTY_NAME"
    echo -e "${BLUE}Sistema detectado: $DISTRO_NAME${NC}"
    
    # Validar que sea Ubuntu o Debian
    if [[ "$DISTRO_ID" != "ubuntu" && "$DISTRO_ID" != "debian" ]]; then
        echo -e "${RED}⚠️  Este script está diseñado para Ubuntu y Debian.${NC}"
        echo -e "${YELLOW}Distribución detectada: $DISTRO_ID${NC}"
        if ! preguntar "¿Deseas continuar de todos modos?"; then
            exit 1
        fi
    fi
else
    echo -e "${RED}No se pudo detectar la versión del sistema${NC}"
    DISTRO_ID="unknown"
    DISTRO_VERSION="unknown"
fi

# Mantener compatibilidad con variable antigua
UBUNTU_VERSION="$DISTRO_VERSION"

# Función para preguntar al usuario (sí/no)
preguntar() {
    local mensaje="$1"
    # Si estamos en modo no interactivo, aceptar automáticamente
    if [[ "${AUTO_YES:-false}" == "true" ]]; then
        echo -e "${YELLOW}${mensaje} [s/N]: ${NC} s (auto)"
        return 0
    fi
    read -rp "$(echo -e "${YELLOW}${mensaje} [s/N]: ${NC}")" respuesta
    [[ "$respuesta" =~ ^[sS]$ ]]
}

# Verificar si zsh está instalado
if ! command -v zsh &>/dev/null; then
    echo -e "${YELLOW}Zsh no está instalado. Instalando...${NC}"
    sudo apt update && sudo apt upgrade -y && sudo apt install -y build-essential && sudo apt install -y zsh git curl
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
    if ! command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
        echo -e "${GREEN}Instalando batcat...${NC}"
        sudo apt install -y bat
        # En Ubuntu 22.04, el comando puede llamarse 'batcat', en 24.04 puede ser 'bat'
        if command -v bat &>/dev/null && ! command -v batcat &>/dev/null; then
            echo -e "${YELLOW}Creando alias batcat para comando bat...${NC}"
        fi
    fi
fi

# Instalar lsd
usar_lsd=false
if preguntar "¿Quieres usar lsd como reemplazo de ls?"; then
    usar_lsd=true
    if ! command -v lsd &>/dev/null; then
        # Ubuntu 24.04+ tiene lsd en repos
        if [[ "$DISTRO_ID" == "ubuntu" && ("$DISTRO_VERSION" == "24.04" || "$(printf '%s\n' "$DISTRO_VERSION" "24.04" | sort -V | head -n1)" == "24.04") ]]; then
            echo -e "${GREEN}Instalando lsd desde repositorios oficiales...${NC}"
            sudo apt install -y lsd
        # Debian 12+ (Bookworm) tiene lsd en repos
        elif [[ "$DISTRO_ID" == "debian" && ("$DISTRO_VERSION" == "12" || "$DISTRO_VERSION" -ge "12") ]]; then
            echo -e "${GREEN}Instalando lsd desde repositorios oficiales de Debian...${NC}"
            sudo apt install -y lsd
        else
            echo -e "${YELLOW}$DISTRO_NAME detectado. lsd no está en repositorios oficiales.${NC}"
            if command -v snap &>/dev/null; then
                echo -e "${GREEN}Instalando lsd desde Snap...${NC}"
                sudo snap install lsd
            else
                echo -e "${YELLOW}Snap no disponible. Descargando lsd desde GitHub...${NC}"
                LSD_VERSION="1.1.5"
                TEMP_LSD_FILE="/tmp/lsd_${USER}_$$.deb"
                
                if wget -q "https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd_${LSD_VERSION}_amd64.deb" -O "$TEMP_LSD_FILE"; then
                    sudo dpkg -i "$TEMP_LSD_FILE" || sudo apt-get install -f -y
                    rm -f "$TEMP_LSD_FILE"
                else
                    echo -e "${RED}Error al descargar lsd${NC}"
                    rm -f "$TEMP_LSD_FILE"
                fi
            fi
        fi
    fi

    # Instalar Hack Nerd Fonts si no están
    if ! fc-list | grep -qi "Hack Nerd Font"; then
        echo -e "${GREEN}Instalando Hack Nerd Fonts para compatibilidad con íconos...${NC}"
        mkdir -p "$HOME/.local/share/fonts"
        
        # Usar directorio temporal único para evitar conflictos
        TEMP_FONT_FILE="/tmp/Hack_${USER}_$$.zip"
        
        # Descargar fuente
        if wget -qO "$TEMP_FONT_FILE" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip; then
            # Descomprimir
            if unzip -o "$TEMP_FONT_FILE" -d "$HOME/.local/share/fonts/"; then
                fc-cache -fv
                echo "Hack Nerd Font instalada" >> "$LOG"
            else
                echo -e "${RED}Error al descomprimir la fuente${NC}"
            fi
            # Limpiar archivo temporal
            rm -f "$TEMP_FONT_FILE"
        else
            echo -e "${RED}Error al descargar Hack Nerd Font${NC}"
            rm -f "$TEMP_FONT_FILE"
        fi
    fi
fi

# Instalar Neovim + NvChad
if preguntar "¿Quieres instalar Neovim (última versión) junto con NvChad?"; then
    instalar_nvim=true

    # Seleccionar versión de Neovim según sistema y GLIBC
    if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "22.04" ]] || \
       [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" == "11" ]]; then
        # Ubuntu 22.04 y Debian 11 (Bullseye) tienen GLIBC 2.31-2.35
        NVIM_VERSION="v0.9.5"
        NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz"
        NVIM_DIR="nvim-linux64"
        echo -e "${YELLOW}$DISTRO_NAME detectado. Usando Neovim 0.9.5 (compatible con GLIBC 2.31-2.35)${NC}"
    else
        # Ubuntu 24.04+, Debian 12+ (Bookworm) tienen GLIBC 2.36+
        NVIM_VERSION="v0.11.4"
        NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz"
        NVIM_DIR="nvim-linux-x86_64"
        echo -e "${GREEN}Usando Neovim 0.11.4 (última versión)${NC}"
    fi

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
        echo -e "${GREEN}Instalando Neovim $NVIM_VERSION desde GitHub en ~/.local/nvim...${NC}"
        
        # Verificar e instalar rsync si no está
        if ! command -v rsync &>/dev/null; then
            echo -e "${YELLOW}rsync no está instalado. Instalando...${NC}"
            sudo apt install -y rsync
        fi
        
        mkdir -p "$HOME/.local/nvim"
        curl -L "$NVIM_URL" -o "$HOME/nvim.tar.gz"
        if ! file "$HOME/nvim.tar.gz" | grep -q 'gzip compressed data'; then
            echo -e "${RED}El archivo descargado no es un .tar.gz válido. Abortando instalación.${NC}"
            exit 1
        fi
        tar -xzf "$HOME/nvim.tar.gz" -C "$HOME"
        if [[ ! -f "$HOME/$NVIM_DIR/bin/nvim" ]]; then
            echo -e "${RED}La extracción falló o el binario no está presente. Abortando.${NC}"
            exit 1
        fi
        rsync -a "$HOME/$NVIM_DIR/" "$HOME/.local/nvim/"
        rm -rf "$HOME/${NVIM_DIR:?}" "$HOME/nvim.tar.gz"
        echo "Neovim $NVIM_VERSION instalado en ~/.local/nvim" >> "$LOG"
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

        echo -e "${GREEN}Instalando NvChad starter template...${NC}"
        git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1
        rm -rf ~/.config/nvim/.git
        echo "NvChad starter instalado en ~/.config/nvim" >> "$LOG"

        # Asegurar dependencias útiles de entorno (no críticas)
        if ! command -v rg &>/dev/null; then
            echo -e "${YELLOW}Instalando ripgrep (mejora la búsqueda en Telescope)...${NC}"
            sudo apt-get update -y >/dev/null 2>&1 || true
            sudo apt-get install -y ripgrep >/dev/null 2>&1 || true
        fi

        echo -e "${GREEN}Sincronizando plugins de NvChad (headless)...${NC}"
        # Instalar/actualizar plugins y esperar a que termine
        if ! nvim --headless \
                "+lua require('lazy').sync({ wait = true, show = false })" \
                "+qa"; then
            echo -e "${YELLOW}Reintentando sincronización de plugins...${NC}"
            nvim --headless "+Lazy! sync" +qa || true
        fi

        # Compilar/crear cachés de base46 para evitar errores en el primer arranque
        nvim --headless \
            "+lua do local ok, b = pcall(require, 'base46'); if ok and b.load_all_highlights then b.load_all_highlights() end end" \
            "+qa" || true

        echo -e "${GREEN}NvChad listo. Puedes ejecutar 'nvim' ahora mismo.${NC}"
fi

    # Activar búsqueda del historial con fzf en Ctrl+r
    if preguntar "¿Quieres activar búsqueda del historial con fzf (Ctrl+r) con vista previa?"; then
        usar_fzf_hist=true

        # Intentar instalar fzf vía APT si está disponible, si falla instalar localmente en ~/.fzf
        if ! command -v fzf &>/dev/null; then
            echo -e "${YELLOW}Instalando fzf...${NC}"
            if sudo apt-get update -y >/dev/null 2>&1 && sudo apt-get install -y fzf >/dev/null 2>&1; then
                echo "fzf instalado desde APT" >> "$LOG"
            else
                echo -e "${YELLOW}Instalación APT fallida o no disponible. Instalando fzf desde GitHub en ~/.fzf...${NC}"
                if [[ ! -d "$HOME/.fzf" ]]; then
                    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" >> "$LOG" 2>&1 || true
                fi
                # Ejecutar instalador no interactivo para generar keybindings zsh/completion
                if [[ -f "$HOME/.fzf/install" ]]; then
                    yes | "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish --zsh >> "$LOG" 2>&1 || true
                fi
            fi
        else
            echo -e "${GREEN}fzf ya está instalado en el sistema.${NC}"
        fi

        # Construir comando de previsualización (con bat si está)
        PREVIEW_CMD='print -r -- {}'
        if command -v bat &>/dev/null; then
            PREVIEW_CMD="bat --paging=never --style=numbers --color=always {}"
        elif command -v batcat &>/dev/null; then
            PREVIEW_CMD="batcat --paging=never --style=numbers --color=always {}"
        fi

        # Añadir configuración a .zshrc de forma idempotente
        if ! grep -q "# FZF: ctrl-r" "$ZSHRC"; then
            {
                echo ""
                echo "# FZF: ctrl-r búsqueda de historial con vista previa"
                echo "export FZF_DEFAULT_OPTS=\"--height 60% --layout=reverse --border --info=inline --marker='»' --pointer='▶' --prompt='❯ ' --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7,fg+:#e0def4,bg+:#2a2b3a,hl+:#7dcfff,info:#7aa2f7,prompt:#7dcfff,pointer:#f7768e,marker:#e0af68,border:#3b4261\""
                echo "export FZF_CTRL_R_OPTS=\"--preview '$PREVIEW_CMD' --preview-window=down,3,wrap --bind ctrl-/:toggle-preview --exact\""
                echo ""
                echo "# Keybindings de fzf"
                echo "if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then"
                echo "  source /usr/share/doc/fzf/examples/key-bindings.zsh"
                echo "  [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh"
                echo "elif [ -f \"$HOME/.fzf.zsh\" ]; then"
                echo "  source \"$HOME/.fzf.zsh\""
                echo "fi"
                echo ""
                echo "# Fallback explícito del atajo (por si no se cargan los keybindings del sistema)"
                echo "if type fzf-history-widget >/dev/null 2>&1; then"
                echo "  bindkey '^R' fzf-history-widget"
                echo "fi"
            } >> "$ZSHRC"
            echo "FZF (Ctrl+r) configurado en $ZSHRC" >> "$LOG"
        else
            echo -e "${YELLOW}Bloque FZF ya presente en $ZSHRC — omitiendo duplicado${NC}"
        fi

        # Mejorar el historial de Zsh (tamaño grande y opciones útiles)
        if ! grep -q "# Historial Zsh (ampliado)" "$ZSHRC"; then
            {
                echo ""
                echo "# Historial Zsh (ampliado)"
                echo "export HISTFILE=\"$HOME/.zsh_history\""
                echo "export HISTSIZE=200000"
                echo "export SAVEHIST=200000"
                echo "setopt HIST_IGNORE_DUPS SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY HIST_FIND_NO_DUPS HIST_IGNORE_SPACE"
            } >> "$ZSHRC"
        fi

        # Si fzf no generó ~/.fzf.zsh pero existe la instalación local, crear un pequeño wrapper para sourcearlo
        if [[ -d "$HOME/.fzf" && ! -f "$HOME/.fzf.zsh" ]]; then
            # Ejecutar instalador para generar el archivo zsh si es posible
            if [[ -f "$HOME/.fzf/install" ]]; then
                yes | "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish --zsh >> "$LOG" 2>&1 || true
            fi
        fi
    fi

# Añadir configuración a .zshrc sin sobrescribir
{
  echo ""
  echo "# Configuración generada por el instalador"
  echo "export ZSH=\"\$HOME/.oh-my-zsh\""
  if $usar_p10k; then
    echo "ZSH_THEME=\"powerlevel10k/powerlevel10k\""
  else
    echo "ZSH_THEME=\"robbyrussell\""
  fi
  echo "plugins=(${plugins_activados[*]})"
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
    # Detectar si el comando es 'bat' o 'batcat'
    if command -v batcat &>/dev/null; then
      echo "alias cat='batcat'"
      echo "alias catn='cat'"
      echo "alias catnl='batcat --paging=never'"
    elif command -v bat &>/dev/null; then
      echo "alias cat='bat'"
      echo "alias batcat='bat'"
      echo "alias catn='cat'"
      echo "alias catnl='bat --paging=never'"
    fi
  fi
  if $usar_lsd; then
    echo "alias ll='lsd -lh --group-dirs=first'"
    echo "alias la='lsd -a --group-dirs=first'"
    echo "alias l='lsd --group-dirs=first'"
    echo "alias lla='lsd -lha --group-dirs=first'"
    echo "alias ls='lsd --group-dirs=first'"
  fi
} >> "$ZSHRC"

# Mensaje final
echo -e "${GREEN}✅ Configuración completada exitosamente.${NC}"
echo -e "${YELLOW}📝 Ejecuta 'chsh -s $(command -v zsh) $(whoami)' si aún no has cambiado tu shell por defecto.${NC}"
echo -e "${YELLOW}📦 Si instalaste Neovim + NvChad, ejecuta 'nvim' para completar la configuración inicial.${NC}"
echo -e "${GREEN}🔄 Reinicia tu terminal o ejecuta 'source ~/.zshrc' para aplicar los cambios.${NC}"
