{ config, lib, pkgs, imports, boot, self, inputs, ... }:
# Role for cli-based installs like VMs and WSL
# Will have home-manager installs

with config;
{

  mySystem = {

    # Lets see if fish everywhere is OK on the pi's
    # TODO decide if i drop to bash on pis?
    shell.fish.enable = true;

  };

  boot = {

    binfmt.emulatedSystems = [ "aarch64-linux" ]; # Enabled for raspi4 compilation

  };

  services = {
    fwupd.enable = config.boot.loader.systemd-boot.enable; # fwupd does not work in BIOS mode
  };

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };

  programs.mtr.enable = true;

}
