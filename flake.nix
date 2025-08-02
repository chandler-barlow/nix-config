{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      overlays = [
        (final: prev: {
          # nothing for now!
          # overlays are added here
        })
      ];
      defaultModules = [
        ./modules/common.nix
        home-manager.nixosModules.home-manager {
          nixpkgs.overlays = overlays;
          _module.args = { inherit inputs; };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.cbarlow = import ./home;
          };
        }
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEach = systems: f:
        nixpkgs.lib.genAttrs systems
          (system: f (import nixpkgs { inherit system overlays; }));
    in
      {
        formatter = forEach systems (pkgs: pkgs.nixpkgs-fmt);
        packages = forEach systems (pkgs: {
          homeConfig = (home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home ];
            extraSpecialArgs = { inherit inputs; };
          });
        });
        nixosConfigurations = {
          "cbarlow-vm" = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [ ./orb ] ++ defaultModules;
          };
          "home-server" = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [ ./server ] ++ defaultModules;
          };
        };
      };
}
