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

## 📦 Componentes que se Instalan

### ✅ Obligatorios (siempre se instalan)

- **Zsh** - Shell moderno y potente
- **Oh My Zsh** - Framework de configuración para Zsh
- **Git, curl, wget** - Herramientas básicas (si no están instaladas)

### 🎯 Opcionales (el script pregunta antes de instalar)

- 🎨 **Powerlevel10k** - Tema visual avanzado y personalizable para Zsh
- 📝 **Plugins de Zsh**:
  - `zsh-autosuggestions` - Sugerencias basadas en historial de comandos
  - `zsh-syntax-highlighting` - Resaltado de sintaxis en tiempo real
  - `zsh-completions` - Sistema de autocompletado mejorado
- 🔍 **lsd** - Reemplazo moderno de `ls` con iconos y colores
- 📄 **bat** - Reemplazo de `cat` con resaltado de sintaxis
- 🔤 **Hack Nerd Font** - Fuente con iconos para terminal (necesaria para iconos)
- ⚡ **Neovim** - Editor de texto avanzado (v0.9.5 o v0.11.4 según sistema)
- 🎯 **NvChad** - Configuración moderna y optimizada para Neovim

---

## 📖 Guía de Uso Detallada

### 🔍 Paso 1: Verificación del Sistema (Recomendado)

Antes de ejecutar el script principal, verifica la compatibilidad de tu sistema:

```bash
bash verificar_sistema.sh
```

**Salida esperada:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Verificación de Sistema - personalizarTerminal.sh
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Sistema detectado: Ubuntu 24.04 LTS
✓ Distribución: ubuntu
✓ Versión: 24.04

═══ Validación de Sintaxis ═══
✓ personalizarTerminal.sh - Sintaxis correcta

═══ Comandos Requeridos ═══
✓ git
✓ curl
✓ wget
✓ unzip
✓ fc-cache
✓ rsync

═══ Configuración Recomendada ═══
✓ lsd: Instalación desde repositorios APT
✓ bat: Comando disponible como 'bat'
✓ Neovim: Versión 0.11.4 (GLIBC 2.39)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Sistema compatible - Listo para ejecutar

Ejecutar: bash personalizarTerminal.sh
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Para ver más detalles:**
```bash
bash verificar_sistema.sh detallado
```

Esto mostrará información adicional como:
- Versiones exactas de paquetes disponibles en repositorios
- Análisis de GLIBC
- Recomendaciones específicas para tu distribución

### ⚙️ Paso 2: Ejecución del Script Principal

```bash
bash personalizarTerminal.sh
```

> ℹ️ **Nota sobre ejecución como root:**
> - **Usuario normal:** Configura el entorno en tu directorio `$HOME` (recomendado)
> - **Como root (`sudo`):** El script te preguntará si deseas instalar para el usuario root en `/root`
> - El script funciona en ambos casos, pero la mayoría de usuarios querrán ejecutarlo sin `sudo`

El script te guiará paso a paso con preguntas interactivas:

#### Ejemplo de ejecución:

```
🧠 Personalizador avanzado de terminal - Por Noel Ballester

Este script instalará y configurará:
  - Zsh como shell por defecto
  - Oh My Zsh con plugins útiles
  - Opcionalmente: Powerlevel10k, lsd, batcat, Neovim + NvChad

Sistema detectado: Ubuntu 24.04 LTS

¿Desea instalar Powerlevel10k? [s/N]: s
✓ Instalando Powerlevel10k...

¿Desea instalar lsd (ls mejorado)? [s/N]: s
✓ Instalando lsd desde repositorios APT...

¿Desea instalar batcat (cat mejorado)? [s/N]: s
✓ Instalando bat...

¿Desea instalar Neovim + NvChad? [s/N]: s
✓ Descargando Neovim v0.11.4...
✓ Instalando NvChad...

✅ Instalación completada!
📝 Log guardado en: ~/.zsh_installer.log
```

### 🎨 Paso 3: Configuración Post-Instalación

#### Aplicar cambios

Una vez finalizada la instalación, aplica los cambios:

**Opción 1 - Reiniciar terminal:**
```bash
exit  # Cierra y vuelve a abrir la terminal
```

**Opción 2 - Recargar configuración:**
```bash
source ~/.zshrc
```

#### Configurar Powerlevel10k (si lo instalaste)

Al abrir una nueva terminal, verás el **asistente de configuración** de Powerlevel10k:

```bash
p10k configure
```

El asistente te preguntará sobre:
- Estilo de prompt (lean, classic, rainbow, pure)
- Iconos y símbolos
- Colores y formato
- Elementos a mostrar (git, hora, directorio, etc.)

**Puedes volver a ejecutar la configuración en cualquier momento:**
```bash
p10k configure
```

#### Iniciar Neovim con NvChad (si lo instalaste)

```bash
nvim
```

**La primera vez:**
- NvChad descargará e instalará plugins automáticamente
- Espera a que termine (puede tardar 1-2 minutos)
- Cierra y vuelve a abrir Neovim

**Comandos útiles de NvChad:**
- `<leader>` = Espacio (por defecto)
- `<leader>ff` = Buscar archivos
- `<leader>th` = Cambiar tema
- `:help nvchad` = Ayuda de NvChad

---

## 📊 Tabla de Compatibilidad de Paquetes

| Paquete | Ubuntu 24.04 | Ubuntu 22.04 | Debian 12 | Debian 11 |
|---------|--------------|--------------|-----------|-----------|
| **lsd** | ✅ Repos APT | ⚠️ Snap/GitHub | ✅ Repos APT | ⚠️ Snap/GitHub |
| **bat** | ✅ Comando `bat` | ⚠️ Comando `batcat` | ✅ Comando `bat` | ⚠️ Comando `batcat` |
| **Neovim** | ✅ v0.11.4 | ⚠️ v0.9.5 | ✅ v0.11.4 | ⚠️ v0.9.5 |
| **GLIBC** | 2.39+ | 2.35 | 2.36+ | 2.31 |
| **rsync** | ✅ Preinstalado | ⚠️ Verifica | ✅ Preinstalado | ⚠️ Verifica |

**Leyenda:**
- ✅ = Disponible en repositorios oficiales, instalación directa
- ⚠️ = Instalación alternativa automática (el script se encarga)

---

## 💡 Aliases y Comandos Disponibles

Una vez completada la instalación, tendrás acceso a los siguientes comandos y aliases:

### 🔍 Si instalaste `lsd`:

```bash
ls         # lsd con iconos y colores
ll         # ls -lh con detalles e iconos
la         # ls -a muestra archivos ocultos
lla        # ls -lha todos los archivos con detalles
```

### 📄 Si instalaste `bat`:

```bash
cat archivo.txt      # Ahora usa bat con resaltado de sintaxis
catn archivo.txt     # cat original (sin bat)
catnl archivo.txt    # bat sin números de línea
```

### ⚡ Si instalaste Neovim:

```bash
nvim                 # Abre Neovim con NvChad
nvim archivo.py      # Edita archivo con resaltado de sintaxis
```

**Atajos de teclado útiles en NvChad:**

| Atajo | Descripción |
|-------|-------------|
| `Space` | Leader key (tecla principal) |
| `Space + ff` | Buscar archivos (Telescope) |
| `Space + fw` | Buscar palabra en archivos |
| `Space + th` | Cambiar tema de colores |
| `Space + e` | Toggle explorador de archivos |
| `Ctrl + n` | Toggle NvimTree |
| `Ctrl + h/j/k/l` | Navegar entre ventanas |

### 🎨 Powerlevel10k:

```bash
p10k configure       # Reconfigurar el tema
p10k segment -h      # Ayuda sobre segmentos personalizados
```

---

## 📁 Estructura de Archivos Generados

El script crea y modifica los siguientes archivos y directorios:

```
$HOME/
├── .oh-my-zsh/                        # Framework Oh My Zsh
│   └── custom/
│       ├── plugins/
│       │   ├── zsh-autosuggestions/   # Plugin de sugerencias
│       │   ├── zsh-syntax-highlighting/
│       │   └── zsh-completions/
│       └── themes/
│           └── powerlevel10k/         # Tema Powerlevel10k
│
├── .zshrc                             # Configuración principal de Zsh
├── .p10k.zsh                          # Configuración de Powerlevel10k
├── .zsh_installer.log                 # Log de instalación
│
├── .local/
│   ├── nvim/                          # Neovim instalado localmente
│   │   └── bin/nvim                   # Binario de Neovim
│   └── share/fonts/
│       └── HackNerdFont/              # Fuente con iconos
│
└── .config/
    └── nvim/                          # Configuración NvChad
        ├── init.lua                   # Archivo principal de config
        └── lua/
            └── custom/                # Personalizaciones
```

---

## 🛠️ Detalles Técnicos del Script

### 🔒 Seguridad

El script utiliza buenas prácticas de bash:

```bash
set -euo pipefail
```

- `-e`: Sale inmediatamente si un comando falla
- `-u`: Trata variables no definidas como error
- `-o pipefail`: Falla si algún comando en un pipe falla

### 🔍 Validaciones Implementadas

- ✅ Verificación de existencia de binarios antes de usar (`command -v`)
- ✅ Validación de archivos descargados con `file`
- ✅ Verificación de rutas en `.zshrc` antes de añadir (evita duplicados)
- ✅ Respaldo automático de configuraciones previas (`.config/nvim.backup`)
- ✅ Protección contra `rm -rf` peligrosos usando `${VAR:?}`
- ✅ Detección automática de GLIBC para seleccionar versión de Neovim
- ✅ Verificación de disponibilidad de paquetes en repositorios

### 🌐 Detección de Sistema

```bash
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID="$ID"              # ubuntu o debian
    DISTRO_VERSION="$VERSION_ID" # 22.04, 24.04, 11, 12
fi
```

### 🎯 Instalación Adaptativa

Ejemplo de cómo el script adapta la instalación de `lsd`:

```bash
if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "24.04" ]] || \
   [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" -ge "12" ]]; then
    # Ubuntu 24.04 / Debian 12+
    sudo apt install -y lsd
else
    # Ubuntu 22.04 / Debian 11
    if command -v snap &>/dev/null; then
        sudo snap install lsd
    else
        # Descarga desde GitHub releases
        wget https://github.com/lsd-rs/lsd/releases/download/...
    fi
fi
```

---

## 🔧 Solución de Problemas

### ℹ️ Ejecución como root vs usuario normal

**El script funciona tanto para root como para usuarios normales**, pero es importante entender las diferencias:

**Como usuario normal (recomendado):**
```bash
bash personalizarTerminal.sh
```
- ✅ Configura tu entorno en `$HOME` (ej: `/home/usuario`)
- ✅ El script pedirá `sudo` solo cuando sea necesario para paquetes del sistema
- ✅ Ideal para uso diario

**Como root:**
```bash
sudo bash personalizarTerminal.sh
# El script te preguntará si deseas continuar
```
- ⚠️ Configura el entorno en `/root`
- ⚠️ Útil si quieres personalizar la terminal de root
- ⚠️ No afecta a tu usuario normal

**Consejo:** Si quieres personalizar tanto tu usuario como root, ejecuta el script dos veces: una vez normalmente y otra con `sudo`.

### ❌ Error: "lsd: command not found" (Ubuntu 22.04 / Debian 11)

**Causa:** `lsd` no está disponible en repositorios oficiales

**Solución automática:** El script detecta esto e instala desde Snap o GitHub

**Solución manual si falla:**

```bash
# Opción 1: Instalar con Snap
sudo snap install lsd

# Opción 2: Instalar con Cargo (Rust)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install lsd

# Opción 3: Descargar .deb desde GitHub
wget https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb
sudo dpkg -i lsd_1.1.5_amd64.deb
```

### ❌ Error: Neovim no inicia o muestra error de GLIBC

**Causa:** Versión de Neovim incompatible con GLIBC del sistema

**Verificar tu versión de GLIBC:**

```bash
ldd --version | head -n1
```

**Versiones esperadas:**
- Ubuntu 22.04 / Debian 11: GLIBC 2.31-2.35 → Usa Neovim 0.9.5
- Ubuntu 24.04 / Debian 12: GLIBC 2.36+ → Usa Neovim 0.11.4

**Solución:** El script ya selecciona la versión correcta automáticamente. Si tienes problemas:

```bash
# Reinstalar Neovim manualmente con la versión correcta
cd ~/Downloads

# Para sistemas antiguos (GLIBC < 2.36)
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz

# Para sistemas modernos (GLIBC >= 2.36)
wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux64.tar.gz

# Extraer e instalar
tar xzf nvim-linux64.tar.gz
rsync -av nvim-linux64/ ~/.local/nvim/
```

### ❌ Powerlevel10k no muestra iconos

**Causa:** Terminal no usa una Nerd Font

**Solución:**

1. El script ya instala Hack Nerd Font automáticamente
2. Configura tu terminal para usar "Hack Nerd Font":

**GNOME Terminal:**
```bash
# Preferencias → Perfiles → Fuente → "Hack Nerd Font Mono"
```

**Konsole:**
```bash
# Settings → Edit Current Profile → Appearance → Font → "Hack Nerd Font"
```

**Windows Terminal / WSL:**
```json
{
    "profiles": {
        "defaults": {
            "font": {
                "face": "Hack Nerd Font"
            }
        }
    }
}
```

### ❌ Cambio de shell no se aplica

**Síntoma:** Después del script, sigue usando bash

**Solución:**

```bash
# Verificar shell actual
echo $SHELL

# Si no es /usr/bin/zsh, cambiar manualmente
chsh -s $(which zsh)

# Cerrar sesión completamente y volver a entrar
exit
# O reiniciar el sistema
```

### ❌ Conflicto entre `bat` y `batcat`

**Problema:** En Ubuntu 22.04 el comando es `batcat`, en 24.04 es `bat`

**Solución automática:** El script detecta cuál está disponible y crea los aliases apropiados

**Verificar manualmente:**

```bash
# Ver qué comando está disponible
command -v bat
command -v batcat

# Ver aliases creados
alias | grep cat
```

### ℹ️ fzf: activación y solución automática

El instalador ahora pregunta explícitamente si quieres activar la búsqueda de historial con `fzf` (Ctrl+r). Si respondes "sí", el script intentará automáticamente:

- Instalar `fzf` desde APT (si está disponible en tus repositorios).
- Si APT no está disponible o falla, clonar `https://github.com/junegunn/fzf.git` en `~/.fzf` y ejecutar el instalador no interactivo para generar `~/.fzf.zsh` y los keybindings.
- Añadir de forma idempotente el bloque necesario en `~/.zshrc` que exporta `FZF_DEFAULT_OPTS`, `FZF_CTRL_R_OPTS` y `source`a los keybindings (`/usr/share/doc/fzf/examples/key-bindings.zsh` o `~/.fzf.zsh`).

Si algo falla, `verificar_sistema.sh` ahora incluye comprobaciones específicas de `fzf` y te dirá si falta `~/.fzf`, `~/.fzf.zsh` o los keybindings instalados desde APT.

Comandos manuales de reparación (elige uno):

APT (si tu sistema tiene el paquete):
```bash
sudo apt update
sudo apt install -y fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source ~/.zshrc
```

Instalación local (fallback):
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish --zsh
source ~/.fzf.zsh
source ~/.zshrc
```

Si prefieres no automatizar, puedes responder "no" cuando el instalador pregunte y seguir las instrucciones manuales anteriores.

---

## 🎯 Casos de Uso Recomendados

### 👨‍💻 Desarrollador Full Stack

```bash
# Instalar TODO para máxima productividad
bash personalizarTerminal.sh

# Responder "s" (sí) a TODAS las opciones:
# - Powerlevel10k ✓
# - lsd ✓
# - batcat ✓  
# - Hack Nerd Font ✓
# - Neovim + NvChad ✓
```

**Resultado:** Terminal completa con todas las herramientas modernas

### 🎨 Minimalista

```bash
# Solo lo esencial: Zsh + Oh My Zsh + Plugins
bash personalizarTerminal.sh

# Responder:
# - Powerlevel10k → n
# - lsd → n
# - batcat → n
# - Neovim + NvChad → n
```

**Resultado:** Shell mejorado sin componentes visuales pesados

### 🖥️ Servidor Remoto / Producción

```bash
# Sin componentes visuales, solo funcionalidad
bash personalizarTerminal.sh

# Responder:
# - Powerlevel10k → n (consume recursos)
# - lsd → s (útil para visualizar)
# - batcat → s (útil para logs)
# - Hack Nerd Font → n (servidor sin GUI)
# - Neovim + NvChad → s (editor potente)
```

**Resultado:** Shell funcional sin overhead visual

### 🏫 Laboratorio / Universidad

```bash
# Instalación rápida y portable
bash personalizarTerminal.sh

# Instalar solo lo necesario para el curso
# Todo se instala en $HOME, no afecta al sistema
```

---

## 🤝 Contribuir

¿Encontraste un bug o tienes una sugerencia?

### 📝 Reportar Issues

1. Ve a [Issues](https://github.com/NoelBallester/customZsh/issues)
2. Busca si ya existe un issue similar
3. Si no existe, crea uno nuevo con:
   - Descripción del problema
   - Sistema operativo y versión
   - Log de error (archivo `~/.zsh_installer.log`)
   - Pasos para reproducir

### 🔀 Pull Requests

1. Fork el repositorio
2. Crea una rama para tu feature:
   ```bash
   git checkout -b feature/mi-mejora
   ```
3. Realiza tus cambios y commitea:
   ```bash
   git commit -am 'feat: Añadir soporte para Fedora'
   ```
4. Push a tu fork:
   ```bash
   git push origin feature/mi-mejora
   ```
5. Abre un Pull Request explicando los cambios

### 🐛 Issues Conocidos

- Debian 10 (Buster) y anteriores no son soportados oficialmente
- Snap puede no estar disponible en instalaciones mínimas de Debian
- En WSL2 el cambio de shell requiere reiniciar la sesión de WSL

---

## 📝 Changelog

### v2.1 (22 Octubre 2025)

- � **Soporte para ejecución como root:** El script ahora funciona tanto para usuarios normales como root
- 💬 **Confirmación interactiva:** Al ejecutar como root, solicita confirmación antes de instalar
- 🔧 **Mejora en archivos temporales:** Uso de archivos temporales únicos para evitar conflictos
- 📦 **Mejor manejo de errores:** Limpieza automática de archivos temporales en caso de fallo
- 📝 **Documentación mejorada:** README.md completamente reescrito con guías detalladas

### v2.0 (22 Octubre 2025)

- ✅ Añadido soporte completo para Debian 11 (Bullseye) y 12 (Bookworm)
- ✅ Detección automática de distribución y versión (Ubuntu/Debian)
- ✅ Corrección de errores de sintaxis críticos (línea 194)
- ✅ Adaptación inteligente de instalación según versión del sistema
- ✅ Selección automática de versión de Neovim según GLIBC
- ✅ Instalación alternativa de lsd para sistemas sin repos oficiales
- ✅ Manejo automático de diferencias entre `batcat` y `bat`
- ✅ Verificación e instalación automática de `rsync`
- ✅ Documentación consolidada en README.md único
- ✅ Script de verificación unificado (`verificar_sistema.sh`)
- ✅ Mejoras en validaciones y manejo de errores

### v1.0 (Inicial)

- Script básico para Ubuntu 24.04
- Instalación de Zsh, Oh My Zsh y Powerlevel10k
- Soporte para Neovim y NvChad

---

## 📚 Recursos Adicionales

### 📖 Documentación Oficial

- [Zsh Documentation](https://zsh.sourceforge.io/Doc/) - Manual completo de Zsh
- [Oh My Zsh](https://ohmyz.sh/) - Framework de configuración
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Tema avanzado
- [Neovim](https://neovim.io/) - Editor moderno
- [NvChad](https://nvchad.com/) - Configuración optimizada
- [lsd](https://github.com/lsd-rs/lsd) - ls moderno en Rust
- [bat](https://github.com/sharkdp/bat) - cat con sintaxis
- [Nerd Fonts](https://www.nerdfonts.com/) - Fuentes con iconos

### 🎓 Tutoriales Recomendados

- [Zsh Tips and Tricks](https://wiki.archlinux.org/title/Zsh)
- [Mastering Neovim](https://neovim.io/doc/user/)
- [NvChad Quickstart](https://nvchad.com/docs/quickstart/install)

---

## 📄 Licencia

Este proyecto está bajo licencia **MIT** - úsalo, modifícalo y compártelo libremente.

```
MIT License

Copyright (c) 2025 Noel Ballester

Se permite el uso, copia, modificación, fusión, publicación, distribución,
sublicencia y/o venta de copias del software, sujeto a las siguientes condiciones:

El aviso de copyright anterior y este aviso de permiso se incluirán en todas
las copias o partes sustanciales del software.

EL SOFTWARE SE PROPORCIONA "TAL CUAL", SIN GARANTÍA DE NINGÚN TIPO.
```

---

## 👤 Autor

**Noel Ballester**

- 🐙 GitHub: [@NoelBallester](https://github.com/NoelBallester)
- 📦 Repositorio: [customZsh](https://github.com/NoelBallester/customZsh)
- 📧 Contacto: Crea un [Issue](https://github.com/NoelBallester/customZsh/issues) para consultas

---

## ⭐ Agradecimientos

Gracias especiales a los desarrolladores y comunidades de:

- **Oh My Zsh Team** - Por el fantástico framework
- **Roman Perepelitsa** - Creador de Powerlevel10k
- **Neovim Team** - Por el editor del futuro
- **NvChad Team** - Por la configuración optimizada
- **Comunidad Open Source** - Por las herramientas CLI modernas

---

## 🚀 ¿Te resultó útil?

Si este script te ayudó a configurar tu terminal perfecta, considera:

- ⭐ **Dar una estrella** al repositorio
- 🐛 **Reportar bugs** o sugerir mejoras
- 🔀 **Compartir** con otros desarrolladores
- 💬 **Contribuir** con mejoras o correcciones

---

<div align="center">

### 💻 Happy Coding! ✨

**Hecho con ❤️ para la comunidad de desarrolladores**

[⬆️ Volver arriba](#-customzsh---personalización-automática-de-terminal)

</div>
