{ ... }:

{
  services.mako = {
    enable = true;

    font = "JetBrainsMono Nerd Font 11";

    backgroundColor = "#0A0A0Fee";
    textColor = "#E0E0FF";
    borderColor = "#FF2079";
    progressColor = "over #1A1A22";

    borderSize = 2;
    borderRadius = 6;
    padding = "10";
    margin = "8";
    width = 320;
    height = 110;

    defaultTimeout = 5000;
    layer = "overlay";
    anchor = "top-right";

    extraConfig = ''
      [urgency=low]
      border-color=#00F0FF

      [urgency=critical]
      border-color=#F9E900
      default-timeout=0
    '';
  };
}