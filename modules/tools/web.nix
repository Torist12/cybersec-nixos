{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    burpsuite
    sqlmap
    gobuster
    ffuf
    nikto
    httpie
    # wfuzz            # VERIFY: pode estar ausente/quebrado em algumas versões do nixpkgs
  ];
}