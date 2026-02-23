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

# =========================================================================
# FUNCIONES PRINCIPALES (Desinstalar, Menú, Paquetes)
# =========================================================================

desinstalar() {
    echo -e "${RED}Iniciando desinstalación de los componentes...${NC}"
    rm -rf "$HOME/.oh-my-zsh"
    rm -rf "$HOME/.local/nvim"
    rm -rf "$HOME/.config/nvim"
    rm -rf "$HOME/.fzf"
    
    if [[ -f "$HOME/.zshrc.pre-oh-my-zsh" ]]; then
        echo -e "${YELLOW}Restaurando ~/.zshrc original...${NC}"
        mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
    else
        echo -e "${YELLOW}No se encontró backup de ~/.zshrc. Se mantendrá el actual.${NC}"
    fi

    if command -v bash &>/dev/null; then
        echo -e "${YELLOW}Cambiando shell por defecto a bash...${NC}"
        chsh -s "$(command -v bash)" "$(whoami)" || true
    fi
    
    echo -e "${GREEN}Desinstalación completada. Por favor, cierra sesión o reinicia tu terminal.${NC}"
    exit 0
}

mostrar_menu() {
    clear
    echo -e "${BLUE}======================================================${NC}"
    echo -e "${GREEN}        🚀 customZsh - Gestor de Instalación        ${NC}"
    echo -e "${BLUE}======================================================${NC}"
    echo -e " Selecciona qué deseas hacer:"
    echo ""
    echo -e "   ${YELLOW}1)${NC} Instalación Interactiva (Preguntar paso a paso)"
    echo -e "   ${YELLOW}2)${NC} Instalación Automática (Aceptar todo por defecto)"
    echo -e "   ${YELLOW}3)${NC} Desinstalar y limpiar el sistema"
    
    if [[ -f "./verificar_sistema.sh" ]]; then
        echo -e "   ${YELLOW}4)${NC} Verificar compatibilidad del sistema"
        echo -e "   ${YELLOW}5)${NC} Salir"
        echo -e "${BLUE}======================================================${NC}"
        echo ""
        read -rp "👉 Elige una opción [1-5]: " opcion_menu
    else
        echo -e "   ${YELLOW}4)${NC} Salir"
        echo -e "${BLUE}======================================================${NC}"
        echo ""
        read -rp "👉 Elige una opción [1-4]: " opcion_menu
    fi

    case $opcion_menu in
        1)
            AUTO_YES=false
            echo -e "\n${GREEN}Iniciando instalación interactiva...${NC}\n"
            ;;
        2)
            AUTO_YES=true
            echo -e "\n${YELLOW}Iniciando instalación automática desatendida...${NC}\n"
            ;;
        3)
            echo ""
            desinstalar
            ;;
        4)
            if [[ -f "./verificar_sistema.sh" ]]; then
                echo -e "\n${BLUE}Ejecutando verificación del sistema...${NC}\n"
                bash ./verificar_sistema.sh
                echo ""
                read -rp "Presiona Enter para volver al menú..."
                mostrar_menu
            else
                echo -e "\n${GREEN}¡Hasta pronto!${NC}"
                exit 0
            fi
            ;;
        5)
            if [[ -f "./verificar_sistema.sh" ]]; then
                echo -e "\n${GREEN}¡Hasta pronto!${NC}"
                exit 0
            else
                echo -e "\n${RED}❌ Opción no válida. Inténtalo de nuevo.${NC}"
                sleep 1.5
                mostrar_menu
            fi
            ;;
        *)
            echo -e "\n${RED}❌ Opción no válida. Inténtalo de nuevo.${NC}"
            sleep 1.5
            mostrar_menu
            ;;
    esac
}

instalar_paquete() {
    local paquetes=("$@")
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y "${paquetes[@]}"
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y "${paquetes[@]}"
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm "${paquetes[@]}"
    else
        echo -e "${RED}⚠️ Gestor de paquetes no soportado. Instala manualmente: ${paquetes[*]}${NC}"
    fi
}

# =========================================================================
# PROCESAR ARGUMENTOS O MOSTRAR MENÚ
# =========================================================================

AUTO_YES=false

if [[ $# -eq 0 ]]; then
    mostrar_menu
else
    while [[ ${1:-} != "" ]]; do
        case "$1" in
            --yes|-y)
                AUTO_YES=true
                shift
                ;;
            --uninstall)
                desinstalar
                ;;
            --help|-h)
                cat <<'USAGE'
Uso: personalizarTerminal.sh [OPCIONES]

Opciones:
    --yes, -y    Responder 'sí' a todas las preguntas (modo no interactivo)
    --uninstall  Eliminar configuraciones, Oh My Zsh, Neovim y restaurar shell
    --help, -h   Mostrar esta ayuda
USAGE
                exit 0
                ;;
            *)
                echo -e "${RED}Opción desconocida: $1${NC}"
                exit 1
                ;;
        esac
    done
fi

# =========================================================================
# INICIO DE LA INSTALACIÓN
# =========================================================================

DISTRO_ID=""
DISTRO_VERSION=""
DISTRO_NAME=""

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID="$ID"
    DISTRO_VERSION="$VERSION_ID"
    DISTRO_NAME="$PRETTY_NAME"
    echo -e "${BLUE}Sistema detectado: $DISTRO_NAME${NC}"
    
    if [[ "$DISTRO_ID" != "ubuntu" && "$DISTRO_ID" != "debian" ]]; then
        echo -e "${YELLOW}⚠️ Este script está optimizado para Ubuntu/Debian, pero intentará usar tu gestor de paquetes.${NC}"
    fi
else
    echo -e "${RED}No se pudo detectar la versión del sistema${NC}"
    DISTRO_ID="unknown"
    DISTRO_VERSION="unknown"
fi

preguntar() {
    local mensaje="$1"
    if [[ "${AUTO_YES:-false}" == "true" ]]; then
        echo -e "${YELLOW}${mensaje} [s/N]: ${NC} s (auto)"
        return 0
    fi
    read -rp "$(echo -e "${YELLOW}${mensaje} [s/N]: ${NC}")" respuesta
    [[ "$respuesta" =~ ^[sS]$ ]]
}

echo -e "${YELLOW}Verificando dependencias base del sistema...${NC}"
if command -v apt-get &>/dev/null; then
    sudo apt-get update -y >/dev/null 2>&1 || true
fi
instalar_paquete zsh git curl wget unzip file >/dev/null 2>&1 || true

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

if [[ ! -d "$ZSH" ]] && preguntar "¿Quieres instalar Oh My Zsh?"; then
    echo -e "${GREEN}Instalando Oh My Zsh...${NC}"
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Oh My Zsh instalado" >> "$LOG"
fi

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

usar_p10k=false
if preguntar "¿Quieres instalar Powerlevel10k como tema para Zsh?"; then
    usar_p10k=true
    if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
        echo -e "${GREEN}Instalando Powerlevel10k...${NC}"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        echo "Powerlevel10k instalado" >> "$LOG"
    fi
fi

usar_batcat=false
if preguntar "¿Quieres usar bat como reemplazo moderno de cat?"; then
    usar_batcat=true
    if ! command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
        echo -e "${GREEN}Instalando bat...${NC}"
        instalar_paquete bat
    fi
fi

usar_lsd=false
if preguntar "¿Quieres usar lsd como reemplazo de ls?"; then
    usar_lsd=true
    if ! command -v lsd &>/dev/null; then
        if [[ "$DISTRO_ID" == "ubuntu" && ("$DISTRO_VERSION" == "24.04" || "$(printf '%s\n' "$DISTRO_VERSION" "24.04" | sort -V | head -n1)" == "24.04") ]] || \
           [[ "$DISTRO_ID" == "debian" && ("$DISTRO_VERSION" == "12" || "$DISTRO_VERSION" -ge "12") ]] || \
           [[ "$DISTRO_ID" != "ubuntu" && "$DISTRO_ID" != "debian" ]]; then
            echo -e "${GREEN}Instalando lsd desde repositorios...${NC}"
            instalar_paquete lsd
        else
            echo -e "${YELLOW}Versión antigua detectada. Descargando lsd desde GitHub...${NC}"
            LSD_VERSION="1.1.5"
            TEMP_LSD_FILE="/tmp/lsd_${USER}_$$.deb"
            if wget -q "https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd_${LSD_VERSION}_amd64.deb" -O "$TEMP_LSD_FILE"; then
                sudo dpkg -i "$TEMP_LSD_FILE" || sudo apt-get install -f -y
                rm -f "$TEMP_LSD_FILE"
            fi
        fi
    fi

    if ! fc-list | grep -qi "Hack Nerd Font"; then
        echo -e "${GREEN}Instalando Hack Nerd Fonts para compatibilidad con íconos...${NC}"
        mkdir -p "$HOME/.local/share/fonts"
        TEMP_FONT_FILE="/tmp/Hack_${USER}_$$.zip"
        if wget -qO "$TEMP_FONT_FILE" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip; then
            if unzip -qo "$TEMP_FONT_FILE" -d "$HOME/.local/share/fonts/"; then
                fc-cache -fv >/dev/null 2>&1
                echo "Hack Nerd Font instalada" >> "$LOG"
            fi
            rm -f "$TEMP_FONT_FILE"
        fi
    fi
fi

usar_zoxide=false
if preguntar "¿Quieres usar Zoxide como reemplazo inteligente de cd?"; then
    usar_zoxide=true
    if ! command -v zoxide &>/dev/null; then
        echo -e "${GREEN}Instalando zoxide...${NC}"
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi
fi

if preguntar "¿Quieres instalar Neovim (última versión) junto con NvChad?"; then
    instalar_nvim=true

    if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "22.04" ]] || \
       [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" == "11" ]]; then
        NVIM_VERSION="v0.9.5"
        NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz"
        NVIM_DIR="nvim-linux64"
    else
        NVIM_VERSION="v0.11.4"
        NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz"
        NVIM_DIR="nvim-linux-x86_64"
    fi

    if command -v nvim &>/dev/null; then
        version_actual=$(nvim --version | head -n1 | awk '{print $2}')
        if [[ "$(printf '%s\n' "0.9" "$version_actual" | sort -V | head -n1)" == "0.9" ]]; then
            echo -e "${GREEN}Neovim ya está en versión $version_actual.${NC}"
            instalar_nvim=false
        fi
    fi

    if $instalar_nvim; then
        echo -e "${GREEN}Instalando Neovim $NVIM_VERSION...${NC}"
        if ! command -v rsync &>/dev/null; then instalar_paquete rsync; fi
        
        mkdir -p "$HOME/.local/nvim"
        curl -L "$NVIM_URL" -o "$HOME/nvim.tar.gz"
        tar -xzf "$HOME/nvim.tar.gz" -C "$HOME"
        rsync -a "$HOME/$NVIM_DIR/" "$HOME/.local/nvim/"
        rm -rf "$HOME/${NVIM_DIR:?}" "$HOME/nvim.tar.gz"
        export PATH="$HOME/.local/nvim/bin:$PATH"
    fi

    if ! grep -q "$HOME/.local/nvim/bin" "$ZSHRC" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/nvim/bin:$PATH"' >> "$ZSHRC"
    fi

    if [[ -d "$HOME/.config/nvim" && ! -f "$HOME/.config/nvim/lua/chadrc.lua" ]]; then
        echo -e "${YELLOW}Respaldo de configuración previa de Neovim...${NC}"
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
    fi

    if [[ ! -d "$HOME/.config/nvim" ]]; then
        echo -e "${GREEN}Instalando NvChad starter template...${NC}"
        git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1
        rm -rf ~/.config/nvim/.git
        
        if ! command -v rg &>/dev/null; then
            instalar_paquete ripgrep
        fi

        echo -e "${YELLOW}📝 Nota: Al ejecutar 'nvim' por primera vez, NvChad instalará sus plugins automáticamente.${NC}"
    else
        echo -e "${GREEN}La configuración de NvChad ya existe. Omitiendo clonado.${NC}"
    fi
fi

usar_fzf_hist=false
if preguntar "¿Quieres activar búsqueda del historial con fzf (Ctrl+r) con vista previa y la función fzf-lovely?"; then
    usar_fzf_hist=true
    if ! command -v fzf &>/dev/null; then
        echo -e "${YELLOW}Instalando fzf...${NC}"
        if command -v apt-get &>/dev/null; then
            sudo apt-get install -y fzf >/dev/null 2>&1 || true
        else
            if [[ ! -d "$HOME/.fzf" ]]; then
                git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" >/dev/null 2>&1 || true
            fi
            if [[ -f "$HOME/.fzf/install" ]]; then
                yes | "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish --zsh >/dev/null 2>&1 || true
            fi
        fi
    fi
fi

# =========================================================================
# ESCRITURA IDEMPOTENTE EN .ZSHRC
# =========================================================================

if ! grep -q "# Configuración generada por el instalador" "$ZSHRC" 2>/dev/null; then
    {
      echo ""
      echo "# Configuración generada por el instalador"
      echo "export ZSH=\"\$HOME/.oh-my-zsh\""
      if $usar_p10k; then
        echo "ZSH_THEME=\"powerlevel10k/powerlevel10k\""
      else
        echo "ZSH_THEME=\"robbyrussell\""
      fi
      
      # Aseguramos que syntax-highlighting sea el último plugin en cargarse
      plugins_finales=()
      for p in "${plugins_activados[@]}"; do
          [[ "$p" != "zsh-syntax-highlighting" ]] && plugins_finales+=("$p")
      done
      if [[ " ${plugins_activados[*]} " == *" zsh-syntax-highlighting "* ]]; then
          plugins_finales+=("zsh-syntax-highlighting")
      fi
      
      echo "plugins=(${plugins_finales[*]})"
      echo "source \$ZSH/oh-my-zsh.sh"
    } >> "$ZSHRC"
fi

if $usar_p10k; then
    if ! grep -q 'source "$HOME/.p10k.zsh"' "$ZSHRC" 2>/dev/null; then
        echo '[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"' >> "$ZSHRC"
    fi
fi

if $usar_batcat || $usar_lsd; then
    if ! grep -q "# Aliases personalizados" "$ZSHRC" 2>/dev/null; then
        echo "" >> "$ZSHRC"
        echo "# Aliases personalizados" >> "$ZSHRC"
        if $usar_batcat; then
            if command -v batcat &>/dev/null; then
                echo "alias cat='batcat'" >> "$ZSHRC"
                echo "alias catn='cat'" >> "$ZSHRC"
                echo "alias catnl='batcat --paging=never'" >> "$ZSHRC"
            elif command -v bat &>/dev/null; then
                echo "alias cat='bat'" >> "$ZSHRC"
                echo "alias batcat='bat'" >> "$ZSHRC"
                echo "alias catn='cat'" >> "$ZSHRC"
                echo "alias catnl='bat --paging=never'" >> "$ZSHRC"
            fi
        fi
        if $usar_lsd; then
            echo "alias ll='lsd -lh --group-dirs=first'" >> "$ZSHRC"
            echo "alias la='lsd -a --group-dirs=first'" >> "$ZSHRC"
            echo "alias l='lsd --group-dirs=first'" >> "$ZSHRC"
            echo "alias lla='lsd -lha --group-dirs=first'" >> "$ZSHRC"
            echo "alias ls='lsd --group-dirs=first'" >> "$ZSHRC"
        fi
    fi
fi

if $usar_zoxide; then
    if ! grep -q "# Zoxide (reemplazo de cd)" "$ZSHRC" 2>/dev/null; then
        {
            echo ""
            echo "# Zoxide (reemplazo de cd)"
            echo 'export PATH="$HOME/.local/bin:$PATH"'
            echo 'eval "$(zoxide init zsh)"'
            echo "alias cd='z'"
        } >> "$ZSHRC"
    fi
fi

if $usar_fzf_hist; then
    PREVIEW_CMD='print -r -- {}'
    if command -v bat &>/dev/null; then
        PREVIEW_CMD="bat --paging=never --style=numbers --color=always {}"
    elif command -v batcat &>/dev/null; then
        PREVIEW_CMD="batcat --paging=never --style=numbers --color=always {}"
    fi

    if ! grep -q "# FZF: ctrl-r" "$ZSHRC" 2>/dev/null; then
        {
            echo ""
            echo "# FZF: ctrl-r búsqueda de historial con vista previa"
            echo "export FZF_DEFAULT_OPTS=\"--height 60% --layout=reverse --border --info=inline --marker='»' --pointer='▶' --prompt='❯ ' --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7,fg+:#e0def4,bg+:#2a2b3a,hl+:#7dcfff,info:#7aa2f7,prompt:#7dcfff,pointer:#f7768e,marker:#e0af68,border:#3b4261\""
            echo "export FZF_CTRL_R_OPTS=\"--preview '$PREVIEW_CMD' --preview-window=down,3,wrap --bind ctrl-/:toggle-preview --exact\""
            echo ""
            echo "if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then"
            echo "  source /usr/share/doc/fzf/examples/key-bindings.zsh"
            echo "  [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh"
            echo "elif [ -f \"\$HOME/.fzf.zsh\" ]; then"
            echo "  source \"\$HOME/.fzf.zsh\""
            echo "fi"
            echo "if type fzf-history-widget >/dev/null 2>&1; then bindkey '^R' fzf-history-widget; fi"
        } >> "$ZSHRC"
        
        # Inyectar la función fzf-lovely de forma limpia
        cat << 'EOF' >> "$ZSHRC"

# Función fzf-lovely: buscador difuso con vista previa avanzada
function fzf-lovely() {
    if [ "$1" = "h" ]; then
        fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (batcat --style=numbers --color=always {} || bat --style=numbers --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -500'
    else
        fzf -m --preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (batcat --style=numbers --color=always {} || bat --style=numbers --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -500'
    fi
}
EOF
    fi

    if ! grep -q "# Historial Zsh (ampliado)" "$ZSHRC" 2>/dev/null; then
        {
            echo ""
            echo "# Historial Zsh (ampliado)"
            echo "export HISTFILE=\"\$HOME/.zsh_history\""
            echo "export HISTSIZE=200000"
            echo "export SAVEHIST=200000"
            echo "setopt HIST_IGNORE_DUPS SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY HIST_FIND_NO_DUPS HIST_IGNORE_SPACE"
        } >> "$ZSHRC"
    fi
fi

# Mensaje final
echo -e "${GREEN}✅ Configuración completada exitosamente.${NC}"
echo -e "${YELLOW}📝 Ejecuta 'chsh -s $(command -v zsh) $(whoami)' si aún no has cambiado tu shell por defecto.${NC}"
echo -e "${GREEN}🔄 Reinicia tu terminal o ejecuta 'source ~/.zshrc' para aplicar los cambios.${NC}"