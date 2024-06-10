{ lib, pkgs, self, config, inputs, ... }:
with config;
{
  imports = [
    ./global.nix
  ];


  myHome.security = {
    ssh = {
      #TODO make this dynamic
      enable = true;
      matchBlocks = {
        nixos-test-vm = {
          hostname = "nixos-test-vm";
          port = 22;
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };


  myHome = {
    shell = {

      starship.enable = true;
      fish.enable = true;
      wezterm.enable = true;

      git = {
        enable = true;
        username = "Christopher Conroy";
        email = "39525900+cbc02009@users.noreply.github.com";
        signingKey = "A18550944C8C4721";
      };

    };
  };
}