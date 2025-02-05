{
  description = "Home Manager configuration of amin";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
	config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
    in {
      homeConfigurations."amin" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ 
			./home.nix
		];
        extraSpecialArgs = {
          inherit nixgl;
        };
      };
    };
}
