#!/usr/bin/env bash
# ==============================================================================
# 05_setup_dosbox_assembly.sh
# Sets up DOSBox, native NASM, and 8086 Assembly workspace with AFD support.
# ==============================================================================

set -euo pipefail

echo "=========================================================================="
echo " [1/3] Installing DOSBox and NASM via Pacman..."
echo "=========================================================================="
sudo pacman -S --needed --noconfirm dosbox nasm wget

echo "=========================================================================="
echo " [2/3] Initializing Assembly workspace structure..."
echo "=========================================================================="
WORKSPACE="${HOME}/assembly"
mkdir -p "${WORKSPACE}/bin"
mkdir -p "${WORKSPACE}/src"
mkdir -p "${WORKSPACE}/build"

# Create a sample 8086 program
cat <<'EOF' > "${WORKSPACE}/src/hello.asm"
[org 0x0100]
    mov dx, msg
    mov ah, 0x09
    int 0x21

    mov ax, 0x4c00
    int 0x21

msg: db 'Hello from Arch Linux 8086 Assembly!', 0x0d, 0x0a, '$'
EOF

# Assemble sample program natively
nasm -f bin "${WORKSPACE}/src/hello.asm" -o "${WORKSPACE}/build/hello.com"

echo "=========================================================================="
echo " [3/3] Configuring DOSBox Autoexec..."
echo "=========================================================================="
DOSBOX_DIR="${HOME}/.dosbox"
mkdir -p "${DOSBOX_DIR}"

# Find default conf or generate one
CONF_FILE="${DOSBOX_DIR}/dosbox-0.74-3.conf"
if [ ! -f "${CONF_FILE}" ]; then
    dosbox -printconf > "${CONF_FILE}" 2>/dev/null || true
fi

# Ensure autoexec mounts the assembly workspace
if ! grep -q "mount c ~/assembly" "${CONF_FILE}" 2>/dev/null; then
    cat <<EOF >> "${CONF_FILE}"

[autoexec]
mount c ~/assembly
c:
path c:\bin;%PATH%
cls
echo ===================================================
echo  8086 Assembly Workspace Ready (NASM + AFD)
echo  Run: afd build\hello.com
echo ===================================================
EOF
fi

echo ""
echo "=========================================================================="
echo " [SUCCESS] Assembly workspace created at ~/assembly"
echo " Place afd.exe into ~/assembly/bin/ and run 'dosbox' to start."
echo "=========================================================================="
