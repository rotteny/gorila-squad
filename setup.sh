#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
PROJECT_DIR="${1:-}"

echo "=== Gorila Squad — Setup ==="

# Claude Code agents (globais)
echo ""
echo "[1/2] Instalando agentes no Claude Code..."
mkdir -p "$CLAUDE_AGENTS_DIR"
cp "$SCRIPT_DIR/claude-agents/"*.md "$CLAUDE_AGENTS_DIR/"
echo "✓ Agentes instalados em $CLAUDE_AGENTS_DIR"

# Cursor Rules (por projeto)
if [ -n "$PROJECT_DIR" ]; then
  echo ""
  echo "[2/2] Instalando Cursor Rules em $PROJECT_DIR..."
  mkdir -p "$PROJECT_DIR/.cursor/rules"
  cp "$SCRIPT_DIR/cursor-rules/"*.mdc "$PROJECT_DIR/.cursor/rules/"
  echo "✓ Cursor Rules instaladas em $PROJECT_DIR/.cursor/rules"
else
  echo ""
  echo "[2/2] Cursor Rules — passe o caminho do projeto para instalar:"
  echo "      ./setup.sh /caminho/do/projeto"
fi

echo ""
echo "Squad instalado com sucesso!"
echo ""
echo "Agentes disponíveis:"
echo "  Claude Code → /bulma  /escanor  /gon  /levi  /nezuko  /saitama  /shikamaru"
echo "  Cursor      → @bulma  @escanor  @gon  @levi  @nezuko  @saitama  @shikamaru"
