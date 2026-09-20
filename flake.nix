{
	description = "NixOS Config";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		flake-parts = {
			url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    helium = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    		stylix = {
    			url = "github:nix-community/stylix";
    			inputs.nixpkgs.follows = "nixpkgs";
    		};
    		sops-nix = {
    			url = "github:Mic92/sops-nix";
    			inputs.nixpkgs.follows = "nixpkgs";
    		};
	};

	outputs = inputs @ { flake-parts, ...}:
	  flake-parts.lib.mkFlake { inherit inputs; } {
	    systems = [ "x86_64-linux" ];
			imports = [ ./hosts ];
		};
}
