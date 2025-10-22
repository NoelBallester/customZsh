# 🐧 Compatibilidad con Debian

## ✅ Versiones soportadas

| Distribución | Versión | Nombre código | Estado | Notas |
|--------------|---------|---------------|--------|-------|
| **Ubuntu** | 24.04 LTS | Noble Numbat | ✅ Totalmente compatible | Todos los paquetes en repos |
| **Ubuntu** | 22.04 LTS | Jammy Jellyfish | ✅ Compatible | Adaptaciones automáticas |
| **Debian** | 12 | Bookworm | ✅ Totalmente compatible | Similar a Ubuntu 24.04 |
| **Debian** | 11 | Bullseye | ✅ Compatible | Similar a Ubuntu 22.04 |
| **Debian** | 10 | Buster | ⚠️ Parcial | Requiere paquetes externos |

---

## 📦 Disponibilidad de paquetes por distribución

### Ubuntu 24.04 / Debian 12 (Bookworm)

| Paquete | Disponible | Instalación |
|---------|-----------|-------------|
| zsh | ✅ Sí | `apt install zsh` |
| git | ✅ Sí | `apt install git` |
| curl | ✅ Sí | `apt install curl` |
| **lsd** | ✅ Sí | `apt install lsd` |
| **bat** | ✅ Sí | `apt install bat` |
| build-essential | ✅ Sí | `apt install build-essential` |
| rsync | ✅ Sí | `apt install rsync` |
| fontconfig | ✅ Sí | `apt install fontconfig` |

**GLIBC:** 2.36+ (Debian 12) / 2.39+ (Ubuntu 24.04)
**Neovim recomendado:** v0.11.4

---

### Ubuntu 22.04 / Debian 11 (Bullseye)

| Paquete | Disponible | Instalación |
|---------|-----------|-------------|
| zsh | ✅ Sí | `apt install zsh` |
| git | ✅ Sí | `apt install git` |
| curl | ✅ Sí | `apt install curl` |
| **lsd** | ❌ No | Snap/GitHub/Cargo |
| **bat** | ⚠️ Como `batcat` | `apt install bat` |
| build-essential | ✅ Sí | `apt install build-essential` |
| rsync | ✅ Sí | `apt install rsync` |
| fontconfig | ✅ Sí | `apt install fontconfig` |

**GLIBC:** 2.31 (Debian 11) / 2.35 (Ubuntu 22.04)
**Neovim recomendado:** v0.9.5

---

### Debian 10 (Buster) - Soporte limitado

| Paquete | Disponible | Instalación |
|---------|-----------|-------------|
| zsh | ✅ Sí | `apt install zsh` |
| git | ✅ Sí | `apt install git` |
| curl | ✅ Sí | `apt install curl` |
| **lsd** | ❌ No | Compilar desde fuente |
| **bat** | ❌ No | Compilar desde fuente |
| build-essential | ✅ Sí | `apt install build-essential` |

**GLIBC:** 2.28 (muy antigua)
**Neovim recomendado:** v0.7.x o anterior
**Nota:** No recomendado, muchas incompatibilidades

---

## 🔧 Adaptaciones automáticas del script

El script detecta automáticamente:

1. **Distribución** (`ubuntu` vs `debian`)
2. **Versión** (22.04, 24.04, 11, 12, etc.)
3. **Paquetes disponibles** en repositorios oficiales
4. **Versión de GLIBC** para seleccionar Neovim apropiado

### Ejemplo de detección:

```bash
if [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" == "12" ]]; then
    # Debian 12 - usar repos oficiales
    sudo apt install -y lsd
elif [[ "$DISTRO_ID" == "debian" && "$DISTRO_VERSION" == "11" ]]; then
    # Debian 11 - usar Snap o GitHub
    sudo snap install lsd
fi
```

---

## 🚀 Instalación en Debian

### Debian 12 (Bookworm) - Recomendado

```bash
# 1. Actualizar sistema
sudo apt update && sudo apt upgrade -y

# 2. Ejecutar script
bash personalizarTerminal.sh
```

**Resultado esperado:** ✅ Todos los componentes se instalan sin problemas

---

### Debian 11 (Bullseye)

```bash
# 1. Actualizar sistema
sudo apt update && sudo apt upgrade -y

# 2. (Opcional) Habilitar Snap si quieres lsd
sudo apt install snapd
sudo systemctl enable --now snapd.socket

# 3. Ejecutar script
bash personalizarTerminal.sh
```

**Adaptaciones automáticas:**
- `lsd`: Se instala vía Snap o descarga .deb desde GitHub
- `bat`: Alias automático si se llama `batcat`
- `Neovim`: Usa versión 0.9.5 compatible con GLIBC 2.31

---

### Debian 10 (Buster) - No recomendado

Debian 10 tiene paquetes muy antiguos. Considera actualizar a Debian 11 o 12.

Si insistes en usar Debian 10:

```bash
# Advertencia: Muchos paquetes no funcionarán
# Considera usar Debian 11 o 12 en su lugar
```

---

## 🔍 Diferencias clave Debian vs Ubuntu

| Aspecto | Debian | Ubuntu |
|---------|--------|--------|
| **Filosofía** | Estabilidad extrema | Balance estabilidad/actualidad |
| **Ciclo de release** | ~2 años (Stable) | 6 meses (regular) / 2 años (LTS) |
| **Paquetes** | Más conservadores | Más actualizados |
| **Snap** | No por defecto | Incluido por defecto |
| **Soporte** | Comunidad | Canonical + Comunidad |

---

## 📊 Tabla de compatibilidad GLIBC

| Distribución | Versión | GLIBC | Neovim recomendado |
|--------------|---------|-------|-------------------|
| Debian 12 | Bookworm | 2.36 | ✅ v0.11.4 |
| Debian 11 | Bullseye | 2.31 | ⚠️ v0.9.5 |
| Debian 10 | Buster | 2.28 | ❌ v0.7.x |
| Ubuntu 24.04 | Noble | 2.39 | ✅ v0.11.4 |
| Ubuntu 22.04 | Jammy | 2.35 | ⚠️ v0.9.5 |

---

## ✅ Resumen

**¿Funciona en Debian?**

- **Debian 12 (Bookworm)**: ✅ SÍ, funciona perfectamente
- **Debian 11 (Bullseye)**: ✅ SÍ, con adaptaciones automáticas
- **Debian 10 (Buster)**: ⚠️ Soporte limitado, mejor actualizar

**El script ahora detecta automáticamente Debian y aplica las configuraciones apropiadas.**
