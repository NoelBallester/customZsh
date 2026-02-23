# 🚀 customZsh — Personalización Automática de Terminal

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/OS-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)

Script interactivo, modular y **seguro** para automatizar la personalización avanzada de tu entorno de terminal en Linux. Instala y configura **Zsh**, **Oh My Zsh**, **Powerlevel10k**, **Neovim con NvChad**, y utilidades modernas (`lsd`, `bat`, `zoxide`, `fzf`).

Diseñado para desarrolladores que buscan reproducibilidad, estética y velocidad, pasando de una terminal básica a un entorno de trabajo profesional en minutos.

---

## ✨ Características Principales

* 🖥️ **Menú Interactivo (TUI):** Interfaz limpia por terminal para guiarte en la instalación o desinstalación.
* 📦 **Soporte Multi-Gestor:** Compatible con `apt` (Debian/Ubuntu), `dnf` (Fedora/RHEL) y `pacman` (Arch Linux).
* 🔄 **Totalmente Idempotente:** Puedes ejecutar el script las veces que quieras; no duplicará configuraciones en tu `~/.zshrc`.
* 🛡️ **Seguro y Reversible:** Realiza backups automáticos de tus configuraciones previas.
* 🧹 **Desinstalador Integrado:** Opción para revertir todos los cambios y dejar tu sistema limpio.
* ⚡ **Instalación Inteligente:** Detecta tu versión de `glibc` para instalar la versión exacta de Neovim compatible con tu sistema.

---

## 🚀 Inicio Rápido

### 1️⃣ Clonar el repositorio
```bash
git clone [https://github.com/NoelBallester/customZsh.git](https://github.com/NoelBallester/customZsh.git)
cd customZsh

```

### 2️⃣ Ejecutar el instalador

Al ejecutar el script sin argumentos, se abrirá el **menú principal interactivo**:

```bash
bash personalizarTerminal.sh

```

### ⚙️ Automatización y CLI

Si prefieres no usar el menú y automatizar el proceso, puedes usar estas flags:

* **Modo desatendido** (responde "sí" a todo):
```bash
bash personalizarTerminal.sh --yes

```


* **Desinstalar y limpiar:**
```bash
bash personalizarTerminal.sh --uninstall

```



---

## 🔍 Verificación del Sistema

Antes de instalar, puedes usar la herramienta de diagnóstico incluida para comprobar si tu sistema tiene todo lo necesario:

```bash
# Verificación rápida (también disponible desde el menú principal)
bash verificar_sistema.sh

# Verificación detallada (muestra estado de los repositorios)
bash verificar_sistema.sh detallado

```

---

## 📦 Componentes Incluidos

* **Core:** Zsh, Oh My Zsh.
* **Plugins Zsh:** `zsh-autosuggestions`, `zsh-syntax-highlighting` (asegurado para cargar en el orden correcto), `zsh-completions`.
* **Editor:** Neovim (v0.9.x o v0.11.x según GLIBC) preconfigurado con el framework **NvChad**.
* **Modernizadores CLI:**
* `lsd` (reemplazo de `ls` con iconos y colores).
* `bat` / `batcat` (reemplazo de `cat` con resaltado de sintaxis).
* `zoxide` (reemplazo inteligente y rápido de `cd`).
* `fzf` (búsqueda interactiva del historial con `Ctrl+R`).


* **Fuentes:** Descarga automática de `Hack Nerd Font` para renderizar iconos correctamente.

---

## 💡 Consejos Rápidos

* **Recargar configuración:** Tras cualquier cambio, ejecuta `source ~/.zshrc` o reinicia la terminal.
* **Cambiar prompt:** Ejecuta `p10k configure` en cualquier momento para volver a configurar la apariencia de Powerlevel10k.
* **Primer arranque de Neovim:** Ejecuta `nvim` y espera unos segundos la primera vez; NvChad instalará y sincronizará sus plugins automáticamente de forma gráfica.

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Abre issues o pull requests en el repositorio: [NoelBallester/customZsh](https://github.com/NoelBallester/customZsh)

---

## 📄 Licencia

MIT — Copyright (c) 2025 Noel Ballester