#!/usr/bin/env sh

# Install ~/.zimrc from GitHub and sync zimfw modules.
# This script does NOT modify ~/.zshrc.

set -eu

GITHUB_REPO="${GITHUB_REPO:-wuyaos/zsh-template}"
GITHUB_BRANCH="${GITHUB_BRANCH:-main}"
TARGET_ZIMRC="${HOME}/.zimrc"
ZIM_HOME="${HOME}/.zim"
ZIMFW_URL="https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh"

log() {
  printf '%s\n' "$*"
}

err() {
  printf '%s\n' "$*" >&2
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

download_file() {
  url="$1"
  output="$2"
  if have_cmd curl; then
    curl -fsSL "$url" -o "$output"
  elif have_cmd wget; then
    wget -qO "$output" "$url"
  else
    err "[install-zimrc] curl/wget not found; cannot download: $url"
    return 1
  fi
}

install_zimrc() {
  tmp_zimrc="$(mktemp)"
  url_main="https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_BRANCH}/config/zimrc"
  url_fallback="https://raw.githubusercontent.com/${GITHUB_REPO}/master/config/zimrc"

  if ! download_file "$url_main" "$tmp_zimrc"; then
    if [ "$GITHUB_BRANCH" = "main" ]; then
      err "[install-zimrc] failed on main; retrying master"
      download_file "$url_fallback" "$tmp_zimrc"
    else
      rm -f "$tmp_zimrc"
      return 1
    fi
  fi

  if [ -f "$TARGET_ZIMRC" ] || [ -L "$TARGET_ZIMRC" ]; then
    backup="${TARGET_ZIMRC}.bak.$(date +%Y%m%d-%H%M%S)"
    mv "$TARGET_ZIMRC" "$backup"
    log "[install-zimrc] backup created: $backup"
  fi

  cp "$tmp_zimrc" "$TARGET_ZIMRC"
  rm -f "$tmp_zimrc"
  log "[install-zimrc] installed: $TARGET_ZIMRC"
}

ensure_zimfw() {
  if [ -f "${ZIM_HOME}/zimfw.zsh" ]; then
    return 0
  fi
  mkdir -p "$ZIM_HOME"
  download_file "$ZIMFW_URL" "${ZIM_HOME}/zimfw.zsh"
  log "[install-zimrc] downloaded: ${ZIM_HOME}/zimfw.zsh"
}

sync_modules() {
  if ! have_cmd zsh; then
    err "[install-zimrc] zsh not found; cannot run zimfw"
    return 1
  fi

  tmp_dotdir="$(mktemp -d)"
  cp "$TARGET_ZIMRC" "${tmp_dotdir}/.zimrc"

  ZDOTDIR="$tmp_dotdir" ZIM_HOME="$ZIM_HOME" zsh -c '
    set -e
    . "$ZIM_HOME/zimfw.zsh" init -q
    . "$ZIM_HOME/zimfw.zsh" install -q
    . "$ZIM_HOME/zimfw.zsh" compile -q
  '

  rm -rf "$tmp_dotdir"
  log "[install-zimrc] zimfw init/install/compile finished"
}

main() {
  install_zimrc
  ensure_zimfw
  sync_modules
  log "[install-zimrc] done. run: exec zsh"
}

main "$@"
