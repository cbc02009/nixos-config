{
  pkgs,
  lib,
  inputs,
  hostname,
  flake-packages,
  ...
}:
{
  imports = [
    ../_modules

    ./secrets
    ./hosts/${hostname}.nix
  ];

  modules = {
  
    security = {
      ssh = {
        enable = true;
        matchBlocks = {
          "gateway.ctec.run" = {
            port = 22;
            user = "vyos";
          };
          "shinobu.ctec.run" = {
            port = 22;
            user = "cbc02009";
            forwardAgent = true;
          };
        };
      };
    };

    shell = {
      fish.enable = true;

      # TODO
      # git = {
      #   enable = true;
      #   username = "cbc02009";
      #   email = "me@cbc02009.dev";
      # };

      go-task.enable = true;

    };
  };
}
