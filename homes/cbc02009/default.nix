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

      git = {
        enable = true;
        username = "Christopher Conroy";
        email = "39525900+cbc02009@users.noreply.github.com";
        signingKey = "A18550944C8C4721"
      };

      go-task.enable = true;

    };
  };
}
