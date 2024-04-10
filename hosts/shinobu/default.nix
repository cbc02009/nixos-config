{
  pkgs,
  lib,
  hostname,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  local = {
    vscode-server.enable = true;
    wsl.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [deploy-rs];
  };

  config = {
    networking = {
      hostName = "Shinobu";  
    };

    users.users.cbc02009 = {
      name = "cbc02009";
      home = "/Users/cbc02009";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = lib.strings.splitString "\n" (builtins.readFile ../../homes/cbc02009/config/ssh/ssh.pub);
    };

    system.activationScripts.postActivation.text = ''
      # Must match what is in /etc/shells
      sudo chsh -s /run/current-system/sw/bin/fish cbc02009
    '';
  };
}
