#! /usr/bin/env bash

systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP PATH
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-wlr.service xdg-desktop-portal-gtk.service