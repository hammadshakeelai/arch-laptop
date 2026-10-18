# Jupyter C++ (Cling / Xeus-Cling / Clang) Integration in VS Code & VSCodium

Running interactive C++ inside Jupyter Notebooks within VS Code / VSCodium is an incredible tool for rapid prototyping, algorithm development, and low-level experimentation. However, setting it up on Arch Linux is notoriously difficult due to LLVM version conflicts.

This document details why the setup breaks and provides a robust, fail-safe environment using `xeus-cling`.

---

## 1. The Challenge on Arch Linux

Arch Linux provides the absolute latest rolling LLVM/Clang (LLVM 18/19+). However:
- `xeus-cling` (the QuantStack C++ Jupyter kernel based on CERN's Cling) requires specific patched LLVM builds.
- Attempting to compile `xeus-cling` against native Arch rolling LLVM causes ABI mismatches and segfaults.
- **The Solution**: An isolated Conda/Micromamba environment via `conda-forge`. This vendors the exact Clang/LLVM and Cling runtime without polluting your host Arch system, while exposing the C++ kernels directly to native VS Code / VSCodium!

---

## 2. Automated One-Command Installation

Run the provided script:
```bash
chmod +x scripts/03_setup_jupyter_cling.sh
./scripts/03_setup_jupyter_cling.sh
```

---

## 3. How the Setup Works Internally

### Step 3.1: Install Micromamba (Ultra-fast, C++ alternative to Conda)
```bash
# Download standalone micromamba binary:
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
sudo mv bin/micromamba /usr/local/bin/
```

### Step 3.2: Create the Dedicated `cling-env`
```bash
micromamba create -y -n cling-env -c conda-forge \
    xeus-cling \
    jupyterlab \
    ipykernel \
    notebook
```

This installs:
- `xeus-cling` compiled with CERN Cling and Clang
- Support for `C++11`, `C++14`, and `C++17`

### Step 3.3: Register Kernels Globally with Jupyter
To make the kernels discoverable by VS Code, VSCodium, and system Jupyter:
```bash
MAMBA_ROOT="${HOME}/micromamba"
KERNELS_SRC="${MAMBA_ROOT}/envs/cling-env/share/jupyter/kernels"
KERNELS_DST="${HOME}/.local/share/jupyter/kernels"

mkdir -p "${KERNELS_DST}"
cp -r "${KERNELS_SRC}/xcpp11" "${KERNELS_DST}/"
cp -r "${KERNELS_SRC}/xcpp14" "${KERNELS_DST}/"
cp -r "${KERNELS_SRC}/xcpp17" "${KERNELS_DST}/"
```

Each `kernel.json` specifies the argv pointing to the environment binary:
```json
{
  "display_name": "C++17 (xeus-cling)",
  "argv": [
    "/home/hammad/micromamba/envs/cling-env/bin/xcpp",
    "-f",
    "{connection_file}",
    "-std=c++17"
  ],
  "language": "C++17"
}
```

---

## 4. Running Inside VS Code / VSCodium

### Launcher Script: `launch_jupyter_vscode.sh`
To guarantee VS Code inherits all Clang shared libraries (`libclang.so`, `libcling.so`), launch VS Code using [scripts/04_launch_jupyter_vscode.sh](file:///c:/Users/HP/Documents/GitHub/arch-laptop/scripts/04_launch_jupyter_vscode.sh):

```bash
chmod +x scripts/04_launch_jupyter_vscode.sh
./scripts/04_launch_jupyter_vscode.sh
```

### Testing the C++ Kernel:
1. Open or create a new notebook: `test_cpp.ipynb`.
2. Click the kernel picker in the top right corner of VS Code.
3. Select **Jupyter Kernel...** -> **C++17 (xeus-cling)**.
4. Run the following cell:

```cpp
#include <iostream>
#include <vector>
#include <numeric>

std::vector<int> v = {1, 2, 3, 4, 5};
int sum = std::accumulate(v.begin(), v.end(), 0);
std::cout << "Sum = " << sum << std::endl;
```

**Output**:
```
Sum = 15
```
It compiles and executes dynamically on the fly!
