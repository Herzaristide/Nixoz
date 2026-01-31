{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "gary";

  # Boot configuration
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 10;  # Keep last 10 generations
    };
  };

  # Graphics (no NVIDIA)
  hardware.graphics.enable = true;
  # No NVIDIA drivers or settings

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display Manager
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "aristide";
  services.displayManager.defaultSession = "hyprland";
  services.displayManager.sessionPackages = [ pkgs.niri ];
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Additional services
  services.flatpak.enable = true;
  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    DISK_IDLE_SECS_ON_AC = 300;
    DISK_IDLE_SECS_ON_BAT = 60;
    USB_AUTOSUSPEND = 1;
    PCIE_ASPM_ON_BAT = "powersave";
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  services.power-profiles-daemon.enable = false;
  hardware.bluetooth.enable = true;

  # Ollama
  services.ollama.enable = true;

  # Desktop system packages
  environment.systemPackages = with pkgs; [
    tlp
    flatpak
    lmms
    gparted
    niri
    unetbootin
    xwayland-satellite
    ollama
    glib
    mpd
    os-prober
  ];
}
