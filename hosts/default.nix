{ inputs, self,  ...}:
let
  home = import "${self}/home/users";
  desktop = import "${self}/hosts/desktop" { inherit self; };

  inherit (inputs.nixpkgs.lib) nixosSystem;
in
{
  flake.nixosConfigurations = {
      desktop = nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = desktop.modules ++ [
          inputs.stylix.nixosModules.stylix
          inputs.helium.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              # Monitor geometry is host-specific, so it's injected here at the
              # host layer (the monitors option lives in the HM module system).
              users.zyriel.imports = home.zyriel ++ [
                {
                  features.desktop.hyprland.monitors = [
                    {
                      output = "DP-2";
                      mode = "3440x1440@143.97";
                      position = "-900x1080";
                      scale = "1";
                    }
                    {
                      output = "DP-1";
                      mode = "1920x1080@143.98";
                      position = "0x0";
                      scale = "1";
                    }
                  ];
                }
              ];
              extraSpecialArgs = { inherit inputs self; };
              backupFileExtension = ".hm-backup";
            };
          }
          ({ ... }: {
            stylix = {
              enable = true;
              base16Scheme = "${self}/themes/tropical-wet.yaml";
              polarity = "dark";
            };
            hosts.desktop.nvidia = true;
            dotfiles.secrets.waybarRestartUnits = [ "waybar.service" ];
            features.gaming.enable = true;
            features.headroom.enable = true;
            features.media.enable = true;
            features.dev.enable = true;
          })
        ];
      };
  };
  perSystem =
    { pkgs, ... }:
    {
      devShells.quickshell = pkgs.mkShell {
        packages = [
          pkgs.quickshell
          pkgs.kdePackages.qtdeclarative
        ];
        shellHook = ''
          export QMLLS_BUILD_DIRS=${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/
          export QML_IMPORT_PATH=$PWD/src
        '';
      };
    };
}
