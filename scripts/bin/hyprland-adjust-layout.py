#! /usr/bin/env python3

import json
import subprocess


def get_windows():
    windows_raw = subprocess.check_output(["hyprctl", "clients", "-j"])
    return json.loads(windows_raw)


def get_window(window_class: str, window_title: str = None):
    windows = get_windows()

    for window in windows:
        if window_title is not None:
            if window["class"] == window_class and window["title"] == window_title:
                return window
        else:
            if window["class"] == window_class:
                return window
    
    if window_title is None:
        print(f"Window class {window_class} not found")
    else:
        print(f"Window class {window_class} with title {window_title} not found")

    return None


def resize_window(window: object, desired_width: int, desired_height: int, flip_x: bool = False, flip_y: bool = False):
    address = window["address"]
    current_width = window["size"][0]
    current_height = window["size"][1]
    adjusted_width = desired_width - current_width
    adjusted_height = desired_height - current_height

    if flip_x:
        adjusted_width *= -1
    if flip_y:
        adjusted_height *= -1

    print(f"Adjusting {window['title']} to {adjusted_width} {adjusted_height}")

    subprocess.run([
        "hyprctl", 
        "dispatch",
        f"resizewindowpixel {adjusted_width} {adjusted_height},address:{address}"
    ])


def adjust_window_position(window: object, pos_x: int, pos_y: int):
    address = window["address"]

    print(f"Moving {window['title']} to {pos_x} {pos_y}")

    subprocess.run([
        "hyprctl", 
        "dispatch",
        f"movewindowpixel exact {pos_x} {pos_y},address:{address}"
    ])


monitor_l_w = 2560
monitor_l_h = 2880
monitor_l_pos_x = 0
monitor_l_pos_y = 0

monitor_c_w = 3440
monitor_c_h = 1440
monitor_c_pos_x = 2560
monitor_c_pos_y = 1440

monitor_r_w = 2560
monitor_r_h = 2880
monitor_r_pos_x = 6000
monitor_r_pos_y = 0

waybar_height = 32
gap_size = 10

freerdp = get_window("sdl-freerdp")
if freerdp is not None:
    adjust_window_position(freerdp, monitor_c_pos_x + gap_size, monitor_c_pos_y + waybar_height + gap_size)

telegram = get_window("org.telegram.desktop")
if telegram is not None:
    resize_window(telegram, 600, 1425, flip_y=True)

steam_friends = get_window("steam", "Friends List")
if steam_friends is not None:
    resize_window(steam_friends, 500, 1388, flip_x=True)
