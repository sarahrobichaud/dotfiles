#!/usr/bin/env bash

pkill waybar

if [[ $USER = 'zyriel' ]]
then
	waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &
else
	waybar &
fi
