{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
    };
  };

  # Tropical Wet glass theme, loaded as an unpacked extension at launch.
  # Pair with a Hyprland window rule (opacity ~0.93) for the glass effect.
  xdg.dataFile."helium-glass-theme/manifest.json".source =
    ../../config/shared/browser/helium-glass-theme/manifest.json;
}
