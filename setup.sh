#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"
PROJECT_DIR="${1:-}"

echo "=== Gorila Squad — Setup ==="

# Claude Code agents (globais)
echo ""
echo "[1/3] Instalando agentes no Claude Code..."
mkdir -p "$CLAUDE_AGENTS_DIR"
cp "$SCRIPT_DIR/claude-agents/"*.md "$CLAUDE_AGENTS_DIR/"
echo "✓ Agentes instalados em $CLAUDE_AGENTS_DIR"

# Claude Code commands/skills (globais)
echo ""
echo "[2/3] Instalando commands no Claude Code..."
mkdir -p "$CLAUDE_COMMANDS_DIR"
cp "$SCRIPT_DIR/claude-commands/"*.md "$CLAUDE_COMMANDS_DIR/"
echo "✓ Commands instalados em $CLAUDE_COMMANDS_DIR"

# Cursor Rules (por projeto)
if [ -n "$PROJECT_DIR" ]; then
  echo ""
  echo "[3/3] Instalando Cursor Rules em $PROJECT_DIR..."
  mkdir -p "$PROJECT_DIR/.cursor/rules"
  cp "$SCRIPT_DIR/cursor-rules/"*.mdc "$PROJECT_DIR/.cursor/rules/" 2>/dev/null || echo "  (sem cursor-rules para copiar)"
  echo "✓ Cursor Rules instaladas em $PROJECT_DIR/.cursor/rules"
else
  echo ""
  echo "[3/3] Cursor Rules — passe o caminho do projeto para instalar:"
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
