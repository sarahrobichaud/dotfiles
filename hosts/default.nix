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
              users.zyriel.imports = home.zyriel;
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
          # Required for qmlls to find the correct type declarations
          export QMLLS_BUILD_DIRS=${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/
          export QML_IMPORT_PATH=$PWD/src
        '';
      };
    };
}
