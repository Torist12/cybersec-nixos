{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    radare2
    ghidra
    gdb
    binutils            # inclui objdump
    strace
    ltrace
  ];
}