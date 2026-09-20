{
  # Firefox with a Tropical Wet glass theme: transparent tab bar that lets
  # Hyprland's blur show through, while page content stays opaque.
  # Requires user to enable toolkit.legacyUserProfileCustomizations.stylesheets
  # in about:config (or it's set below via Settings API where supported).
  programs.firefox = {
    enable = true;
    profiles.zyriel = {
      id = 0;
      name = "zyriel";
      isDefault = true;
      settings = {
        # Enable userChrome.css loading
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Native Wayland
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        # Don't check default browser on every launch
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;
        # Allow transparent regions in the window chrome (required for glass tab bar)
        "widget.translucent-windows" = true;
        "browser.tabs.inTitlebar" = 1;
      };
      userChrome = ''
        /* ===== Tropical Wet — glass tab bar ===== */
        /* Root variables (Tropical Wet palette) */
        :root {
          --tw-base00: #0d1f14;
          --tw-base01: #12291b;
          --tw-base02: #173322;
          --tw-base03: #3d5a47;
          --tw-base04: #6f8f7c;
          --tw-base05: #e8f0ea;
          --tw-accent: #8fce6a;
          --tw-teal: #5cc8b0;
          --tabpanel-background-color: var(--tw-base00);
        }

        /* Make the whole browser chrome area transparent-capable.
           The content area stays opaque via --tabpanel-background-color. */
        #main-window,
        #navigator-toolbox,
        #titlebar,
        #TabsToolbar,
        #toolbar-menubar {
          background: transparent !important;
          background-color: transparent !important;
        }

        /* Nav bar: semi-transparent glass tint (still readable) */
        #nav-bar {
          background: color-mix(in srgb, var(--tw-base01) 55%, transparent) !important;
          background-color: color-mix(in srgb, var(--tw-base01) 55%, transparent) !important;
          border: none !important;
          box-shadow: none !important;
        }

        /* Bookmarks bar: same glass treatment */
        #PersonalToolbar {
          background: color-mix(in srgb, var(--tw-base01) 45%, transparent) !important;
          background-color: color-mix(in srgb, var(--tw-base01) 45%, transparent) !important;
        }

        /* Tab strip container: transparent */
        #tabbrowser-tabs,
        .tabbrowser-arrowscrollbox,
        #tabbrowser-arrowscrollbox {
          background: transparent !important;
          background-color: transparent !important;
        }

        /* Inactive tabs: subtle glass */
        .tabbrowser-tab:not([selected]) .tab-content {
          background: color-mix(in srgb, var(--tw-base00) 35%, transparent) !important;
        }

        /* Active tab: more solid but still slightly glassy */
        .tabbrowser-tab[selected] .tab-content {
          background: color-mix(in srgb, var(--tw-base02) 75%, transparent) !important;
          color: var(--tw-base05) !important;
        }

        /* Tab close button / icons */
        .tab-icon-image,
        .tab-close-button {
          color: var(--tw-base05) !important;
        }

        /* Window controls area */
        #titlebar {
          background: transparent !important;
          background-color: transparent !important;
        }

        /* Remove the default browser chrome border */
        #navigator-toolbox {
          background: transparent !important;
          border: none !important;
        }

        /* URL bar: glassy dark */
        #urlbar-background {
          background: color-mix(in srgb, var(--tw-base02) 70%, transparent) !important;
          border: 1px solid color-mix(in srgb, var(--tw-teal) 30%, transparent) !important;
        }

        /* Text colors */
        #TabsToolbar,
        #nav-bar,
        #PersonalToolbar {
          color: var(--tw-base05) !important;
        }

        /* Selected tab text */
        .tabbrowser-tab[selected] .tab-label {
          color: var(--tw-base05) !important;
        }

        /* Inactive tab text */
        .tabbrowser-tab:not([selected]) .tab-label {
          color: var(--tw-base04) !important;
        }
      '';
    };
  };
}
