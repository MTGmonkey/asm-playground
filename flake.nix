{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
  };
  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = {
      default = pkgs.callPackage ./package.nix {};
      test = pkgs.callPackage ./test.nix {};
    };
  };
}
