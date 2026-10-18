#!/usr/bin/env bash
# ==============================================================================
# 04_launch_jupyter_vscode.sh
# Launches VS Code or VSCodium with Cling C++ environment paths exported.
# ==============================================================================

MAMBA_ROOT="${HOME}/micromamba"
ENV_PATH="${MAMBA_ROOT}/envs/cling-env"

if [ -d "${ENV_PATH}" ]; then
    # Prepend cling-env bin and lib to PATH and LD_LIBRARY_PATH
    export PATH="${ENV_PATH}/bin:${PATH}"
    export LD_LIBRARY_PATH="${ENV_PATH}/lib:${LD_LIBRARY_PATH:-}"
    export JUPYTER_PATH="${ENV_PATH}/share/jupyter:${HOME}/.local/share/jupyter"
fi

# Detect whether vscodium or code is installed:
if command -v codium &>/dev/null; then
    exec codium "$@"
elif command -v code &>/dev/null; then
    exec code "$@"
else
    echo "Neither 'codium' nor 'code' was found on PATH."
    echo "Install via: yay -S vscodium-bin (or code)"
    exit 1
fi
