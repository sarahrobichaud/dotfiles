{ self, ...}:
{
  home.file = {
    "scripts/preview-latex.sh" = {
      source = "${self}/home/scripts/preview-latex.sh";
      executable = true;
    };
    "scripts/themify.sh" = {
      source = "${self}/home/scripts/themify.sh";
      executable = true;
    };
  };
}
