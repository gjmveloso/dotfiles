#!/usr/bin/env bash

# Shows what's in the repo but not installed locally.
# The repo is the source of truth. Run with: bash diff.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$SCRIPT_DIR/packages"

RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

section() { echo; echo "━━ $1"; }

compute_missing() {
  local repo_file="$1"
  local current_file="$2"
  local tmp_repo tmp_current
  tmp_repo=$(mktemp)
  tmp_current=$(mktemp)
  sort "$repo_file" > "$tmp_repo"
  sort "$current_file" > "$tmp_current"
  comm -23 "$tmp_repo" "$tmp_current"
  rm "$tmp_repo" "$tmp_current"
}

print_missing() {
  while IFS= read -r pkg; do
    [[ -n "$pkg" ]] && printf "  ${RED}%s${RESET}\n" "$pkg"
  done
}

# ── Brew ──────────────────────────────────────────────────────────────────────
section "Brew (taps + formulae + casks)"

tmp_brew=$(mktemp)
{ brew tap; brew leaves; brew list --cask; } 2>/dev/null > "$tmp_brew"
not_installed=$(compute_missing "$PACKAGES_DIR/brew.txt" "$tmp_brew")
rm "$tmp_brew"

if [[ -z "$not_installed" ]]; then
  echo "  (all installed)"
else
  print_missing <<< "$not_installed"

  available_casks=$(brew casks 2>/dev/null)
  taps=(); tap_formulae=(); casks=(); formulae=()

  while IFS= read -r pkg; do
    [[ -z "$pkg" ]] && continue
    slashes=${pkg//[^\/]/}
    if [[ ${#slashes} -eq 1 ]]; then
      taps+=("$pkg")
    elif [[ ${#slashes} -ge 2 ]]; then
      tap_formulae+=("$pkg")
    elif echo "$available_casks" | grep -qx "$pkg"; then
      casks+=("$pkg")
    else
      formulae+=("$pkg")
    fi
  done <<< "$not_installed"

  for tf in "${tap_formulae[@]}"; do formulae+=("${tf##*/}"); done

  echo
  printf "  ${BOLD}To install:${RESET}\n"
  for tap in "${taps[@]}"; do printf "    brew tap %s\n" "$tap"; done
  [[ ${#formulae[@]} -gt 0 ]] && printf "    brew install %s\n"        "${formulae[*]}"
  [[ ${#casks[@]} -gt 0 ]]    && printf "    brew install --cask %s\n" "${casks[*]}"
fi

# ── npm ───────────────────────────────────────────────────────────────────────
section "npm (global)"

parse_npm() {
  grep -E '[├└]──' | sed 's/.*── //' | sed 's/@[^@]*$//'
}

tmp_npm_repo=$(mktemp)
tmp_npm_current=$(mktemp)
parse_npm < "$PACKAGES_DIR/npm.txt" > "$tmp_npm_repo"
npm list -g --depth=0 2>/dev/null | parse_npm > "$tmp_npm_current"
not_installed=$(compute_missing "$tmp_npm_repo" "$tmp_npm_current")
rm "$tmp_npm_repo" "$tmp_npm_current"

if [[ -z "$not_installed" ]]; then
  echo "  (all installed)"
else
  print_missing <<< "$not_installed"
  echo
  printf "  ${BOLD}To install:${RESET}\n"
  printf "    npm install -g %s\n" "$(echo "$not_installed" | tr '\n' ' ')"
fi

# ── uv tools ──────────────────────────────────────────────────────────────────
section "uv tools (Python)"

parse_uv() {
  grep -v '^\s*-' | grep -v '^\s*$' | awk '{print $1}'
}

tmp_uv_repo=$(mktemp)
tmp_uv_current=$(mktemp)
parse_uv < "$PACKAGES_DIR/uv_tools.txt" > "$tmp_uv_repo"
uv tool list 2>/dev/null | parse_uv > "$tmp_uv_current"
not_installed=$(compute_missing "$tmp_uv_repo" "$tmp_uv_current")
rm "$tmp_uv_repo" "$tmp_uv_current"

if [[ -z "$not_installed" ]]; then
  echo "  (all installed)"
else
  print_missing <<< "$not_installed"
  echo
  printf "  ${BOLD}To install:${RESET}\n"
  while IFS= read -r pkg; do
    [[ -n "$pkg" ]] && printf "    uv tool install %s\n" "$pkg"
  done <<< "$not_installed"
fi

echo
