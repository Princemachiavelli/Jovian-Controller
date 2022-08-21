{
  description = "Steam Deck Controller Service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  };

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      allowUnfree = true;
      overlays = [
        self.overlay
      ];
    };
  in {
    overlay = final: prev: (import ./overlay.nix) final prev;
    packages.x86_64-linux = rec {
      jovian-controller = pkgs.jovian-controller; 
      default = jovian-controller;
    };
  };
}
