# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config
, lib
, pkgs
, ...
}: {
  mySystem.purpose = "NixOs Configuration test vm";
  mySystem.system.impermanence.enable = true;

  mySystem.services = {
    openssh.enable = true;
  }

  boot = {

    initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    # for managing/mounting ntfs
    supportedFilesystems = [ "ntfs" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # why not ensure we can memtest workstatons easily?
      # TODO check whether this is actually working, cant see it in grub?
      grub.memtest86.enable = true;

    };
  };

  networking.hostName = "nixos-test-vm"; # Define your hostname.
  networking.useDHCP = lib.mkDefault true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8123b81d-1c78-4698-a8b6-f8184477b5d6";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/837A-F8A1";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/001c00b3-19e2-4810-acd8-16bb895c87f3"; }
    ];
    
}