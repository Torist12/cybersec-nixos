{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    john
    hashcat
    thc-hydra           # VERIFY: nome usado pra evitar conflito com o pacote "hydra" (CI da NixOS)
    crunch
    sshpass
    # cewl              # VERIFY: pode não estar empacotado
  ];
}