{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    volatility3
    binwalk
    foremost
    sleuthkit
    exiftool
    # autopsy           # VERIFY: suporte Linux/packaging incerto
  ];
}