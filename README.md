# Activity Tracker for Omarchy

An Omarchy bar widget for the local-first [Activity Tracker](https://github.com/vikrant0017/activity-tracker) application.

## Install

```sh
omarchy plugin add https://github.com/vikrant0017/activity-tracker-omarchy-plugin.git --enable
```

The widget polls the local dashboard for active time and the three most-used applications.

## First use

Click **Open dashboard** in the widget popup. If the Activity Tracker runtime is not installed, the plugin explicitly bootstraps it by:

1. downloading the versioned wheel from the main project's GitHub Release;
2. verifying its SHA-256 checksum;
3. installing it with `uv tool install`;
4. enabling the `activity-tracker` systemd user service; and
5. opening the local dashboard.

The bootstrap currently requires `uv` and `curl` on `PATH`. The release wheel is intentionally pinned in `open-dashboard.sh`; update the script when releasing a new runtime version.

Activity data is stored locally in `~/.local/share/activity-tracker/` and the dashboard binds to `127.0.0.1` by default.

## Widget behavior

- **Automatic activation:** once the dashboard is available, the next ten-second refresh shows live data.
- **Daemon offline:** displays `XX:XX`.
- **Click:** opens the popup.
- **Open dashboard:** installs the runtime when necessary, then opens the local dashboard.
- **Middle-click:** refreshes widget data immediately.
