# Define my primary user.

{ pkgs, ... }: {
  users.groups = {
    jason = {
      gid = 4000;
    };
  };

  users.users = {
    jason = {
      description = "Jason Chen";

      uid = 4000;
      group = "jason";

      home = "/home/jason";
      createHome = true;

      hashedPassword = "$6$TjEEyesseIZ$OHkOzhVilLftauEByZw.HAYB2q.fJhJDswFtVtGcfglUNA85QkkbRncej/Ai8FZ6wrmGoYs3oOzSwturJrEo//";

      extraGroups = [ "docker" "wheel" ];
      isNormalUser = true;
      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMhDhrT4lDNIUQAJexOmAL7HEAV1wmGIX79SOedsOr+u jason@Radon.local"
      ];
    };
  };
}
