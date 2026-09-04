{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wireshark
    tcpdump
    netcat-gnu
    socat
    arp-scan
    ettercap
    bettercap
  ];
}