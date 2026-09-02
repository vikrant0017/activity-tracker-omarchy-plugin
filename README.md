# Activity Tracker for Omarchy

An Omarchy bar widget for the local-first [Activity Tracker](https://github.com/vikrant0017/activity-tracker). It shows active time and your three most-used applications using a dashboard that runs only on your computer.

## Requirements

- Omarchy with an active Hyprland session
- `uv` and `curl` available on `PATH`
- Internet access for the first runtime installation

The widget, collector, SQLite database, and dashboard are all local. The dashboard binds to `127.0.0.1` by default.

## Install

Install and enable the plugin with Omarchy:

```sh
omarchy plugin add \
  https://github.com/vikrant0017/activity-tracker-omarchy-plugin.git \
  --enable
```

The widget is added to the bar automatically. If the shell does not reload it immediately, run:

```sh
omarchy restart shell
```

## First use

1. Click the new Activity Tracker bar widget.
2. Select **Open dashboard** in its popup.
3. On the first run, the plugin downloads the pinned application wheel from the [Activity Tracker GitHub Release](https://github.com/vikrant0017/activity-tracker/releases), verifies its SHA-256 checksum, and installs it with `uv tool`.
4. The plugin enables the `activity-tracker` systemd user service so data collection continues independently of the dashboard.
5. Your default browser opens the local dashboard.

After installation, switch between a few windows and allow the widget up to ten seconds to refresh.

## Everyday use

| Action | Result |
| --- | --- |
| Click widget | Opens or closes the summary popup |
| **Open dashboard** | Opens the dashboard; installs the runtime if missing |
| Middle-click widget | Refreshes stats immediately |
| Dashboard unavailable | Widget displays `XX:XX` until it reconnects |

Useful runtime commands after installation:

```sh
activity-tracker-service status
activity-tracker-service restart
activity-tracker-stats
activity-tracker-open-dashboard
```

## Update or remove

Update the plugin source:

```sh
omarchy plugin update vikrant.activity-tracker --yes
```

Remove the widget and unload it from Omarchy:

```sh
omarchy plugin remove vikrant.activity-tracker --yes
```

Removing the widget does not remove the installed application runtime. To remove the runtime too:

```sh
activity-tracker-service uninstall
uv tool uninstall activity-tracker
```

## Troubleshooting

### `uv` is required

If clicking **Open dashboard** does not install the runtime, confirm that `uv` is available:

```sh
uv --version
```

Install `uv`, then open the widget popup and select **Open dashboard** again.

### Service cannot see Hyprland

Import the active session variables, then restart the service:

```sh
systemctl --user import-environment XDG_RUNTIME_DIR HYPRLAND_INSTANCE_SIGNATURE
activity-tracker-service restart
```

## Release note

The widget currently installs a wheel pinned in `open-dashboard.sh`. When a new Activity Tracker version is released, update this plugin to point to the matching GitHub Release. A future release will replace this GitHub Release bootstrap with PyPI installation.
