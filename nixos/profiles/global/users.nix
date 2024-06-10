{ pkgs
, config
, ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{

  sops.secrets = {
    cbc02009-password = {
      sopsFile = ./secrets.sops.yaml;
      neededForUsers = true;
    };
  };

  users.users.cbc02009 = {
    isNormalUser = true;
    shell = pkgs.fish;
    hashedPasswordFile = config.sops.secrets.cbc02009-password.path;
    extraGroups =
      [
        "wheel"
      ]
      ++ ifTheyExist [
        "network"
        "samba-users"
        "docker"
        "podman"
        "audio" # pulseaudio
        "libvirtd"
      ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJMeEa+xfvD5/pyA6wim4IZywbdcI7SboTzEaysVGN6 Chris@Shinobu"
    ]; # TODO do i move to ingest github creds?

    # packages = [ pkgs.home-manager ];
  };

}
