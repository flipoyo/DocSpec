#!/usr/bin/env bash
# ============================================================================
# create_slidev_project.sh
# ============================================================================
#
# Create a new Slidev project from scratch.
#
# This script sets up a fresh Slidev presentation project with all required
# dependencies installed and a default slides.md ready for editing.
#
#
# Syntax
# ----------------------------------------------------------------------------
#
#   ./create_slidev_project.sh PROJECT_NAME
#
#
# Examples
# ----------------------------------------------------------------------------
#
#   ./create_slidev_project.sh MyPresentation
#
#   ./create_slidev_project.sh HTASSlides
#
#
# Requirements
# ----------------------------------------------------------------------------
#
#   Ubuntu 22+
#   node >= 20
#   npm
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

PROJECT_NAME="${1:-}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: $0 PROJECT_NAME"
    echo
    echo "Example: $0 MyPresentation"
    exit 1
fi

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
# CHECK PROJECT DOES NOT ALREADY EXIST
# ============================================================================

if [ -d "$PROJECT_NAME" ]; then
    err "Directory '$PROJECT_NAME' already exists."
    echo
    echo "Use launch_slidev_project.sh to open an existing project."
    exit 1
fi

# ============================================================================
# CREATE PROJECT
# ============================================================================

msg "Creating Slidev project: $PROJECT_NAME"

npm create slidev@latest "$PROJECT_NAME"

cd "$PROJECT_NAME"

# ============================================================================
# INSTALL DEPENDENCIES
# ============================================================================

if [ ! -d "node_modules" ]; then
    msg "Installing dependencies..."
    npm install
fi

# ============================================================================
# DEFAULT SLIDES (if not created by scaffolding)
# ============================================================================

if [ ! -f "slides.md" ]; then

cat > slides.md <<'EOF'
---
theme: default
title: Presentation
fonts:
  sans: Inter
---

# Welcome

Your Slidev presentation starts here.
EOF

fi

# ============================================================================
# DONE
# ============================================================================

echo
echo -e "${BLUE}========================================${RESET}"
echo -e "${BLUE} Slidev Project Created${RESET}"
echo -e "${BLUE}========================================${RESET}"
echo
echo "Project directory : $(pwd)"
echo
echo "Next steps:"
echo
echo "  cd $PROJECT_NAME"
echo "  ../launch_slidev_project.sh . [codium|code]"
echo
