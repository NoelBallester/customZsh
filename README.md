# 🧠 personalizarTerminal.sh# customZsh


Script interactivo y modular para automatizar la personalización avanzada del entorno de terminal en sistemas Linux basados en Debian/Ubuntu. Instala y configura Zsh, Oh My Zsh, Powerlevel10k, Neovim con NvChad, y herramientas modernas como `lsd` y `batcat`.

Script interactivo y modular para automatizar la personalización avanzada del entorno de terminal en sistemas Linux, centrado en Zsh, Powerlevel10k y Neovim con NvChad. Diseñado para usuarios técnicos que buscan reproducibilidad, estética, rendimiento y control total sobre su shell.

---

---

## 🚀 Inicio Rápido

## 📦 Funcionalidad general

```bash

# 1. Clonar el repositorioEste script permite:

git clone https://github.com/NoelBallester/customZsh.git

cd customZsh- Instalar y configurar Zsh como shell por defecto

- Integrar Oh My Zsh con plugins útiles

# 2. Ejecutar el script- Activar el tema Powerlevel10k con configuración persistente

bash personalizarTerminal.sh- Instalar herramientas modernas como `batcat` y `lsd`

```- Añadir Nerd Fonts para compatibilidad visual

- Instalar Neovim v0.11.4 de forma local y segura

El script es **interactivo** - te preguntará qué componentes deseas instalar.- Configurar NvChad como entorno avanzado para Neovim

- Modificar `.zshrc` sin sobrescribir configuraciones previas

---- Añadir aliases personalizados para mejorar la productividad



## ✅ Sistemas Compatibles---



| Distribución | Versión | Estado | Notas |## 🧪 Requisitos técnicos

|--------------|---------|--------|-------|

| **Ubuntu** | 24.04 LTS (Noble) | ✅ Soporte completo | Todos los paquetes en repos oficiales |### ✅ Sistema operativo compatible

| **Ubuntu** | 22.04 LTS (Jammy) | ✅ Compatible | Adaptaciones automáticas |

| **Debian** | 12 (Bookworm) | ✅ Soporte completo | Equivalente a Ubuntu 24.04 |- **Ubuntu 24.04 LTS** (recomendado - soporte completo)

| **Debian** | 11 (Bullseye) | ✅ Compatible | Adaptaciones automáticas |- **Ubuntu 22.04 LTS** (compatible con adaptaciones automáticas)

| **Debian** | 10 o anterior | ⚠️ No recomendado | Paquetes demasiado antiguos |- **Debian 12 (Bookworm)** (compatible - equivalente a Ubuntu 24.04)

- **Debian 11 (Bullseye)** (compatible con adaptaciones automáticas)

### 🔄 Adaptaciones Automáticas

### � Adaptaciones automáticas para Ubuntu 22.04

El script **detecta automáticamente** tu sistema y adapta las instalaciones:

El script ahora **detecta automáticamente** la versión de Ubuntu y realiza las siguientes adaptaciones:

**Ubuntu 22.04 / Debian 11:**

- **lsd**: Instalación vía Snap o descarga desde GitHub1. **lsd**: Se instala desde Snap o GitHub en lugar de repositorios oficiales

- **batcat**: Detección del comando (`bat` vs `batcat`) y creación de aliases2. **batcat**: Detecta si el comando es `bat` o `batcat` y crea aliases apropiados

- **Neovim**: Versión 0.9.5 (compatible con GLIBC 2.31-2.35)3. **Neovim**: Usa versión 0.9.5 (compatible con GLIBC 2.35) en lugar de 0.11.4

- **rsync**: Verificación e instalación si falta4. **rsync**: Verifica e instala automáticamente si falta



**Ubuntu 24.04 / Debian 12:**### 📌 Requerimientos mínimos

- **lsd**: Instalación directa desde repositorios oficiales

- **bat**: Disponible como `bat`- Ubuntu 22.04 LTS o superior

- **Neovim**: Versión 0.11.4 (última versión)- Conexión a Internet

- **GLIBC**: 2.36+ soporta todas las funcionalidades- Permisos de sudo

- Git, curl y wget (se instalan automáticamente si faltan)

---

## 🚀 Ejecución

## 📦 Componentes Instalados```bash

chmod +x personalizarTerminal.sh

### Obligatoriosbash personalizarTerminal.sh

- ✅ **Zsh** - Shell moderno y potente```

- ✅ **Oh My Zsh** - Framework de configuración para ZshEl script es interactivo y pregunta al usuario si desea instalar cada componente. Esto permite personalizar la ejecución según las necesidades del entorno.

- ✅ **Git, curl, wget** - Herramientas básicas

> ⚠️ **Nota importante**: El script ahora valida correctamente la sintaxis y ha sido corregido para evitar errores de ejecución.

### Opcionales (interactivos)

- 🎨 **Powerlevel10k** - Tema visual avanzado para Zsh### 🧪 Verificar compatibilidad (opcional)

- 📝 **Plugins de Zsh**:

  - `zsh-autosuggestions` - Sugerencias basadas en historialAntes de ejecutar, puedes verificar la compatibilidad de tu sistema:

  - `zsh-syntax-highlighting` - Resaltado de sintaxis en tiempo real

  - `zsh-completions` - Autocompletado mejorado```bash

- 🔍 **lsd** - Reemplazo moderno de `ls` con iconosbash test_compatibilidad.sh

- 📄 **batcat** - Reemplazo de `cat` con resaltado de sintaxis```

- 🔤 **Hack Nerd Font** - Fuente con iconos para terminal

- ⚡ **Neovim** - Editor de texto avanzado (v0.9.5 o v0.11.4 según sistema)Este script verifica:

- 🎯 **NvChad** - Configuración moderna para Neovim- Versión de Ubuntu

- Disponibilidad de comandos requeridos

---- Paquetes en repositorios

- Versión de Neovim recomendada

## 🧪 Verificación de Compatibilidad

Antes de ejecutar el script principal, puedes verificar la compatibilidad de tu sistema:

```bash
# Verificación rápida (por defecto)
bash verificar_sistema.sh

# Verificación detallada con análisis completo
bash verificar_sistema.sh detallado
```

**Características:**
- ✅ Detección automática de sistema operativo (Ubuntu/Debian)
- 🔍 Validación de sintaxis del script principal
- 📦 Verificación de comandos y paquetes requeridos
- 💡 Recomendaciones específicas según tu distribución y versión
- 🔧 Análisis de GLIBC para compatibilidad de Neovim

**Salida esperada (modo simple):**

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



━━━━ Verificando sintaxis del script ━━━━2. Variables globales

✓ Sintaxis correctaDefine rutas clave ($ZSH, $ZSHRC, $LOG) y colores ANSI para mejorar la legibilidad.



━━━━ Comandos requeridos ━━━━3. Función preguntar()

✓ git instaladoPermite interacción condicional con el usuario:

✓ curl instalado

...bash

```preguntar() {

  local mensaje="$1"

---  read -rp "$(echo -e "${YELLOW}${mensaje} [s/N]: ${NC}")" respuesta

  [[ "$respuesta" =~ ^[sS]$ ]]

## 🔧 Correcciones Aplicadas}

4. Instalación de Zsh

### ✅ Versión 2.0 (Octubre 2025)Verifica si Zsh está instalado y ofrece cambiar el shell por defecto con chsh.



1. **Error de sintaxis crítico** (línea 194) - ✅ Resuelto5. Instalación de Oh My Zsh

   - Eliminado bloque `if/fi` huérfano que causaba falloClona el framework en $HOME/.oh-my-zsh y evita ejecución automática (RUNZSH=no).



2. **Incompatibilidad Ubuntu 22.04** - ✅ Resuelto6. Plugins adicionales

   - Detección automática de versiónInstala zsh-autosuggestions, zsh-syntax-highlighting y zsh-completions en $ZSH_CUSTOM/plugins/.

   - Adaptación de paquetes según disponibilidad en repositorios

7. Powerlevel10k

3. **Incompatibilidad Debian** - ✅ ResueltoClona el tema en $ZSH_CUSTOM/themes/powerlevel10k y añade configuración en .zshrc:

   - Soporte para Debian 11 (Bullseye) y 12 (Bookworm)

   - Detección de GLIBC y selección de Neovim apropiadobash

ZSH_THEME="powerlevel10k/powerlevel10k"

4. **Variables mal escapadas** - ✅ Resuelto[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

   - Corrección de expansión de `$HOME` y `$ZSH` en `.zshrc`8. batcat y lsd

Instala los binarios si no existen y añade aliases:

5. **Dependencias faltantes** - ✅ Resuelto

   - Verificación e instalación automática de `rsync`bash

alias cat='batcat'

6. **Expansión de variables incorrecta** - ✅ Resueltoalias ls='lsd --group-dirs=first'

   - Implementada estructura condicional correcta para `ZSH_THEME`Instala Hack Nerd Font en ~/.local/share/fonts y actualiza caché con fc-cache -fv.



---9. Neovim + NvChad

Descarga Neovim v0.11.4 desde GitHub

## 📊 Tabla de Compatibilidad de Paquetes

Extrae y mueve con rsync a ~/.local/nvim

| Paquete | Ubuntu 24.04 | Ubuntu 22.04 | Debian 12 | Debian 11 |

|---------|--------------|--------------|-----------|-----------|Añade ruta al PATH en .zshrc

| **lsd** | ✅ Repos APT | ⚠️ Snap/GitHub | ✅ Repos APT | ⚠️ Snap/GitHub |

| **bat** | ✅ Comando `bat` | ⚠️ Comando `batcat` | ✅ Comando `bat` | ⚠️ Comando `batcat` |Clona NvChad en ~/.config/nvim

| **Neovim** | ✅ v0.11.4 | ⚠️ v0.9.5 | ✅ v0.11.4 | ⚠️ v0.9.5 |

| **GLIBC** | 2.39+ | 2.35 | 2.36+ | 2.31 |Respalda configuración previa si existe

| **rsync** | ✅ Preinstalado | ⚠️ Verifica | ✅ Preinstalado | ⚠️ Verifica |

Verifica que init.lua esté presente

**Leyenda:**

- ✅ = Disponible en repositorios oficiales10. Modificación de .zshrc

- ⚠️ = Instalación alternativa automáticaAñade bloques de configuración y aliases sin sobrescribir contenido previo. Usa grep para evitar duplicados.



---✅ Validaciones incluidas

Verificación de existencia de binarios (command -v)

## 🛠️ Estructura Técnica

Validación de archivos descargados (file)

### Seguridad

```bashVerificación de rutas en .zshrc

set -euo pipefail

```Reintento de clonación si NvChad falla

- `-e`: Sale inmediatamente si un comando falla

- `-u`: Trata variables no definidas como errorComprobación de compilador C (gcc, clang, etc.)

- `-o pipefail`: Falla si algún comando en un pipe falla

📚 Aplicación académica

### Detección de SistemaEste script puede documentarse como parte de un TFG en administración de sistemas, demostrando:

```bash

if [[ -f /etc/os-release ]]; thenAutomatización reproducible de entornos shell

    . /etc/os-release

    DISTRO_ID="$ID"              # ubuntu o debianValidación técnica de dependencias

    DISTRO_VERSION="$VERSION_ID" # 22.04, 24.04, 11, 12

fiIntegración de herramientas modernas en sistemas restringidos

```

Personalización avanzada con persistencia y reversibilidad

### Instalación Adaptativa

```bash🧩 Futuras mejoras

# Ejemplo: lsdModularización en funciones separadas (instalar_zsh, instalar_neovim, etc.)

if [[ "$DISTRO_ID" == "ubuntu" && "$DISTRO_VERSION" == "24.04" ]]; then

    sudo apt install -y lsd  # Repos oficialesSoporte para Arch, Fedora y otras distribuciones

else

    sudo snap install lsd    # Método alternativoExportación de logs detallados con timestamps

fi

```Interfaz TUI con dialog o whiptail



### Validaciones ImplementadasDetección automática de versión del sistema y adaptación del flujo

- ✅ Verificación de existencia de binarios (`command -v`)
- ✅ Validación de archivos descargados (`file`)
- ✅ Verificación de rutas en `.zshrc` antes de añadir
- ✅ Respaldo automático de configuraciones previas
- ✅ Protección contra `rm -rf` peligrosos con `${VAR:?}`

---

## 📁 Archivos Generados

El script crea/modifica los siguientes archivos:

```
$HOME/
├── .oh-my-zsh/                    # Framework Oh My Zsh
│   └── custom/
│       ├── plugins/               # Plugins adicionales
│       └── themes/powerlevel10k/  # Tema Powerlevel10k
├── .zshrc                         # Configuración de Zsh (modificado)
├── .p10k.zsh                      # Configuración de Powerlevel10k
├── .zsh_installer.log             # Log de instalación
├── .local/
│   ├── nvim/                      # Neovim local
│   │   └── bin/nvim
│   └── share/fonts/               # Nerd Fonts
└── .config/
    └── nvim/                      # Configuración NvChad
```

---

## 💡 Uso Post-Instalación

### Aplicar Cambios
```bash
# Opción 1: Reiniciar terminal
exit

# Opción 2: Recargar configuración
source ~/.zshrc
```

### Configurar Powerlevel10k
Si instalaste Powerlevel10k, al abrir una nueva terminal verás el asistente:
```bash
p10k configure
```

### Iniciar Neovim + NvChad
```bash
nvim
# La primera vez descargará plugins automáticamente
```

### Aliases Disponibles

**Si instalaste `lsd`:**
```bash
ll    # ls -lh con iconos
la    # ls -a con iconos
lla   # ls -lha con iconos
ls    # lsd con iconos
```

**Si instalaste `batcat`:**
```bash
cat archivo.txt     # Con resaltado de sintaxis
catn archivo.txt    # cat normal (sin batcat)
catnl archivo.txt   # batcat sin paginación
```

---

## 🔍 Solución de Problemas Comunes

### Error: "lsd not found" en Ubuntu 22.04 / Debian 11

**Causa:** `lsd` no está en repos oficiales

**Solución automática:** El script instala desde Snap o GitHub

**Solución manual:**
```bash
sudo snap install lsd
# O
cargo install lsd
# O
wget https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb
sudo dpkg -i lsd_1.1.5_amd64.deb
```

### Error: Neovim no inicia

**Causa:** Versión incompatible con GLIBC del sistema

**Verificar GLIBC:**
```bash
ldd --version
# Ubuntu 22.04 / Debian 11: 2.31-2.35
# Ubuntu 24.04 / Debian 12: 2.36+
```

**Solución:** El script ya selecciona la versión correcta automáticamente

### Powerlevel10k no muestra iconos

**Causa:** Terminal no usa una fuente con soporte para iconos

**Solución:**
```bash
# El script instala Hack Nerd Font automáticamente
# Configura tu terminal para usar "Hack Nerd Font"
```

### Cambio de shell no se aplica

**Solución:**
```bash
chsh -s $(which zsh)
# Luego cierra sesión y vuelve a entrar
# O reinicia el sistema
```

### batcat vs bat

**Problema:** En algunas versiones el comando es `batcat` y en otras `bat`

**Solución automática:** El script detecta cuál está disponible y crea aliases apropiados

---

## 📚 Recursos y Referencias

### Documentación Oficial
- [Oh My Zsh](https://ohmyz.sh/) - Framework de Zsh
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Tema para Zsh
- [Neovim](https://neovim.io/) - Editor de texto
- [NvChad](https://nvchad.com/) - Configuración Neovim
- [lsd](https://github.com/lsd-rs/lsd) - ls moderno
- [bat](https://github.com/sharkdp/bat) - cat mejorado
- [Nerd Fonts](https://www.nerdfonts.com/) - Fuentes con iconos

### Script de Diagnóstico

- `verificar_sistema.sh` - Verificación del sistema con modo simple/detallado

---

## 🎯 Casos de Uso

### Desarrollador Full Stack
```bash
# Instalar todo para máxima productividad
bash personalizarTerminal.sh
# Responder "s" (sí) a todas las opciones
```

### Minimalista
```bash
# Solo Zsh + Oh My Zsh + Plugins básicos
bash personalizarTerminal.sh
# Responder "n" a Powerlevel10k, lsd, batcat y Neovim
```

### Servidor Remoto
```bash
# Sin componentes visuales pesados
bash personalizarTerminal.sh
# Solo Zsh, Oh My Zsh y plugins
# Evitar Powerlevel10k y fuentes
```

---

## 🤝 Contribuir

¿Encontraste un bug o tienes una sugerencia de mejora?

1. Fork el repositorio
2. Crea una rama para tu feature: `git checkout -b feature/mi-mejora`
3. Commit tus cambios: `git commit -am 'Añadir mi mejora'`
4. Push a la rama: `git push origin feature/mi-mejora`
5. Crea un Pull Request

### Issues Conocidos
- Debian 10 (Buster) y anteriores no son soportados oficialmente
- Snap puede no estar disponible en algunas instalaciones mínimas de Debian

---

## 📝 Changelog

### v2.0 (22 Octubre 2025)
- ✅ Añadido soporte completo para Debian 11 y 12
- ✅ Detección automática de distribución (Ubuntu/Debian)
- ✅ Corrección de errores de sintaxis críticos
- ✅ Adaptación inteligente según versión del sistema
- ✅ Selección automática de versión de Neovim según GLIBC
- ✅ Instalación alternativa de lsd para sistemas sin repos oficiales
- ✅ Manejo automático de diferencias batcat vs bat
- ✅ Verificación e instalación de rsync
- ✅ Documentación consolidada en README.md único

### v1.0 (Inicial)
- Script básico para Ubuntu 24.04

---

## 📄 Licencia

Este proyecto está bajo licencia libre. Úsalo, modifícalo y compártelo libremente.

---

## 👤 Autor

**Noel Ballester**
- GitHub: [@NoelBallester](https://github.com/NoelBallester)
- Repositorio: [customZsh](https://github.com/NoelBallester/customZsh)

---

## ⭐ Agradecimientos

Agradecimientos especiales a los desarrolladores y mantenedores de:
- Oh My Zsh team
- Roman Perepelitsa (Powerlevel10k)
- Neovim team
- NvChad team
- Comunidad de Zsh y herramientas CLI modernas

---

## 🚀 ¿Te resultó útil?

Si este script te ayudó a configurar tu terminal, considera:
- ⭐ Dar una estrella al repositorio
- 🐛 Reportar bugs o sugerir mejoras
- 🔀 Compartir con otros desarrolladores

---

**Happy coding! 💻✨**
