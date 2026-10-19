# The Windows-to-Arch Linux Experience & Parity Blueprint

> [!NOTE]
> **Safety Status:** No files, directories, or caches were deleted or cleaned, strictly honoring your request. Everything on your drive remains intact.

This blueprint identifies everything that Windows users expect out of the box, reveals where bare Linux falls short by default, and demonstrates how we have upgraded your Arch Linux system into an effortless, polished, and superior daily driver.

---

## 1. Feature Parity Matrix: Windows vs. Arch Linux

| Windows Feature | Bare Arch Default | Upgraded Solution on Your Laptop | Live Status |
| :--- | :--- | :--- | :--- |
| **Spacebar Quick Look** (PowerToys / macOS style) | None | **GNOME Sushi** (`sushi`) — tap `Space` on any PDF, image, audio, or text for an instant preview | ✅ Installed & Verified |
| **Right-Click "New Document"** | Missing in Nautilus (empty context menu) | **Nautilus Templates** in `~/Templates` (`.txt`, `.md`, `.docx`, `.xlsx`, `.tex`) | ✅ Configured & Verified |
| **Instant Drive Search** (*Everything* by Voidtools) | Basic search only | **FSearch** (`fsearch`) — instantaneous real-time file search across your entire Btrfs drive | ✅ Installed (`/usr/bin/fsearch`) |
| **Clipboard History** (`Win + V`) | Single clipboard | **Clipboard Indicator** — persistent multi-item clipboard history mapped to **Super + V** | ✅ Active & Bound to `Super + V` |
| **Phone Link** (Android sync) | None | **GSConnect** — sync clipboard, send SMS, transfer files in 1 click, view phone battery & notifications | ✅ Installed & Enabled |
| **7-Zip & WinRAR Archives** | Terminal-only or unsupported | **File Roller + 7zip + Unrar** — right-click "Extract Here" / "Compress" for all formats | ✅ Installed & Verified |
| **NTFS / exFAT USB Support** | Read-only or missing drivers | **ntfs-3g + exfatprogs** — full plug-and-play support for any Windows drive or external SSD | ✅ Installed & Verified |
| **MS Office Typography** (Calibri, Times, Arial, Segoe UI) | Missing (causes broken document layouts) | **35 Genuine Windows 11 TrueType Fonts** (Calibri, Arial, Times New Roman, Segoe UI, Consolas, Georgia, Verdana) | ✅ Transferred & Cached |
| **MS Office Suite** | None | **OnlyOffice Desktop Editors** (100% native ribbon interface & .docx/.xlsx/.pptx fidelity) + **LibreOffice Fresh** | ✅ Installed & Verified |
| **Offline LaTeX Environment** | None | **TeXstudio + TeXLive** — 1-click compile with live side-by-side PDF preview | ✅ Installed & Verified |
| **Rich Markdown Editor** | None | **MarkText** — Typora-like WYSIWYG editor with live KaTeX math & table formatting | ✅ Installed & Verified |
| **Media Codecs & Player** | Restricted formats | **VLC Media Player + FFmpeg + GStreamer plugins** (plays every video/audio codec) | ✅ Installed & Verified |
| **Laptop Audio Enhancement** | Flat OEM speaker output | **EasyEffects** PipeWire DSP — laptop speaker bass/clarity boost & mic noise suppression (`rnnoise` + `lsp-plugins`) | ✅ Installed & Verified |
| **Battery Power Modes** | Default scheduler | **power-profiles-daemon** — native GNOME Quick Settings slider (Power Saver / Balanced / Performance) | ✅ Installed & Verified |
| **Local AI Workspace** | None | **PewDiePie's Odysseus AI + Ollama (Llama 3.2 3B & Abliterated 3B)** with desktop icon & system service | ✅ Active & Running (Port 7011) |

---

## 2. Deep Dive: Key Windows Gaps Solved

### A. Document Layouts & Fonts
- **The Problem:** When opening a Microsoft Word `.docx` or PowerPoint `.pptx` on a fresh Linux install, Linux substitutes missing fonts (like Calibri or Segoe UI) with Liberation Sans or DejaVu. This subtly changes character widths, breaking page counts, table alignments, and slide layouts.
- **The Fix:** Installed 35 authentic Microsoft TrueType fonts (`~/.local/share/fonts/windows/`), covering all weights and styles of **Calibri, Arial, Times New Roman, Segoe UI, Consolas, Georgia, and Verdana**.

### B. Explorer Quality of Life
- **Right-Click Templates:** Populated `~/Templates` so Nautilus now presents:
  - `New Word Document.docx`
  - `New Excel Spreadsheet.xlsx`
  - `New LaTeX Document.tex`
  - `New Markdown Document.md`
  - `New Text Document.txt`
- **Instant Preview:** Tap `Spacebar` in the file manager on any file to immediately preview it without launching an application.
- **Voidtools Everything Alternative:** Launch `fsearch` from the app grid or terminal for lightning-fast search across your drive.

### C. Phone Link Parity (GSConnect)
- Seamless wireless integration with your Android phone over your local Wi-Fi network:
  - Copy text on your phone and paste it directly on your laptop (shared clipboard).
  - Reply to SMS messages from desktop notifications.
  - Send photos, downloads, or links from phone to laptop in 1 tap.
  - Ring your phone from your laptop if you misplace it.
  - *To connect:* Open the KDE Connect app on your Android phone while connected to the same Wi-Fi, and tap your laptop's name to pair.

### D. Audio & Microphone Tuning (EasyEffects)
- **Speaker Enhancer:** Bass enhancement and loudness equalizer presets tailored for thin laptop speakers.
- **Microphone DeepFilter / RNNoise:** Removes fan noise, room echo, and keyboard clicks during Google Meet, Zoom, or Discord calls.

---

## 3. Local AI & Productivity Workspace Status

1. **Odysseus AI Workspace:**
   - Always-on system service (`odysseus.service`) running in the background.
   - Served at `http://127.0.0.1:7011` in single-user mode (`AUTH_ENABLED=false`).
   - Integrated into GNOME App Grid with high-res icon and global terminal command (`odysseus`).
   - Auto-opens Google Chrome directly to the chat interface.
2. **Ollama LLM Engine:**
   - Active and running as a systemd service.
   - `llama3.2:3b` is registered and active in Odysseus.
   - `huihui_ai/llama3.2-abliterate:3b` is downloading in the background at ~2.4 MB/s and will automatically appear in Odysseus once finished.
3. **Office & Academic Suite:**
   - **OnlyOffice Desktop Editors:** Available from the app grid or via command `onlyoffice`.
   - **MarkText:** Available from the app grid or via command `marktext`.
   - **TeXstudio + TeXLive:** Available from the app grid or via command `texstudio`.
   - **LibreOffice Fresh:** Available from the app grid or via command `libreoffice`.
