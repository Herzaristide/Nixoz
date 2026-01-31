{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "exupery";

  # WSL/Headless configuration - minimal boot
  boot.loader.grub.enable = false;  # WSL doesn't use GRUB
  # boot.kernelParams can be set if needed for WSL

  # No X server, no display manager, no Wayland
  # services.xserver.enable = false;  # Default is false
  # No display manager
  # No hyprland

  # No desktop services
  # No TLP (power management not needed in WSL)
  # No flatpak
  # No bluetooth (WSL typically doesn't have direct hardware access)

  # Ollama can still be useful in headless
  services.ollama.enable = true;

  # Minimal system packages for WSL/headless
  environment.systemPackages = with pkgs; [
    # Only essential CLI tools, no GUI packages
  ];
}
