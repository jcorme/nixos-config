{ config, pkgs, ... }:

{
  imports = [
    ../modules/binfmt.nix
    ../modules/vmware-guest.nix
    ./vm-shared.nix
  ];

  disabledModules = [
    # Default vmware-guest module does not support aarch64.
    "virtualisation/vmware-guest.nix"

    # Sets interpreter to /run/binfmt/${name}, which causes docker buildx to
    # not see x86_64 as a supported platform for some reason.
    "system/boot/binfmt.nix"
  ];

  nixpkgs.overlays = [
    (import ../overlays)
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

  # Register qemu-x86_64 binfmt so we can build x86 container images
  boot.binfmt.registrations = {
    qemu-x86_64 = {
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
      interpreter = "/run/current-system/sw/bin/qemu-x86_64-static";
      preserveInterpreter = true;
      matchCredentials = true;
      fixBinary = true;
    };
  };

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
