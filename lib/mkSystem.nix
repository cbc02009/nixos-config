{
  inputs,
  ...
}:
{
  mkNixosSystem = system: hostname: overlays: flake-packages:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
      modules = [
        {
          nixpkgs.hostPlatform = system;
          _module.args = {
            inherit inputs flake-packages;
          };
        }
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
            ];
            extraSpecialArgs = {
              inherit inputs hostname flake-packages;
            };
            users.cbc02009 = ../. + "/homes/cbc02009";
          };
        }
        ../hosts/_modules/common
        ../hosts/_modules/nixos
        ../hosts/${hostname}
      ];
      specialArgs = {
        inherit inputs hostname;
      };
    };
}
