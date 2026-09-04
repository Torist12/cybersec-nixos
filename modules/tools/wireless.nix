{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aircrack-ng
    wireguard-tools
    kismet
    # reaverwps         # VERIFY: nome do fork pode variar (reaver / reaverwps-t6x)
  ];
}