#!/usr/bin/env bash
# ==============================================================================
# 03_setup_jupyter_cling.sh
# Sets up xeus-cling C++ kernel for Jupyter and VS Code / VSCodium on Arch Linux.
# ==============================================================================

set -euo pipefail

echo "=========================================================================="
echo " [1/4] Checking and Installing Micromamba..."
echo "=========================================================================="

MAMBA_ROOT="${HOME}/micromamba"
export MAMBA_ROOT_PREFIX="${MAMBA_ROOT}"

if ! command -v micromamba &>/dev/null; then
    echo "Downloading standalone micromamba binary..."
    TEMP_DIR=$(mktemp -d)
    curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj -C "${TEMP_DIR}" bin/micromamba
    sudo install -m 755 "${TEMP_DIR}/bin/micromamba" /usr/local/bin/micromamba
    rm -rf "${TEMP_DIR}"
fi

echo "Micromamba version: $(micromamba --version)"

echo "=========================================================================="
echo " [2/4] Creating dedicated 'cling-env' with C++ compiler and kernels..."
echo "=========================================================================="

micromamba create -y -n cling-env -c conda-forge \
    xeus-cling \
    jupyterlab \
    ipykernel \
    notebook \
    compilers

echo "=========================================================================="
echo " [3/4] Registering C++ kernels globally with Jupyter..."
echo "=========================================================================="

KERNELS_SRC="${MAMBA_ROOT}/envs/cling-env/share/jupyter/kernels"
KERNELS_DST="${HOME}/.local/share/jupyter/kernels"
mkdir -p "${KERNELS_DST}"

for k in xcpp11 xcpp14 xcpp17; do
    if [ -d "${KERNELS_SRC}/${k}" ]; then
        echo "   Registering ${k}..."
        rm -rf "${KERNELS_DST:?}/${k}"
        cp -r "${KERNELS_SRC}/${k}" "${KERNELS_DST}/"
        
        # Ensure the kernel.json points directly to the micromamba bin/xcpp
        sed -i "s|\"xcpp\"|\"${MAMBA_ROOT}/envs/cling-env/bin/xcpp\"|g" "${KERNELS_DST}/${k}/kernel.json"
    fi
done

echo "=========================================================================="
echo " [4/4] Verifying installed kernels..."
echo "=========================================================================="
"${MAMBA_ROOT}/envs/cling-env/bin/jupyter" kernelspec list

echo ""
echo "=========================================================================="
echo " [SUCCESS] C++ Jupyter Kernel setup is complete!"
echo " Kernels registered:"
echo "   - C++11 (xeus-cling)"
echo "   - C++14 (xeus-cling)"
echo "   - C++17 (xeus-cling)"
echo " Use scripts/04_launch_jupyter_vscode.sh to open VS Code with C++ Jupyter ready."
echo "=========================================================================="
