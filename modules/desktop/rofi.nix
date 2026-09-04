{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    font = "JetBrainsMono Nerd Font 12";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      drun-display-format = "{icon} {name}";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#0A0A0F";
        bg-alt = mkLiteral "#1A1A22";
        fg = mkLiteral "#E0E0FF";
        accent = mkLiteral "#FF2079";
        accent-alt = mkLiteral "#00F0FF";

        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@fg";
      };

      window = {
        width = mkLiteral "600px";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "8px";
      };

      inputbar = {
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@fg";
        padding = mkLiteral "10px";
        border-radius = mkLiteral "6px";
        children = map mkLiteral [ "prompt" "entry" ];
      };

      prompt = {
        text-color = mkLiteral "@accent";
        font = "JetBrainsMono Nerd Font Bold 12";
      };

      entry = {
        placeholder = "Search...";
        placeholder-color = mkLiteral "#6A6A80";
      };

      listview = {
        lines = 8;
        spacing = mkLiteral "4px";
        margin = mkLiteral "8px 0 0 0";
      };

      element = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "6px";
      };

      "element normal.normal" = {
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@fg";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@accent-alt";
        border = mkLiteral "1px";
        border-color = mkLiteral "@accent-alt";
      };

      element-icon = {
        size = mkLiteral "24px";
        vertical-align = mkLiteral "0.5";
      };
    };
  };
}