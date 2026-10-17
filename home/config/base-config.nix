let
  SHARED = ./shared;
  THEMES = ../../themes;
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
    ".config/hypr/hyprpaper.conf" = {
      source = "${SHARED}/hypr/hyprpaper.conf";
    };
    ".config/zed/themes" = {
      source = "${THEMES}/zed";
      recursive = true;
    };
  };
}
