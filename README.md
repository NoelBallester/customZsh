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

- **Ubuntu 24.04 LTS** (recomendado - soporte completo)
- **Ubuntu 22.04 LTS** (compatible con adaptaciones automáticas)

### � Adaptaciones automáticas para Ubuntu 22.04

El script ahora **detecta automáticamente** la versión de Ubuntu y realiza las siguientes adaptaciones:

1. **lsd**: Se instala desde Snap o GitHub en lugar de repositorios oficiales
2. **batcat**: Detecta si el comando es `bat` o `batcat` y crea aliases apropiados
3. **Neovim**: Usa versión 0.9.5 (compatible con GLIBC 2.35) en lugar de 0.11.4
4. **rsync**: Verifica e instala automáticamente si falta

### 📌 Requerimientos mínimos

- Ubuntu 22.04 LTS o superior
- Conexión a Internet
- Permisos de sudo
- Git, curl y wget (se instalan automáticamente si faltan)

## 🚀 Ejecución
```bash
chmod +x personalizarTerminal.sh
bash personalizarTerminal.sh
```
El script es interactivo y pregunta al usuario si desea instalar cada componente. Esto permite personalizar la ejecución según las necesidades del entorno.

> ⚠️ **Nota importante**: El script ahora valida correctamente la sintaxis y ha sido corregido para evitar errores de ejecución.

### 🧪 Verificar compatibilidad (opcional)

Antes de ejecutar, puedes verificar la compatibilidad de tu sistema:

```bash
bash test_compatibilidad.sh
```

Este script verifica:
- Versión de Ubuntu
- Disponibilidad de comandos requeridos
- Paquetes en repositorios
- Versión de Neovim recomendada

### 📄 Documentación adicional

- **`COMPATIBILIDAD.md`**: Análisis detallado de diferencias entre Ubuntu 24.04 y 22.04
- **`test_compatibilidad.sh`**: Script de verificación rápida del sistema
- **`verificar_compatibilidad.sh`**: Diagnóstico completo de compatibilidad

---

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
