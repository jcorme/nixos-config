name: { nixpkgs, home-manager, system, user }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    ../hardware/${name}.nix
    ../hosts/${name}.nix
    ../users/${user}/nixos.nix
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/${user}/home-manager.nix;
    }
  ];

  extraArgs = {
    currentSystem = system;
  };
}
