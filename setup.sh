#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
SQUAD_MARKER="<!-- gorila-squad -->"
PROJECT_DIR="${1:-}"

echo "=== Gorila Squad — Setup ==="

# Claude Code agents (globais)
echo ""
echo "[1/5] Instalando agentes no Claude Code..."
mkdir -p "$CLAUDE_AGENTS_DIR"
cp "$SCRIPT_DIR/claude-agents/"*.md "$CLAUDE_AGENTS_DIR/"
echo "✓ Agentes instalados em $CLAUDE_AGENTS_DIR"

# Playbooks de segurança (strix, Apache-2.0) — orquestrados por nezuko
STRIX_DIR="$HOME/.claude/strix-agentes"
mkdir -p "$STRIX_DIR"
cp -r "$SCRIPT_DIR/strix agentes/." "$STRIX_DIR/"
echo "✓ Playbooks strix instalados em $STRIX_DIR"

# Claude Code commands (globais) — atalhos /nome-do-agente
echo ""
echo "[2/5] Instalando commands no Claude Code..."
mkdir -p "$CLAUDE_COMMANDS_DIR"
cp "$SCRIPT_DIR/claude-commands/"*.md "$CLAUDE_COMMANDS_DIR/"
echo "✓ Commands instalados em $CLAUDE_COMMANDS_DIR"

# Claude Code skills (globais) — conhecimento periférico carregado sob demanda
echo ""
echo "[3/5] Instalando skills de referência no Claude Code..."
mkdir -p "$CLAUDE_SKILLS_DIR"
cp -r "$SCRIPT_DIR/claude-skills/"*/ "$CLAUDE_SKILLS_DIR/"
echo "✓ $(ls -d "$SCRIPT_DIR/claude-skills/"*/ | wc -l) skills instaladas em $CLAUDE_SKILLS_DIR"

# CLAUDE.md — merge no global ~/.claude/CLAUDE.md
echo ""
echo "[4/5] Atualizando CLAUDE.md global..."
mkdir -p "$HOME/.claude"
if [ ! -f "$CLAUDE_MD" ]; then
  # Arquivo não existe — cria direto
  echo "$SQUAD_MARKER" >> "$CLAUDE_MD"
  cat "$SCRIPT_DIR/CLAUDE.md" >> "$CLAUDE_MD"
  echo "$SQUAD_MARKER" >> "$CLAUDE_MD"
  echo "✓ CLAUDE.md criado em $CLAUDE_MD"
elif grep -q "$SQUAD_MARKER" "$CLAUDE_MD"; then
  # Seção gorila-squad já existe — substitui entre os marcadores
  awk -v marker="$SQUAD_MARKER" -v file="$SCRIPT_DIR/CLAUDE.md" '
    $0 == marker { if (!found) { found=1; print; while ((getline line < file) > 0) print line; print marker; skip=1; next } }
    skip && $0 == marker { skip=0; next }
    !skip { print }
  ' "$CLAUDE_MD" > "$CLAUDE_MD.tmp" && mv "$CLAUDE_MD.tmp" "$CLAUDE_MD"
  echo "✓ Seção gorila-squad atualizada em $CLAUDE_MD"
else
  # Arquivo existe mas sem seção — appenda no final
  echo "" >> "$CLAUDE_MD"
  echo "$SQUAD_MARKER" >> "$CLAUDE_MD"
  cat "$SCRIPT_DIR/CLAUDE.md" >> "$CLAUDE_MD"
  echo "$SQUAD_MARKER" >> "$CLAUDE_MD"
  echo "✓ Seção gorila-squad adicionada em $CLAUDE_MD"
fi

# Cursor Rules (por projeto)
if [ -n "$PROJECT_DIR" ]; then
  echo ""
  echo "[5/5] Instalando Cursor Rules em $PROJECT_DIR..."
  mkdir -p "$PROJECT_DIR/.cursor/rules"
  cp "$SCRIPT_DIR/cursor-rules/"*.mdc "$PROJECT_DIR/.cursor/rules/" 2>/dev/null || echo "  (sem cursor-rules para copiar)"
  echo "✓ Cursor Rules instaladas em $PROJECT_DIR/.cursor/rules"
else
  echo ""
  echo "[5/5] Cursor Rules — passe o caminho do projeto para instalar:"
  echo "      ./setup.sh /caminho/do/projeto"
fi

echo ""
echo "Squad instalado com sucesso!"
echo ""
echo "Agentes disponíveis:"
echo "  /light      — Coordenador (orquestra todos)"
echo "  /shikamaru  — Project Management"
echo "  /escanor    — PHP + Laravel"
echo "  /bulma      — Frontend (Vue, React, UI/UX)"
echo "  /ippo       — Banco de dados"
echo "  /levi       — QA e testes"
echo "  /nezuko     — Segurança"
echo "  /saitama    — DevOps + SRE"
echo "  /gon        — Mobile"
echo "  /uraraka    — Python + Node.js"
echo "  /kurama     — Arquitetura de Software"
echo "  /ryuk       — Data e BI"
