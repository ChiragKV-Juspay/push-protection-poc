#!/bin/bash

set -e

echo "🔧 Installing pre-commit and Gitleaks..."

GITLEAKS_VERSION="v8.24.2"
ARCH="arm64"
OS="darwin"


if ! command -v pre-commit &>/dev/null; then
  echo "📦 Installing pre-commit via Homebrew..."
  brew install pre-commit
fi

# # Install Gitleaks if not present
# if ! command -v gitleaks &>/dev/null; then
#   echo "📦 Installing Gitleaks via Homebrew..."
#   brew install gitleaks
# fi
if ! command -v gitleaks &>/dev/null || [[ "$(gitleaks version 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')" != "$GITLEAKS_VERSION" ]]; then
  echo "📦 Installing Gitleaks $GITLEAKS_VERSION..."
  curl -sSL "https://github.com/gitleaks/gitleaks/releases/download/$GITLEAKS_VERSION/gitleaks_${GITLEAKS_VERSION#v}_${OS}_$ARCH.tar.gz" | tar -xz
  chmod +x gitleaks
  mv gitleaks /usr/local/bin/
else
  echo "✅ Gitleaks $GITLEAKS_VERSION already installed"
fi

# Install the Git hook
pre-commit install

echo "✅ All done! Pre-commit with Gitleaks is now set up."
