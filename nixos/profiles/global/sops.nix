{ config
, lib
, ...
}:
{

  sops.age.sshKeyPaths = [ (if config.mySystem.system.impermanence.enable then "/persist/etc/ssh/ssh_host_ed25519_key" else "/etc/ssh/ssh_host_ed25519_key") ];

}
