{
  description = "Jason's NixOS configuation";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, home-manager-unstable }: let
    mkVM = import ./lib/mkvm.nix;
  in {
    nixosConfigurations.vm-aarch64 = mkVM "vm-aarch64" {
      nixpkgs = nixpkgs-unstable;
      home-manager = home-manager-unstable;
      system = "aarch64-linux";
      user = "jason";
    };

    nixosConfigurations.vm-x86_64 = mkVM "vm-x86_64" {
      nixpkgs = nixpkgs-unstable;
      home-manager = home-manager-unstable;
      system = "x86_64-linux";
      user = "jason";
    };
  };
}
