{ config, pkgs, hyprland, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/tools/recon.nix
    ./modules/tools/network.nix
    ./modules/tools/web.nix
    ./modules/tools/exploitation.nix
    ./modules/tools/password.nix
    ./modules/tools/wireless.nix
    ./modules/tools/forensics.nix
    ./modules/tools/reverse-eng.nix
    ./modules/tools/privacy.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Hostname (genérico, sem amarrar a uma máquina específica)
  networking.hostName = "cybersec-vm";
  networking.networkmanager.enable = true;

  # Locale / timezone
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Hyprland
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  # Display manager mínimo (necessário pra iniciar sessão gráfica)
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Áudio (pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Usuário
  users.users.pentester = {
    isNormalUser = true;
    description = "pentester";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
  };

  programs.zsh.enable = true;

  # SSH (útil pra acessar a VM remotamente)
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
  git
  wget
  curl
  vscode.fhs
];

  system.stateVersion = "26.05";
}