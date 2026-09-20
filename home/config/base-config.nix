let
  SHARED = ./shared;
in
{
  home.file = {
    ".config/gowall" = {
      source = "${SHARED}/gowall";
      recursive = true;
    };
    ".config/waybar" = {
      source = "${SHARED}/waybar";
      recursive = true;
    };
    # ".config/quickshell" = {
    #   source = "${SHARED}/quickshell";
    #   recursive = true;
    # };
    ".config/hypr/hyprpaper.conf" = {
      source = "${SHARED}/hypr/hyprpaper.conf";
    };
  };
}
