{ config, pkgs, lib, ... }:

{
  imports = [
    ./steam.nix
    ./amd.nix
  ];
}
