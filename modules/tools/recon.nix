{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nmap
    masscan
    theHarvester       # VERIFY: capitalização exata pode variar
    amass
    subfinder
    whois
    dnsutils
    # sherlock         # VERIFY: nome pode conflitar com outro pacote "sherlock" no nixpkgs
  ];
}