{ config, pkgs, currentSystem, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15;

  system.stateVersion = "21.05";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "neon";
    useDHCP = false;

    firewall.enable = false;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  hardware.video.hidpi.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "America/Los_Angeles";
  users.mutableUsers = false;
  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;

    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;

    displayManager = {
      defaultSession = "none+i3";
      sddm.enable = true;

      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr -s '2880x1800'
      '' + ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
        Xft.dpi: 220
        EOF
      '';
    };

    windowManager = {
      i3.enable = true;
    };
  };
}
