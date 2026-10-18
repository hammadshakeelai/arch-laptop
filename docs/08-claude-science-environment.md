# Science Tools & Claude/Agent Scientific MCP Environment

Setting up scientific AI plugins and Claude/Antigravity science tools can be challenging because they rely on Node.js sidecars, Python scientific libraries (RDKit, BioPython), and MCP (Model Context Protocol) servers.

---

## 1. Architecture of the Science Plugin Suite

The Science suite integrates several specialized scientific capabilities:

```
┌─────────────────────────────────────────────────────────────┐
│             Agent / Claude / Antigravity Host               │
└──────────────────────────────┬──────────────────────────────┘
                               │ MCP Protocol (JSON-RPC)
  ┌────────────────────────────┼────────────────────────────┐
  │                            │                            │
  ▼                            ▼                            ▼
┌─────────────────┐  ┌──────────────────┐  ┌─────────────────┐
│ Biomolecular    │  │ AlphaFold & PDB  │  │ Cheminformatics │
│ Mol* 3D Viewer  │  │ Fetch & Analysis │  │ (PubChem/ChEMBL)│
│ (Node.js/WebGL) │  │ (Python / uv)    │  │ (Python / uv)   │
└─────────────────┘  └──────────────────┘  └─────────────────┘
```

### Components:
- **`uv` Package Manager**: Fast Rust-based Python package runner used to execute scientific queries without installing packages into global Python.
- **Biomolecular Structure Viewer MCP**: Interactive Mol* 3D rendering sidecar for proteins and nucleic acids.
- **Cheminformatics & Genomics APIs**: PubChem, ChEMBL, AlphaFold, ClinVar, gnomAD, and OpenAlex literature search.

---

## 2. Prerequisites Installation on Arch Linux

```bash
# 1. Install Node.js, npm, and base build tools:
sudo pacman -S --needed nodejs npm git base-devel

# 2. Install 'uv' package manager (official binary):
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# Verify:
uv --version
```

---

## 3. Configuring Claude Desktop MCP (if using Anthropic Claude)

If using the Claude Desktop application on Linux (e.g. via `claude-desktop-bin` from AUR):
The configuration lives at `~/.config/Claude/claude_desktop_config.json`.

```json
{
  "mcpServers": {
    "biomolecular-structure-viewer": {
      "command": "node",
      "args": ["/home/hammad/.config/plugins/science/sidecars/biomolecular_structure_viewer/dist/mcp_entry.cjs"]
    },
    "pubchem": {
      "command": "uvx",
      "args": ["mcp-server-pubchem"]
    }
  }
}
```

---

## 4. Configuring Antigravity / Gemini Science Plugin

If using Antigravity on your Arch laptop, the science plugin installs cleanly into:
`~/.gemini/config/plugins/science/`

API keys for scientific databases can be added to `~/.env`:
```bash
cat <<EOF >> ~/.env
# Scientific API Keys:
ALPHAGENOME_API_KEY=""
OPENALEX_API_KEY=""
NCBI_API_KEY=""
EOF
```

---

## 5. Scientific Python Environment (BioPython, RDKit, Mol*)

To run standalone scientific analysis scripts without breaking system packages:
```bash
# Create dedicated science environment using uv:
uv venv ~/science-env --python 3.11
source ~/science-env/bin/activate
uv pip install rdkit biopython pandas numpy scipy matplotlib jupyterlab
```
