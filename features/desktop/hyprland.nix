{
  config,
  lib,
  osConfig ? { },
  ...
}:
let
  cfg = config.features.desktop.hyprland;
  nvidiaEnv = osConfig.features.desktop.hyprland.nvidiaEnv or false;
in
{
  options.features.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland desktop feature (home-manager config)";

    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "Monitor configurations (hyprland monitor settings)";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      settings = {
        mod = {
          _var = "SUPER";
        };

        env =
          lib.optionals nvidiaEnv [
            { _args = [ "LIBVA_DRIVER_NAME" "nvidia" ]; }
            { _args = [ "__GLX_VENDOR_LIBRARY_NAME" "nvidia" ]; }
          ]
          ++ [
            { _args = [ "XCURSOR_SIZE" "24" ]; }
            { _args = [ "HYPRCURSOR_SIZE" "24" ]; }
            { _args = [ "XCURSOR_THEME" "Nordzy-cursors" ]; }
            { _args = [ "HYPRCURSOR_THEME" "Nordzy-hyprcursors" ]; }
          ];

        on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("~/.config/waybar/launch.sh & hyprpaper")
                end
              '')
            ];
          }
          {
            _args = [
              "config.reloaded"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("~/.config/waybar/launch.sh & hyprpaper")
                end
              '')
            ];
          }
        ];

        monitor = cfg.monitors;

        config = {
          cursor = {
            no_hardware_cursors = false;
          };

          dwindle = {
            preserve_split = true;
          };

          master = {
            orientation = "right";
            mfact = 0.666667;
          };

          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = lib.mkDefault true;
          };

          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";
            follow_mouse = 1;
            sensitivity = 0;
            touchpad = {
              natural_scroll = false;
            };
          };

          general = {
            gaps_in = 15;
            gaps_out = 12;
            border_size = 2;
            resize_on_border = true;
            allow_tearing = true;
            layout = "master";
            "col.active_border" = lib.mkForce "rgb(ffffff)";
          };

          decoration = {
            rounding = 12;
            rounding_power = 2;
            active_opacity = 1;
            inactive_opacity = 0.90;
            shadow = {
              enabled = true;
              range = 12;
              render_power = 3;
            };
            blur = {
              enabled = true;
              size = 6;
              passes = 2;
              new_optimizations = true;
              vibrancy = 0.1696;
              ignore_opacity = true;
            };
          };
        };

        device = [
          {
            name = "epic-mouse-v1";
            sensitivity = -0.5;
          }
        ];

        curve = [
          { _args = [ "easeOutQuart" { type = "bezier"; points = [ [ 0.25 1.0 ] [ 0.5 1.0 ] ]; } ]; }
          { _args = [ "easeOutQuint" { type = "bezier"; points = [ [ 0.23 1.0 ] [ 0.32 1.0 ] ]; } ]; }
          { _args = [ "easeInOutCubic" { type = "bezier"; points = [ [ 0.65 0.0 ] [ 0.35 1.0 ] ]; } ]; }
          { _args = [ "easeInCubic" { type = "bezier"; points = [ [ 0.32 0.0 ] [ 0.67 0.0 ] ]; } ]; }
          { _args = [ "easeOutCubic" { type = "bezier"; points = [ [ 0.33 1.0 ] [ 0.68 1.0 ] ]; } ]; }
        ];

        animation = [
          { leaf = "global"; enabled = true; speed = 3.5; bezier = "easeOutQuart"; }
          { leaf = "windows"; enabled = true; speed = 2.5; bezier = "easeOutQuart"; }
          { leaf = "windowsIn"; enabled = true; speed = 6.0; bezier = "easeOutQuart"; style = "slide"; }
          { leaf = "windowsOut"; enabled = true; speed = 2.5; bezier = "easeInCubic"; style = "slide"; }
          { leaf = "windowsMove"; enabled = true; speed = 5; bezier = "easeOutQuart"; }
          { leaf = "workspaces"; enabled = true; speed = 2.5; bezier = "easeInOutCubic"; style = "slidefade 20%"; }
          { leaf = "workspacesIn"; enabled = true; speed = 2.5; bezier = "easeInOutCubic"; style = "slidefade 20%"; }
          { leaf = "workspacesOut"; enabled = true; speed = 2.5; bezier = "easeInOutCubic"; style = "slidefade 20%"; }
          { leaf = "layers"; enabled = true; speed = 2.5; bezier = "easeOutQuart"; }
          { leaf = "layersIn"; enabled = true; speed = 2.2; bezier = "easeOutQuart"; style = "popin 90%"; }
          { leaf = "layersOut"; enabled = true; speed = 1.8; bezier = "easeInCubic"; style = "fade"; }
          { leaf = "fadeLayersIn"; enabled = true; speed = 2.0; bezier = "easeOutCubic"; }
          { leaf = "fadeLayersOut"; enabled = true; speed = 1.8; bezier = "easeInCubic"; }
          { leaf = "fade"; enabled = true; speed = 2.0; bezier = "easeOutCubic"; }
          { leaf = "fadeIn"; enabled = true; speed = 2.0; bezier = "easeOutCubic"; }
          { leaf = "fadeOut"; enabled = true; speed = 1.0; bezier = "easeInCubic"; }
          { leaf = "border"; enabled = true; speed = 3.0; bezier = "easeOutQuart"; }
          { leaf = "zoomFactor"; enabled = true; speed = 3.0; bezier = "easeOutQuart"; }
        ];

        bind = [
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + U\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"lutris\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + G\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"steam\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + V\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"~/.config/waybar/network-menu.sh toggle-wg\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + B\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"helium\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + RETURN\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"ghostty\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + N\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"obsidian\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + N\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"nicotine\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + M\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"feishin\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + D\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"discord\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + A\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"signal-desktop\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + Q\"") (lib.mkLuaInline "hl.dsp.window.close()") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + O\"") (lib.mkLuaInline "hl.dsp.layout(\"swapwithmaster master\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + O\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"obs\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + H\"") (lib.mkLuaInline "hl.dsp.focus({ direction = \"left\" })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + H\"") (lib.mkLuaInline "hl.dsp.window.swap({ direction = \"left\" })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + L\"") (lib.mkLuaInline "hl.dsp.focus({ direction = \"right\" })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + L\"") (lib.mkLuaInline "hl.dsp.window.swap({ direction = \"right\" })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + K\"") (lib.mkLuaInline "hl.dsp.focus({ direction = \"up\" })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + K\"") (lib.mkLuaInline "hl.dsp.window.swap({ direction = \"up\" })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + J\"") (lib.mkLuaInline "hl.dsp.focus({ direction = \"down\" })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + J\"") (lib.mkLuaInline "hl.dsp.window.swap({ direction = \"down\" })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + F\"") (lib.mkLuaInline "hl.dsp.window.fullscreen({ mode = 'maximized', action = 'toggle' })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + F\"") (lib.mkLuaInline "hl.dsp.window.fullscreen({ mode = 'fullscreen', action = 'toggle' })") ]; }

          { _args = [ (lib.mkLuaInline "mod .. \" + 1\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 1 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 1\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 1 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 2\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 2 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 2\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 2 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 3\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 3 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 3\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 3 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 4\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 4 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 4\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 4 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 5\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 5 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 5\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 5 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 6\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 6 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 6\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 6 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 7\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 7 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 7\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 7 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 8\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 8 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 8\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 8 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 9\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 9 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 9\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 9 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + 0\"") (lib.mkLuaInline "hl.dsp.focus({ workspace = 10 })") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + 0\"") (lib.mkLuaInline "hl.dsp.window.move({ workspace = 10 })") ]; }

          { _args = [ (lib.mkLuaInline "mod .. \" + mouse:272\"") (lib.mkLuaInline "hl.dsp.window.drag()") { mouse = true; } ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + mouse:273\"") (lib.mkLuaInline "hl.dsp.window.resize()") { mouse = true; } ]; }

          { _args = [ (lib.mkLuaInline "mod .. \" + S\"") (lib.mkLuaInline "hl.dsp.workspace.swap_monitors({ monitor1 = \"DP-1\", monitor2 = \"DP-2\" })") ]; }

          { _args = [ "XF86AudioRaiseVolume" (lib.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")") { locked = true; repeating = true; } ]; }
          { _args = [ "XF86AudioLowerVolume" (lib.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")") { locked = true; repeating = true; } ]; }
          { _args = [ "XF86AudioMute" (lib.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")") { locked = true; repeating = true; } ]; }
          { _args = [ "XF86AudioMicMute" (lib.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")") { locked = true; repeating = true; } ]; }
          { _args = [ "XF86MonBrightnessDown" (lib.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%-\")") { locked = true; repeating = true; } ]; }

          { _args = [ "XF86AudioNext" (lib.mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")") { locked = true; } ]; }
          { _args = [ "XF86AudioPause" (lib.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")") { locked = true; } ]; }
          { _args = [ "XF86AudioPlay" (lib.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")") { locked = true; } ]; }
          { _args = [ "XF86AudioPrev" (lib.mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")") { locked = true; } ]; }

          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + R\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"~/.config/waybar/launch.sh\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + T\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"tableplus\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + B\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"bruno\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + C\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"zeditor ~/dotfiles\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + M\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"proton-mail\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + E\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"nautilus\")") ]; }
          { _args = [ (lib.mkLuaInline "mod .. \" + SHIFT + EQUAL\"") (lib.mkLuaInline "hl.dsp.exec_cmd(\"slurp | grim -g - - | wl-copy\")") ]; }
        ];

        workspace_rule = [
          { workspace = "1"; monitor = "DP-2"; layout = "master"; }
          { workspace = "2"; monitor = "DP-2"; layout = "master"; }
          { workspace = "3"; monitor = "DP-2"; layout = "master"; }
          { workspace = "4"; monitor = "DP-2"; layout = "master"; }
          { workspace = "5"; monitor = "DP-2"; layout = "master"; }
          { workspace = "6"; monitor = "DP-1"; layout = "master"; }
          { workspace = "7"; monitor = "DP-1"; layout = "master"; }
          { workspace = "8"; monitor = "DP-1"; layout = "master"; }
          { workspace = "9"; monitor = "DP-1"; layout = "master"; }
          { workspace = "10"; monitor = "DP-1"; layout = "master"; }
        ];

        window_rule = [
          {
            name = "suppress-maximize-events";
            match = { class = ".*"; };
            suppress_event = "maximize";
          }
          {
            name = "fix-xwayland-drags";
            match = {
              class = "^$";
              title = "^$";
              xwayland = true;
              float = true;
              fullscreen = false;
              pin = false;
            };
            no_focus = true;
          }
          {
            name = "move-hyprland-run";
            match = { class = "hyprland-run"; };
            move = "20 monitor_h-120";
            float = true;
          }
          {
            name = "gamescope-immediate";
            match = { class = "^(gamescope)$"; };
            immediate = true;
          }
          {
            name = "table-plus";
            match = { class = "^(TablePlus|tableplus|table-plus)$"; };
            opacity = 0.96;
          }
          {
            name = "browser-glass";
            match = { class = "^(helium|Helium|chromium-browser)$"; };
            opacity = 0.96;
          }
        ];
      };
    };
  };
}
