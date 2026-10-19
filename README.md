# Arch Linux Workstation & Migration Master Repository

A turnkey, production-grade blueprint, migration history, and automation suite for the **MECHREVO R14P / Code 01** (AMD Ryzen 5 7430U, 8GB RAM, unified 171GB Btrfs NVMe pool).

This repository preserves the complete record of the migration from Ubuntu to Arch Linux, replicates the familiar Ubuntu aesthetics and startup chime, and provides a Windows-user-optimized productivity suite along with a fully local, offline AI stack (PewDiePie's Odysseus AI + Ollama 3B Abliterated).

---

## 📚 Complete Conversation & Knowledge Base

| Resource | Description |
| :--- | :--- |
| **[FULL_CHAT_LOG.md](FULL_CHAT_LOG.md)** | **Complete, verbatim conversation record** (940+ steps) covering every decision, command, debugging step, and fix from start to finish. |
| **[Windows Experience Blueprint](docs/windows_user_complete_linux_experience.md)** | Detailed gap analysis and solutions for Windows power users moving to Arch Linux (fonts, shortcuts, search, phone link, and office). |
| **[Arch Migration Blueprint](docs/arch_migration_blueprint.md)** | Storage architecture, tiered 39.2GB swap setup, GNOME + `ly` auto-unlock, and salvage inventory. |
| **[Documentation Directory](docs/)** | 12 in-depth architectural guides for hardware, kernels, assembly, and virtualization. |

---

## 🧠 Accessing from Antigravity on the Laptop

To load this entire conversation's brain and memory directly into Antigravity running on the Arch laptop:

```bash
# 1. Clone this private repository onto the laptop:
git clone https://github.com/hammadshakeelai/arch-laptop.git ~/arch-laptop

# 2. Sync the brain conversation session into your laptop's Antigravity directory:
mkdir -p ~/.gemini/antigravity/brain/8985db24-12f2-4ed0-9104-89fcac84b84e
cp -r ~/arch-laptop/brain/8985db24-12f2-4ed0-9104-89fcac84b84e/* ~/.gemini/antigravity/brain/8985db24-12f2-4ed0-9104-89fcac84b84e/
```

Once synced, open `~/arch-laptop` in Antigravity. The agent will have access to the full conversation transcript, system state, and artifacts.

---

## ⚡ Active System State on Laptop

### 1. Local AI Workspace
* **Odysseus AI:** Background systemd service (`odysseus.service`) listening on `http://127.0.0.1:7011`.
* **Launch:** Click **Odysseus AI** in GNOME App Grid or run `odysseus` in any terminal to open directly in Google Chrome (single-user mode, no login required).
* **Models in Ollama:**
  * `huihui_ai/llama3.2-abliterate:3b` (Uncensored / Abliterated 3B model, ~68 tokens/sec on Ryzen CPU).
  * `llama3.2:3b` (Official Meta Llama 3.2 3B).

### 2. Office & Academic Tools
* **OnlyOffice Desktop Editors:** Full Microsoft Office ribbon compatibility (`onlyoffice`).
* **MarkText:** WYSIWYG Markdown editor with live KaTeX math and tables (`marktext`).
* **TeXstudio & TeXLive:** Offline LaTeX compilation with side-by-side PDF preview (`texstudio`).
* **LibreOffice Fresh:** Offline office power suite (`libreoffice`).

### 3. Windows 11 Quality-of-Life Parity
* **Clipboard History (`Super + V`):** Press `Win + V` to open the persistent multi-clip history popup.
* **Instant Drive Search (`FSearch`):** Instant C/GTK file search across your entire Btrfs drive (`fsearch`).
* **Spacebar Quick Look:** Press `Space` in Files (Nautilus) on any image, PDF, audio, or video for instant preview.
* **Right-Click "New Document":** Pre-populated in `~/Templates` with Word (`.docx`), Excel (`.xlsx`), LaTeX (`.tex`), Markdown (`.md`), and Text (`.txt`).
* **Authentic Windows 11 Fonts:** 35 TrueType fonts installed in `~/.local/share/fonts/windows/` (Calibri, Arial, Times New Roman, Segoe UI, Consolas, Georgia, Verdana).
* **Android Phone Link (`GSConnect`):** Pair with the KDE Connect app on your Android phone to sync clipboard, transfer files, and send SMS.
* **Audio & Codecs:** `easyeffects` (laptop speaker bass boost & RNNoise microphone noise suppression), VLC media player, `7zip`, `unrar`, and `file-roller`.

### 4. Memory & Performance Tuning
* **Total Swap: 39.2 GB:**
  * `/dev/zram0` (7.2 GB, Priority 100, `zstd` compressed in-RAM swap).
  * `/swapfile` (32 GB, Priority 10, Btrfs non-CoW dedicated file).
* **Kernel Sysctl:** `vm.swappiness = 180`, `vm.page-cluster = 0` in `/etc/sysctl.d/99-vm-zram-parameters.conf`.
* **Lid Switch:** `HandleLidSwitch=ignore` in `/etc/systemd/logind.conf.d/ignore-lid.conf`.
* **Display Manager:** `ly` greeter with PAM auto-unlock (`pam_gnome_keyring.so`) and `Super + L` screen lock via `gtklock`.

---

## 🛠️ Repository Layout

```
arch-laptop/
├── README.md                              <- Master documentation and system overview
├── FULL_CHAT_LOG.md                       <- Full conversation record (940+ steps)
├── brain/                                 <- Machine-readable Antigravity session brain
│   └── 8985db24-12f2-4ed0-9104-89fcac84b84e/
│       ├── .system_generated/logs/        <- transcript.jsonl & transcript_full.jsonl
│       ├── .user_uploaded/                <- Original uploaded screenshots
│       └── *.md                           <- Session blueprints and metadata
├── docs/                                  <- Architecture guides & parity blueprints
│   ├── windows_user_complete_linux_experience.md
│   ├── arch_migration_blueprint.md
│   └── 01-12 guides...
├── scripts/                               <- Staged automation & maintenance scripts
└── configs/                               <- Dotfiles, dconf dumps, and systemd units
```
