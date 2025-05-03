{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, lix-module, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        catppuccin.nixosModules.catppuccin
        lix-module.nixosModules.default

        home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mattie = {
                imports = [
                  ./home.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
              home-manager.backupFileExtension = ".backup";
              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
