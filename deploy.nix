{
  self,
  deploy-rs,
  ...
}:
let
  deployConfig = name: system: cfg: {
    hostname = name;
    sshOpts = cfg.sshOpts or [];

    profiles = {
      system = {
        sshUser = cfg.sshUser;
        path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
        user = "root";
      };
    };

    remoteBuild = cfg.remoteBuild or false;
    autoRollback = cfg.autoRollback or false;
    magicRollback = cfg.magicRollback or true;
  };
in
{
  deploy.nodes = {
    shinobu = deployConfig "shinobu" "x86_64-linux" {sshUser = "cbc02009"; remoteBuild = true;};
    yuzu = deployConfig "yuzu" "x86_64-linux" {sshUser = "cbc02009"; remoteBuild = true;};
  };
  checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}
