{
  pkgs,
  lib,
  config,
  hostname,
  username,
  ...
}:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    networking = {
      hostName = "Yuzu"; 
      domain = "ctec.run";
      nameservers = ["172.27.48.1"]; 
    };

    local = {
      # vscode-server.enable = true;
      wsl.enable = true;
    };

    # environment = {
    #   systemPackages = with pkgs; [deploy-rs];
    # };

    users.users.cbc02009 = {
      uid = 1000;
      name = "cbc02009";
      home = "/home/cbc02009";
      group = "cbc02009";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = lib.strings.splitString "\n" (builtins.readFile ../../homes/cbc02009/config/ssh/ssh.pub);
      isNormalUser = true;
      extraGroups =
        [
          "wheel"
          "users"
        ]
        ++ ifGroupsExist [
          "network"
          "samba-users"
        ];
    };
    users.groups.cbc02009 = {
      gid = 1000;
    };

    system.activationScripts.postActivation.text = ''
      # Must match what is in /etc/shells
      sudo chsh -s /run/current-system/sw/bin/fish cbc02009
    '';
  };
}
