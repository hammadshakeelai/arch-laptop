# 8086 Assembly Programming Environment: DOSBox, NASM, and AFD

This guide provides a complete, turnkey 8086 Assembly setup using **DOSBox**, **NASM**, and the **AFD (Advanced Fullscreen Debugger)**.

---

## 1. Components

- **DOSBox** (or DOSBox-Staging): The x86 PC emulator providing the MS-DOS real-mode environment.
- **NASM**: Both native Linux NASM (for fast command-line assembly) and DOS NASM (for running inside DOSBox).
- **AFD (`afd.exe`)**: Advanced Fullscreen Debugger, providing a multi-pane visual TUI showing CPU registers (AX, BX, CX, DX, SI, DI, BP, SP), flags, memory segment viewer, and disassembled code.

---

## 2. Directory Layout

The workspace is organized as:
```
~/assembly/
├── bin/
│   ├── afd.exe          # Advanced Fullscreen Debugger
│   ├── nasm.exe         # 16-bit DOS NASM binary
│   └── alink.exe        # Alink linker for 16-bit OBJ files
├── src/                 # Your .asm source files
│   └── hello.asm
└── build/               # Generated .com and .exe binaries
```

---

## 3. Automated Setup Script

Run the automated script:
```bash
chmod +x scripts/05_setup_dosbox_assembly.sh
./scripts/05_setup_dosbox_assembly.sh
```

This installs `dosbox` and `nasm`, configures `~/.dosbox/dosbox-0.74-3.conf`, and injects the `[autoexec]` section to automatically mount `~/assembly` as drive `C:` and set `PATH=C:\BIN`.

---

## 4. DOSBox Autoexec Configuration

In `~/.dosbox/dosbox-0.74-3.conf` (or `configs/dosbox.conf`), the following lines are placed at the bottom:

```ini
[autoexec]
# Mount the local Linux assembly folder as DOS Drive C:
mount c ~/assembly
c:
path c:\bin;%PATH%
cls
echo ===================================================
echo  8086 Assembly Workspace Ready (NASM + AFD)
echo  Commands:
echo    nasm -f bin src\code.asm -o build\code.com
echo    afd build\code.com
echo ===================================================
```

---

## 5. Workflow Example: Write, Assemble, and Debug

### 1. Write Code (`~/assembly/src/test.asm`):
```nasm
[org 0x0100]
    mov ax, 0x1234
    mov bx, 0x5678
    add ax, bx
    mov cx, ax
    
    mov ax, 0x4c00
    int 0x21
```

### 2. Assemble via Linux terminal:
```bash
nasm -f bin ~/assembly/src/test.asm -o ~/assembly/build/test.com
```

### 3. Launch AFD inside DOSBox:
Launch DOSBox:
```bash
dosbox
```
Inside the DOSBox prompt:
```dos
afd build\test.com
```

### Key AFD Controls:
- **`F1` / `F2`**: Step Into / Step Over instructions
- **`F4`**: Run until breakpoint or termination
- **`d <segment>:<offset>`**: Dump memory
- **`q`**: Quit debugger
