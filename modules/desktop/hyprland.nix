{ config, pkgs, hyprland, ... }:

{
  home.packages = with pkgs; [
    rofi-wayland      # app launcher
    mako              # notificações
    hyprpaper         # wallpaper
    hyprlock          # lock screen
    grim              # screenshot
    slurp             # seleção de área pra screenshot
    wl-clipboard      # clipboard Wayland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      monitor = ",preferred,auto,1";

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$launcher" = "rofi -show drun";

      exec-once = [
        "hyprpaper"
        "mako"
        "waybar"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgb(FF2079) rgb(00F0FF) 45deg";
        "col.inactive_border" = "rgb(1A1A22)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 6;
        active_opacity = 1.0;
        inactive_opacity = 0.92;

        blur = {
          enabled = true;
          size = 4;
          passes = 2;
        };

        shadow = {
          enabled = true;
          range = 12;
          color = "rgba(FF207955)";
        };
      };

      animations = {
        enabled = true;
        bezier = "wd2, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 4, wd2"
          "border, 1, 6, default"
          "fade, 1, 4, default"
          "workspaces, 1, 4, wd2"
        ];
      };

      input = {
        kb_layout = "br";
        follow_mouse = 1;
        sensitivity = 0;
      };

      "$fingerprint" = "";

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, D, exec, $launcher"
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, L, exec, hyprlock"

        # navegação estilo vim/i3 (consistência com tmux/nvim)
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Wallpaper (preto — combina com a paleta, sem imagem externa necessária)
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = 
    wallpaper = ,#0A0A0F
  '';

  # Lock screen com a paleta do tema
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [{
        color = "rgb(0A0A0F)";
      }];
      input-field = [{
        size = "250, 50";
        outer_color = "rgb(FF2079)";
        inner_color = "rgb(1A1A22)";
        font_color = "rgb(E0E0FF)";
      }];
    };
  };
}