# customZsh
# 🧠 personalizarTerminal.sh

Script interactivo y modular para automatizar la personalización avanzada del entorno de terminal en sistemas Linux, centrado en Zsh, Powerlevel10k y Neovim con NvChad. Diseñado para usuarios técnicos que buscan reproducibilidad, estética, rendimiento y control total sobre su shell.

---

## 📦 Funcionalidad general

Este script permite:

- Instalar y configurar Zsh como shell por defecto
- Integrar Oh My Zsh con plugins útiles
- Activar el tema Powerlevel10k con configuración persistente
- Instalar herramientas modernas como `batcat` y `lsd`
- Añadir Nerd Fonts para compatibilidad visual
- Instalar Neovim v0.11.4 de forma local y segura
- Configurar NvChad como entorno avanzado para Neovim
- Modificar `.zshrc` sin sobrescribir configuraciones previas
- Añadir aliases personalizados para mejorar la productividad

---

## 🧪 Requisitos técnicos

### ✅ Sistema operativo compatible

- Ubuntu 24.04 LTS (recomendado y validado)
- Ubuntu 22.04 LTS (requiere ajustes manuales)

### 📌 Requerimiento obligatorio

El script requiere Ubuntu 24.04 o superior para garantizar:

- Rutas locales (`~/.local/nvim/bin`) correctamente incluidas en `$PATH`
- Compatibilidad con Neovim v0.11.4 y plugins modernos
- Soporte completo para Nerd Fonts y `lsd`
- Entorno shell con Zsh correctamente integrado

Verifica tu versión con:

```bash
lsb_release -a
Si usas Ubuntu 22.04, aplica estos ajustes manuales:

Añadir manualmente ~/.local/nvim/bin al $PATH

Instalar build-essential para evitar errores de compilador C

Ejecutar fc-cache -fv tras instalar fuentes

Asegurar que .zshrc se carga correctamente (chsh -s $(which zsh))

🚀 Ejecución
bash
bash personalizarTerminal.sh
El script es interactivo y pregunta al usuario si desea instalar cada componente. Esto permite personalizar la ejecución según las necesidades del entorno.

🧠 Estructura técnica
1. Seguridad
bash
set -euo pipefail
Evita errores silenciosos, variables no definidas y fallos en pipes.

2. Variables globales
Define rutas clave ($ZSH, $ZSHRC, $LOG) y colores ANSI para mejorar la legibilidad.

3. Función preguntar()
Permite interacción condicional con el usuario:

bash
preguntar() {
  local mensaje="$1"
  read -rp "$(echo -e "${YELLOW}${mensaje} [s/N]: ${NC}")" respuesta
  [[ "$respuesta" =~ ^[sS]$ ]]
}
4. Instalación de Zsh
Verifica si Zsh está instalado y ofrece cambiar el shell por defecto con chsh.

5. Instalación de Oh My Zsh
Clona el framework en $HOME/.oh-my-zsh y evita ejecución automática (RUNZSH=no).

6. Plugins adicionales
Instala zsh-autosuggestions, zsh-syntax-highlighting y zsh-completions en $ZSH_CUSTOM/plugins/.

7. Powerlevel10k
Clona el tema en $ZSH_CUSTOM/themes/powerlevel10k y añade configuración en .zshrc:

bash
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
8. batcat y lsd
Instala los binarios si no existen y añade aliases:

bash
alias cat='batcat'
alias ls='lsd --group-dirs=first'
Instala Hack Nerd Font en ~/.local/share/fonts y actualiza caché con fc-cache -fv.

9. Neovim + NvChad
Descarga Neovim v0.11.4 desde GitHub

Extrae y mueve con rsync a ~/.local/nvim

Añade ruta al PATH en .zshrc

Clona NvChad en ~/.config/nvim

Respalda configuración previa si existe

Verifica que init.lua esté presente

10. Modificación de .zshrc
Añade bloques de configuración y aliases sin sobrescribir contenido previo. Usa grep para evitar duplicados.

✅ Validaciones incluidas
Verificación de existencia de binarios (command -v)

Validación de archivos descargados (file)

Verificación de rutas en .zshrc

Reintento de clonación si NvChad falla

Comprobación de compilador C (gcc, clang, etc.)

📚 Aplicación académica
Este script puede documentarse como parte de un TFG en administración de sistemas, demostrando:

Automatización reproducible de entornos shell

Validación técnica de dependencias

Integración de herramientas modernas en sistemas restringidos

Personalización avanzada con persistencia y reversibilidad

🧩 Futuras mejoras
Modularización en funciones separadas (instalar_zsh, instalar_neovim, etc.)

Soporte para Arch, Fedora y otras distribuciones

Exportación de logs detallados con timestamps

Interfaz TUI con dialog o whiptail

Detección automática de versión del sistema y adaptación del flujo
