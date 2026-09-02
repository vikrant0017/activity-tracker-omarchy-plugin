#!/bin/sh
set -eu

APP_VERSION="0.1.1"
RELEASE_URL="https://github.com/vikrant0017/activity-tracker/releases/download/v${APP_VERSION}"
WHEEL="activity_tracker-${APP_VERSION}-py3-none-any.whl"
CHECKSUM="${WHEEL}.sha256"
bin_dir="${UV_TOOL_BIN_DIR:-${XDG_BIN_HOME:-$HOME/.local/bin}}"
dashboard="$bin_dir/activity-tracker-dashboard"
service="$bin_dir/activity-tracker-service"
open_dashboard="$bin_dir/activity-tracker-open-dashboard"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/activity-tracker/releases/${APP_VERSION}"

notify() {
  command -v notify-send >/dev/null 2>&1 && notify-send "Activity Tracker" "$1" || true
}

status() {
  printf 'ACTIVITY_TRACKER_STATUS:%s\n' "$1"
}

install_runtime() {
  if ! command -v uv >/dev/null 2>&1; then
    notify "uv is required to install Activity Tracker. Install uv, then open the widget again."
    exit 1
  fi

  mkdir -p "$cache_dir"
  if [ ! -f "$cache_dir/$WHEEL" ] || [ ! -f "$cache_dir/$CHECKSUM" ]; then
    status "Downloading Activity Tracker…"
    notify "Downloading Activity Tracker…"
    curl --fail --location --retry 3 --output "$cache_dir/$WHEEL" "$RELEASE_URL/$WHEEL"
    curl --fail --location --retry 3 --output "$cache_dir/$CHECKSUM" "$RELEASE_URL/$CHECKSUM"
  fi

  expected_hash=$(awk '{print $1}' "$cache_dir/$CHECKSUM")
  actual_hash=$(sha256sum "$cache_dir/$WHEEL" | awk '{print $1}')
  if [ "$actual_hash" != "$expected_hash" ]; then
    notify "Activity Tracker download failed checksum verification."
    rm -f "$cache_dir/$WHEEL" "$cache_dir/$CHECKSUM"
    exit 1
  fi

  status "Installing Activity Tracker…"
  notify "Installing Activity Tracker…"
  uv tool install --from "$cache_dir/$WHEEL" activity-tracker
}

if [ ! -x "$dashboard" ]; then
  install_runtime
fi

status "Starting Activity Tracker…"
systemctl --user import-environment XDG_RUNTIME_DIR HYPRLAND_INSTANCE_SIGNATURE || true
"$service" install
"$open_dashboard"
status "READY"
