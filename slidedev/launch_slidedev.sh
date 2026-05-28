```bash
#!/usr/bin/env bash
# ============================================================================
# launchSlidevDev.sh
# ============================================================================
#
# Launch and initialize a Slidev project automatically.
#
# Features
# ----------------------------------------------------------------------------
#
# - Create project if missing
# - Install/update Node dependencies
# - Auto-detect npm/pnpm/yarn
# - Open project in IDE/editor
# - Launch Slidev dev server
# - Optional browser opening
# - Optional xterm spawning
#
#
# Syntax
# ----------------------------------------------------------------------------
#
#   ./launchSlidevDev.sh PROJECT_NAME [IDE]
#
#
# Examples
# ----------------------------------------------------------------------------
#
#   ./launchSlidevDev.sh HTASSlides
#
#   ./launchSlidevDev.sh HTASSlides codium
#
#   ./launchSlidevDev.sh HTASSlides code
#
#   ./launchSlidevDev.sh HTASSlides xterm
#
#
# Supported IDE values
# ----------------------------------------------------------------------------
#
#   codium
#   code
#   xterm
#   none
#
#
# Requirements
# ----------------------------------------------------------------------------
#
#   node >= 20
#   npm
#
#
# Recommended
# ----------------------------------------------------------------------------
#
#   nvm
#
# ============================================================================

set -euo pipefail

# ============================================================================
# CONFIG
# ============================================================================

PROJECT_NAME="${1:-HTASSlides}"
IDE="${2:-codium}"

PORT=3030

# ============================================================================
# COLORS
# ============================================================================

GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
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
    echo "Slidev/Vite now require Node >= 20."
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
# PROJECT CREATION
# ============================================================================

if [ ! -d "$PROJECT_NAME" ]; then

    msg "Creating Slidev project: $PROJECT_NAME"

    npm create slidev@latest "$PROJECT_NAME"

fi

cd "$PROJECT_NAME"

# ============================================================================
# INSTALL
# ============================================================================

if [ ! -d "node_modules" ]; then

    msg "Installing dependencies"

    npm install

else

    msg "Dependencies already installed"

fi

# ============================================================================
# DEFAULT SLIDES
# ============================================================================

if [ ! -f "slides.md" ]; then

cat > slides.md <<'EOF'
---
theme: default
title: HydrologicalTwin
fonts:
  sans: Inter
---

# HydrologicalTwin

A scientific platform for sustainable water resource management.
EOF

fi

# ============================================================================
# OPEN IDE
# ============================================================================

open_ide() {

    case "$IDE" in

        codium)

            if command -v codium >/dev/null 2>&1; then
                msg "Opening project in Codium"
                codium . >/dev/null 2>&1 &
            else
                warn "Codium not found"
            fi
            ;;

        code)

            if command -v code >/dev/null 2>&1; then
                msg "Opening project in VSCode"
                code . >/dev/null 2>&1 &
            else
                warn "VSCode not found"
            fi
            ;;

        xterm)

            if command -v xterm >/dev/null 2>&1; then
                msg "Opening xterm"
                xterm -e "bash -c 'cd $(pwd); bash'" &
            else
                warn "xterm not found"
            fi
            ;;

        none)

            msg "IDE launch skipped"
            ;;

        *)

            warn "Unknown IDE: $IDE"
            ;;

    esac
}

open_ide

# ============================================================================
# LAUNCH SLIDEV
# ============================================================================

msg "Starting Slidev server"

npm run dev -- --open &

SLIDEV_PID=$!

sleep 4

# ============================================================================
# INFO
# ============================================================================

echo
echo -e "${BLUE}========================================${RESET}"
echo -e "${BLUE} Slidev Project Ready${RESET}"
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
```
