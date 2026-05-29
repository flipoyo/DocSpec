#!/usr/bin/env bash
# ============================================================================
# launch_slidev_project.sh
# ============================================================================
#
# Launch an existing Slidev project: install/update dependencies, open the
# editor, and start the dev server.
#
#
# Syntax
# ----------------------------------------------------------------------------
#
#   ./launch_slidev_project.sh PROJECT_PATH [IDE]
#
#
# Examples
# ----------------------------------------------------------------------------
#
#   ./launch_slidev_project.sh ./MyPresentation
#
#   ./launch_slidev_project.sh ./MyPresentation codium
#
#   ./launch_slidev_project.sh ./MyPresentation code
#
#   ./launch_slidev_project.sh ./MyPresentation none
#
#
# Supported IDE values
# ----------------------------------------------------------------------------
#
#   codium   (default) — VSCodium
#   code     — Visual Studio Code
#   none     — skip editor launch
#
#
# Requirements
# ----------------------------------------------------------------------------
#
#   Ubuntu 22+
#   node >= 20
#   npm
#   An existing Slidev project (created with create_slidev_project.sh)
#
#
# Recommended
# ----------------------------------------------------------------------------
#
#   nvm (for Node version management)
#   codium or code (VS Code / VS Codium for editing)
#
# ============================================================================

set -euo pipefail

# ============================================================================
# CONFIG
# ============================================================================

PROJECT_PATH="${1:-}"
IDE="${2:-codium}"

if [ -z "$PROJECT_PATH" ]; then
    echo "Usage: $0 PROJECT_PATH [IDE]"
    echo
    echo "Example: $0 ./MyPresentation codium"
    exit 1
fi

PORT=3030

# ============================================================================
# COLORS
# ============================================================================

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
RESET="\033[0m"

# ============================================================================
# HELPERS
# ============================================================================

msg() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

err() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# ============================================================================
# CHECK NODE
# ============================================================================

if ! command -v node >/dev/null 2>&1; then
    err "Node.js not found."
    echo
    echo "Install nvm + Node 22:"
    echo
    echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash"
    echo "  source ~/.bashrc"
    echo "  nvm install 22"
    echo
    exit 1
fi

NODE_MAJOR="$(node -v | sed 's/v//' | cut -d'.' -f1)"

if [ "$NODE_MAJOR" -lt 20 ]; then
    err "Node version too old: $(node -v)"
    echo
    echo "Slidev/Vite require Node >= 20."
    echo
    echo "Recommended:"
    echo
    echo "  nvm install 22"
    echo "  nvm use 22"
    echo
    exit 1
fi

msg "Using Node $(node -v)"

# ============================================================================
# CHECK PROJECT EXISTS
# ============================================================================

if [ ! -d "$PROJECT_PATH" ]; then
    err "Project directory not found: $PROJECT_PATH"
    echo
    echo "Use create_slidev_project.sh to create a new project first."
    exit 1
fi

cd "$PROJECT_PATH"

if [ ! -f "package.json" ]; then
    err "No package.json found in $PROJECT_PATH — not a valid Slidev project."
    exit 1
fi

# ============================================================================
# INSTALL / UPDATE DEPENDENCIES
# ============================================================================

if [ ! -d "node_modules" ]; then
    msg "Installing dependencies..."
    npm install
else
    msg "Dependencies already installed."
fi

# ============================================================================
# OPEN IDE
# ============================================================================

case "$IDE" in

    codium)
        if command -v codium >/dev/null 2>&1; then
            msg "Opening project in VSCodium"
            codium . >/dev/null 2>&1 &
        else
            warn "codium not found — skipping editor launch"
        fi
        ;;

    code)
        if command -v code >/dev/null 2>&1; then
            msg "Opening project in VS Code"
            code . >/dev/null 2>&1 &
        else
            warn "code not found — skipping editor launch"
        fi
        ;;

    none)
        msg "Editor launch skipped."
        ;;

    *)
        warn "Unknown IDE: $IDE — skipping editor launch"
        ;;

esac

# ============================================================================
# LAUNCH SLIDEV DEV SERVER
# ============================================================================

msg "Starting Slidev dev server on port ${PORT}..."

npm run dev -- --open &

SLIDEV_PID=$!

sleep 4

# ============================================================================
# INFO
# ============================================================================

echo
echo -e "${BLUE}========================================${RESET}"
echo -e "${BLUE} Slidev Project Running${RESET}"
echo -e "${BLUE}========================================${RESET}"
echo
echo "Project : $(pwd)"
echo "URL     : http://localhost:${PORT}"
echo "PID     : ${SLIDEV_PID}"
echo
echo "Stop server:"
echo
echo "  kill ${SLIDEV_PID}"
echo

wait ${SLIDEV_PID}
