{ config, pkgs, ... }:

{
  imports = [
    ../modules/vmware-guest.nix
    ./vm-shared.nix
  ];

  disabledModules = [
    # Default vmware-guest module does not support aarch64.
    "virtualisation/vmware-guest.nix"
  ];

  environment.systemPackages = [
    pkgs.qemu-user-static
  ];

  # Kernel patches currently needed to boot on aarch64 (?)
  boot.kernelPatches = [
    {
      name = "efi-initrd-support";
      patch = null;
      extraConfig = ''
        EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER y
      '';
    }
  ];

  # ens160 is the default interface with VMWare Fusion.
  networking.interfaces.ens160.useDHCP = true;

  nixpkgs.config.allowUnfree = true;
  # Allow building packages that aren't officially supported for aarch64.
  nixpkgs.config.allowUnsupportedSystem = true;

  # Enable the (modified) vmware-guest module to build/install open-vm-tools.
  virtualisation.vmware.guest.enable = true;

  # Share our host filesystem
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=4000"
      "gid=4000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };
}
