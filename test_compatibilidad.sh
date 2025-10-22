#!/usr/bin/env bash

# Test rápido de compatibilidad del script

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Test de compatibilidad - personalizarTerminal.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Detectar versión
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "✓ Sistema: $PRETTY_NAME"
    echo "✓ Versión: $VERSION_ID"
else
    echo "✗ No se pudo detectar la versión"
    exit 1
fi

echo ""
echo "━━━━ Verificando sintaxis del script ━━━━"
if bash -n personalizarTerminal.sh 2>/dev/null; then
    echo "✓ Sintaxis correcta"
else
    echo "✗ Error de sintaxis detectado"
    bash -n personalizarTerminal.sh
    exit 1
fi

echo ""
echo "━━━━ Comandos requeridos ━━━━"
for cmd in git curl wget unzip fc-cache; do
    if command -v "$cmd" &>/dev/null; then
        echo "✓ $cmd instalado"
    else
        echo "✗ $cmd NO instalado"
    fi
done

echo ""
echo "━━━━ Disponibilidad de paquetes ━━━━"

# lsd
if [[ "$VERSION_ID" == "24.04" ]]; then
    echo "✓ lsd disponible en repos (Ubuntu 24.04)"
else
    echo "⚠ lsd NO en repos - se usará Snap/GitHub (Ubuntu $VERSION_ID)"
fi

# batcat
if apt-cache show bat &>/dev/null 2>&1; then
    echo "✓ bat/batcat disponible"
else
    echo "✗ bat/batcat NO disponible"
fi

# Neovim version check
echo ""
echo "━━━━ Versión de Neovim recomendada ━━━━"
if [[ "$VERSION_ID" == "22.04" ]]; then
    echo "→ Neovim 0.9.5 (compatible con GLIBC 2.35)"
else
    echo "→ Neovim 0.11.4 (última versión)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ El script está listo para ejecutarse"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
