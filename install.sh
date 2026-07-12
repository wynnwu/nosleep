#!/bin/bash
# nosleep installer, https://github.com/wynnwu/nosleep
#
#   curl -fsSL https://raw.githubusercontent.com/wynnwu/nosleep/main/install.sh | bash
#
# Installs to ~/.local/bin if it exists and is on PATH, otherwise to
# /usr/local/bin (with sudo). Safe to re-run, upgrades in place.
set -euo pipefail

RAW="https://raw.githubusercontent.com/wynnwu/nosleep/main"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""

if [ "$(uname -s)" != "Darwin" ]; then
  echo "nosleep only works on macOS (it drives pmset)." >&2
  exit 1
fi

# Prefer a user-writable bin dir already on PATH; fall back to /usr/local/bin.
SUDO=""
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
  BIN_DIR="$HOME/.local/bin"
  MAN_DIR="$HOME/.local/share/man/man1"
else
  BIN_DIR="/usr/local/bin"
  MAN_DIR="/usr/local/share/man/man1"
  SUDO="sudo"
  echo "Installing to $BIN_DIR (requires sudo)."
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Use local files when run from a clone; otherwise download.
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/nosleep" ]; then
  cp "$SCRIPT_DIR/nosleep" "$TMP/nosleep"
  cp "$SCRIPT_DIR/man/nosleep.1" "$TMP/nosleep.1" 2>/dev/null || true
else
  curl -fsSL "$RAW/nosleep" -o "$TMP/nosleep"
  curl -fsSL "$RAW/man/nosleep.1" -o "$TMP/nosleep.1" || true
fi

bash -n "$TMP/nosleep"   # refuse to install a corrupt download

$SUDO mkdir -p "$BIN_DIR"
$SUDO install -m 0755 "$TMP/nosleep" "$BIN_DIR/nosleep"
if [ -s "$TMP/nosleep.1" ]; then
  $SUDO mkdir -p "$MAN_DIR"
  $SUDO install -m 0644 "$TMP/nosleep.1" "$MAN_DIR/nosleep.1"
fi

echo "Installed $("$BIN_DIR/nosleep" version) to $BIN_DIR/nosleep"
"$BIN_DIR/nosleep" status
echo "Try: nosleep 30m   (see 'nosleep help' or 'man nosleep')"
echo "Uninstall: rm $BIN_DIR/nosleep $MAN_DIR/nosleep.1"
