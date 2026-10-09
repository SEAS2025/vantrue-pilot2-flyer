#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

GH="${GH_BIN:-/exec-daemon/gh}"

if ! "$GH" auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not authenticated. Run:"
  echo "  GH_PROMPT_DISABLED=1 $GH auth login -h github.com -p https -w"
  exit 1
fi

REPO_NAME="${1:-vantrue-pilot2-flyer}"
OWNER="$("$GH" api user -q .login)"
DEFAULT_BRANCH="${2:-main}"

git branch -M "$DEFAULT_BRANCH"
if git remote get-url origin >/dev/null 2>&1; then
  git push -u origin "$DEFAULT_BRANCH"
else
  "$GH" repo create "$REPO_NAME" \
    --public \
    --description 'Vantrue Pilot 2 one-page PDF flyer ($549.99 + $100 install)' \
    --source=. \
    --remote=origin \
    --push
fi

PDF_URL="https://github.com/${OWNER}/${REPO_NAME}/blob/${DEFAULT_BRANCH}/Vantrue-Pilot-2-Flyer.pdf"
RAW_URL="https://raw.githubusercontent.com/${OWNER}/${REPO_NAME}/${DEFAULT_BRANCH}/Vantrue-Pilot-2-Flyer.pdf"
echo "REPO_URL=https://github.com/${OWNER}/${REPO_NAME}"
echo "PDF_URL=${PDF_URL}"
echo "RAW_PDF_URL=${RAW_URL}"
