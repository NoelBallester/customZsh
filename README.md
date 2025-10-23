# customZSh — personalización automática de la terminal

Personalizador que instala y configura Zsh, Oh My Zsh, Powerlevel10k, Neovim con NvChad y utilidades relacionadas en sistemas Debian/Ubuntu.

Resumen rápido

- Instalación interactiva y opción no interactiva (`--yes`).
- Detección de distribución y adaptación de instalaciones (Ubuntu / Debian).
- Respaldo de configuraciones previas y cambios idempotentes en `~/.zshrc`.
- Instalación de Neovim/NvChad compatible con la versión de GLIBC del sistema.

---

## Inicio rápido

1. Clona el repositorio:

```bash
git clone https://github.com/NoelBallester/customZsh.git
cd customZsh
```

2. (Opcional) Verifica tu sistema:

```bash
bash verificar_sistema.sh
```

3. Ejecuta el instalador:

```bash
bash personalizarTerminal.sh
```

Para ejecutar en modo no interactivo (responder "sí" a todo):

```bash
bash personalizarTerminal.sh --yes
```

---

## estilos.sh — personalización post-instalación

`estilos.sh` es un script complementario que se ofrece al final del instalador principal y que también puedes ejecutar manualmente para:

- Aplicar estilos de Powerlevel10k (copiando un `.p10k.zsh` desde `p10k-styles/` a `~/.p10k.zsh`).
- Descargar e instalar Nerd Fonts (FiraCode, JetBrainsMono, Meslo, UbuntuMono, Hack) en `~/.local/share/fonts` y actualizar la caché (`fc-cache -fv`).
- Cambiar el tema de NvChad creando o modificando `~/.config/nvim/lua/custom/chadrc.lua` y estableciendo `M.ui.theme = '<tema>'`.

Ejecuta:

```bash
bash estilos.sh
```

Temas P10k incluidos: `clasico`, `colorido`, `dracula`, `gruvbox`, `matrix`, `minimalista`, `nord`, `one-dark`, `solarized-dark`.

Temas NvChad ejemplo: `onedark`, `gruvbox`, `dracula`, `nord`, `solarized-dark`, `tokyonight`, `catppuccin`.

---

## Componentes (resumen)

- Zsh, Oh My Zsh (opcional), Powerlevel10k (opcional)
- Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`
- `lsd`, `bat` / `batcat`
- Neovim (v0.9.x o v0.11.x según GLIBC) y NvChad
- Nerd Fonts (Hack, FiraCode, JetBrainsMono, ...)

---

## Consejos rápidos

- Recarga: `source ~/.zshrc` o reinicia la terminal.
- Reconfigurar Powerlevel10k: `p10k configure`.
- Iniciar Neovim/NvChad: `nvim` (espera la sincronización de plugins en el primer arranque).

---

## Contribuir

Abre issues o pull requests en el repositorio: https://github.com/NoelBallester/customZsh

---

## Licencia

MIT — Copyright (c) 2025 Noel Ballester
# 🚀 customZsh - Personalización Automática de Terminal

Script interactivo y modular para automatizar la personalización avanzada del entorno de terminal en sistemas Linux basados en Debian/Ubuntu. Instala y configura **Zsh**, **Oh My Zsh**, **Powerlevel10k**, **Neovim con NvChad**, y herramientas modernas como `lsd` y `bat`.

**Diseñado para usuarios técnicos** que buscan reproducibilidad, estética, rendimiento y control total sobre su shell.

---

## ✨ Características Principales

- 🎨 **Instalación interactiva** - Elige qué componentes instalar
- 🔄 **Detección automática** - Adapta la instalación según tu sistema (Ubuntu/Debian)
- 🛡️ **Seguro y reversible** - Respaldos automáticos de configuraciones previas
- 📦 **Sin conflictos** - No sobrescribe configuraciones existentes
- ⚡ **Optimizado por versión** - Selecciona paquetes según disponibilidad
- 🔍 **Diagnóstico integrado** - Script de verificación incluido

---

## 🚀 Inicio Rápido

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/NoelBallester/customZsh.git
cd customZsh
```

### 2️⃣ (Opcional) Verificar compatibilidad

```bash
# Verificación rápida
bash verificar_sistema.sh

# Verificación detallada con análisis completo
bash verificar_sistema.sh detallado
```

### 3️⃣ Ejecutar el script

```bash
bash personalizarTerminal.sh
```

El script es **completamente interactivo** - te preguntará qué componentes deseas instalar.

Si quieres ejecutar el instalador de forma no interactiva (respondiendo 'sí' a todas las preguntas), usa la opción:

```bash
bash personalizarTerminal.sh --yes
# o
bash personalizarTerminal.sh -y
```

---

## ✅ Sistemas Compatibles

| Distribución | Versión | Estado | Notas |
|--------------|---------|--------|-------|
| **Ubuntu** | 24.04 LTS (Noble) | ✅ Soporte completo | Todos los paquetes en repos oficiales |
| **Ubuntu** | 22.04 LTS (Jammy) | ✅ Compatible | Adaptaciones automáticas |
| **Debian** | 12 (Bookworm) | ✅ Soporte completo | Equivalente a Ubuntu 24.04 |
| **Debian** | 11 (Bullseye) | ✅ Compatible | Adaptaciones automáticas |
| **Debian** | 10 o anterior | ⚠️ No recomendado | Paquetes demasiado antiguos |

### 🔄 Adaptaciones Automáticas

El script **detecta automáticamente** tu sistema operativo y versión, aplicando las adaptaciones necesarias:

**Para Ubuntu 22.04 / Debian 11:**
- **lsd**: Instalación vía Snap o descarga desde GitHub
- **batcat**: Detección del comando (`bat` vs `batcat`) y creación de aliases
- **Neovim**: Versión 0.9.5 (compatible con GLIBC 2.31-2.35)
- **rsync**: Verificación e instalación automática si falta

**Para Ubuntu 24.04 / Debian 12:**
- **lsd**: Instalación directa desde repositorios oficiales
- **bat**: Disponible como `bat`
- **Neovim**: Versión 0.11.4 (última versión estable)
- **GLIBC**: 2.36+ soporta todas las funcionalidades

---

## 🎨 `estilos.sh` - Personalización Post-Instalación

Una vez que hayas terminado la instalación principal, puedes usar el script `estilos.sh` para personalizar aún más la apariencia de tu terminal. El instalador principal te preguntará si quieres ejecutarlo al final.

También puedes ejecutarlo manualmente en cualquier momento:

```bash
# 🚀 customZsh — Personalización automática de la terminal

Script para automatizar la personalización del entorno de terminal (Zsh, Powerlevel10k, Neovim/NvChad y utilidades modernas) en sistemas basados en Debian/Ubuntu.

Principales características:

- Instalación interactiva y opción no interactiva (--yes)
- Detección de distribución y adaptación automática (Ubuntu/Debian)
- Respaldo de configuraciones previas y cambios idempotentes
- Instalación de Neovim/NvChad adaptada a la versión de GLIBC

---

## Inicio rápido

Clonar y ejecutar:

```bash
git clone https://github.com/NoelBallester/customZsh.git
cd customZsh
bash personalizarTerminal.sh
```

Modo no interactivo:

```bash
bash personalizarTerminal.sh --yes
```

Si quieres verificar antes:

```bash
bash verificar_sistema.sh
```

---

## estilos.sh — personalización post-instalación

`estilos.sh` es un script complementario (se ofrece al final del instalador) para ajustar estética y fuentes:

- Cambiar estilos de Powerlevel10k copiando uno de `p10k-styles/` a `~/.p10k.zsh`.
- Instalar Nerd Fonts (FiraCode, JetBrainsMono, Meslo, UbuntuMono, Hack) en `~/.local/share/fonts`.
- Cambiar el tema de NvChad: crea/actualiza `~/.config/nvim/lua/custom/chadrc.lua` y establece `M.ui.theme = '<tema>'`.

Ejecutar manualmente:

```bash
# 🚀 customZsh — personalización automática de la terminal

Script para automatizar la personalización del entorno de terminal (Zsh, Powerlevel10k, Neovim/NvChad y utilidades) en sistemas Debian/Ubuntu.

Características principales:

- Instalación interactiva y modo no interactivo (`--yes`)
- Adaptación por distribución / versión (Ubuntu / Debian)
- Respaldo de configuraciones y cambios idempotentes en `~/.zshrc`
- Instalación de Neovim/NvChad adaptada a GLIBC

---

## Inicio rápido

Clona y ejecuta:

```bash
git clone https://github.com/NoelBallester/customZsh.git
cd customZsh
bash personalizarTerminal.sh
```

Modo no interactivo:

```bash
bash personalizarTerminal.sh --yes
```

Verifica antes de ejecutar (opcional):

```bash
bash verificar_sistema.sh
```

---

## estilos.sh — personalización post-instalación

`estilos.sh` complementa el instalador principal y permite:

- Cambiar estilos de Powerlevel10k (copiar desde `p10k-styles/` a `~/.p10k.zsh`).
- Instalar Nerd Fonts en `~/.local/share/fonts` y actualizar cache (`fc-cache -fv`).
- Cambiar tema de NvChad (crea/actualiza `~/.config/nvim/lua/custom/chadrc.lua` con `M.ui.theme = '<tema>'`).

Ejecutar manualmente:

```bash
# customZsh — personalización automática de la terminal

Personalizador que instala y configura Zsh, Oh My Zsh, Powerlevel10k, Neovim con NvChad y utilidades relacionadas en sistemas Debian/Ubuntu.

Resumen rápido

- Instalación interactiva con opción no interactiva (`--yes`).
- Detección de distribución y adaptación de instalaciones (Ubuntu / Debian).
- Respaldo de configuraciones previas y cambios idempotentes en `~/.zshrc`.
- Instalación de Neovim/NvChad compatible con la versión de GLIBC del sistema.

---

## Inicio rápido

1. Clona el repositorio:

```bash
git clone https://github.com/NoelBallester/customZsh.git
cd customZsh
```

2. (Opcional) Verifica tu sistema:

```bash
bash verificar_sistema.sh
```

3. Ejecuta el instalador:

```bash
bash personalizarTerminal.sh
```

Para ejecutar en modo no interactivo (responder "sí" a todo):

```bash
bash personalizarTerminal.sh --yes
```

---

## estilos.sh — personalización post-instalación

`estilos.sh` es un script complementario que se ofrece al final del instalador principal y que también puedes ejecutar manualmente para:

- Aplicar estilos de Powerlevel10k (copiando un `.p10k.zsh` desde `p10k-styles/` a `~/.p10k.zsh`).
- Descargar e instalar Nerd Fonts (FiraCode, JetBrainsMono, Meslo, UbuntuMono, Hack) en `~/.local/share/fonts` y actualizar la caché (`fc-cache -fv`).
- Cambiar el tema de NvChad creando o modificando `~/.config/nvim/lua/custom/chadrc.lua` y estableciendo `M.ui.theme = '<tema>'`.

Ejecuta:

```bash
bash estilos.sh
```

Temas incluidos (ejemplos):

- Powerlevel10k: `clasico`, `colorido`, `dracula`, `gruvbox`, `matrix`, `minimalista`, `nord`, `one-dark`, `solarized-dark`.
- NvChad: `onedark`, `gruvbox`, `dracula`, `nord`, `solarized-dark`, `tokyonight`, `catppuccin`.

---

## Componentes principales

- Zsh, Oh My Zsh (opcional), Powerlevel10k (opcional)
- Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`
- `lsd`, `bat` / `batcat`
- Neovim (v0.9.x o v0.11.x según GLIBC) y NvChad
- Nerd Fonts (Hack, FiraCode, JetBrainsMono, ...)

---

## Consejos rápidos

- Recarga tu configuración con `source ~/.zshrc` o cierra y abre la terminal.
- Reconfigura Powerlevel10k con `p10k configure`.
- Inicia Neovim/NvChad con `nvim` y espera a que termine la sincronización inicial de plugins.

---

## Contribuir

Abre issues o pull requests en el repositorio: [NoelBallester/customZsh](https://github.com/NoelBallester/customZsh)

---

## Licencia

MIT — Copyright (c) 2025 Noel Ballester

---

## Inicio rápido

Clona el repositorio y ejecuta:

```bash
git clone https://github.com/NoelBallester/customZsh.git
cd customZsh
bash personalizarTerminal.sh
```

Modo no interactivo:

```bash
bash personalizarTerminal.sh --yes
```

Verificar sistema (opcional):

```bash
bash verificar_sistema.sh
```

---

## estilos.sh — personalización post-instalación

`estilos.sh` es un complemento para ajustar la estética y fuentes tras la instalación.

# customZsh — personalización automática de la terminal

Script para automatizar la personalización del entorno de terminal (Zsh, Powerlevel10k, Neovim/NvChad y utilidades) en sistemas Debian/Ubuntu.

Principales características

- Instalación interactiva y opción no interactiva (`--yes`)
- Adaptación por distribución/versión (Ubuntu/Debian)
- Respaldo de configuraciones y cambios idempotentes
- Instalación de Neovim/NvChad adaptada a la versión de GLIBC

---

## Inicio rápido

Clona el repositorio y ejecuta:

```bash
git clone https://github.com/NoelBallester/customZsh.git
cd customZsh
bash personalizarTerminal.sh
```

Modo no interactivo:

```bash
bash personalizarTerminal.sh --yes
```

Verificar sistema (opcional):

```bash
bash verificar_sistema.sh
```

---

## estilos.sh — personalización post-instalación

`estilos.sh` es un complemento para ajustar la estética y fuentes tras la instalación.

Funcionalidades:

- Cambiar estilo de Powerlevel10k copiando uno de `p10k-styles/` a `~/.p10k.zsh`.
- Instalar Nerd Fonts (FiraCode, JetBrainsMono, Meslo, UbuntuMono, Hack) en `~/.local/share/fonts`.
- Cambiar tema de NvChad: crea/actualiza `~/.config/nvim/lua/custom/chadrc.lua` y establece `M.ui.theme = '<tema>'`.

Ejecuta manualmente:

```bash
bash estilos.sh
```

Temas P10k incluidos: `clasico`, `colorido`, `dracula`, `gruvbox`, `matrix`, `minimalista`, `nord`, `one-dark`, `solarized-dark`.

Temas NvChad ejemplo: `onedark`, `gruvbox`, `dracula`, `nord`, `solarized-dark`, `tokyonight`, `catppuccin`.

---

## Componentes (resumen)

- Zsh, Oh My Zsh (opcional), Powerlevel10k (opcional)
- Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`
- `lsd`, `bat` / `batcat`
- Neovim (0.9.x o 0.11.x según GLIBC) y NvChad
- Nerd Fonts (Hack, FiraCode, JetBrainsMono, ...)

---

## Consejos rápidos

- Recarga: `source ~/.zshrc` o reinicia la terminal.
- Reconfigurar Powerlevel10k: `p10k configure`.
- Iniciar Neovim/NvChad: `nvim` (espera la sincronización de plugins en el primer arranque).

---

## Changelog (extracto)

### v2.1 (22 Octubre 2025)

- Soporte para ejecución como root (con confirmación)
- Modo no interactivo `--yes`
- Nuevo `estilos.sh` para P10k, fuentes y temas de NvChad

---

## Contribuir

Abre issues o pull requests en el repositorio: [NoelBallester/customZsh](https://github.com/NoelBallester/customZsh)

---

## Licencia

MIT — Copyright (c) 2025 Noel Ballester
