{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "cpu" "memory" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        clock = {
          format = "  {:%H:%M   %d/%m/%Y}";
          tooltip = false;
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ifname}";
          format-disconnected = "  disconnected";
          tooltip-format = "{ipaddr}/{cidr}";
        };

        cpu = {
          format = "  {usage}%";
          tooltip = false;
        };

        memory = {
          format = "  {}%";
        };

        battery = {
          format = "{icon}  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: #0A0A0F;
        color: #E0E0FF;
        border-bottom: 2px solid #FF2079;
      }

      #workspaces button {
        padding: 0 8px;
        color: #1A1A22;
        background: transparent;
      }

      #workspaces button.active {
        color: #FF2079;
        border-bottom: 2px solid #00F0FF;
      }

      #workspaces button:hover {
        background: #1A1A22;
      }

      #clock {
        color: #00F0FF;
        font-weight: bold;
        padding: 0 12px;
      }

      #network,
      #cpu,
      #memory,
      #battery,
      #tray {
        padding: 0 10px;
        color: #E0E0FF;
      }

      #network {
        color: #00F0FF;
      }

      #cpu {
        color: #F9E900;
      }

      #memory {
        color: #FF2079;
      }

      #battery {
        color: #39FF14;
      }

      #battery.warning {
        color: #F9E900;
      }

      #battery.critical {
        color: #FF2079;
      }
    '';
  };
}