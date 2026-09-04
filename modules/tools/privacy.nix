{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tor
    torsocks
    proxychains-ng
    macchanger
  ];
}