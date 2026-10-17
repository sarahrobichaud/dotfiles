#!/usr/bin/env bash

pkill waybar
waybar -c ~/.config/waybar/config-square -s ~/.config/waybar/style-square.css &
