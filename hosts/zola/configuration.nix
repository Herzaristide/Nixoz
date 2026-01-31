{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "zola";

  # Boot configuration
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";  # Common EFI mount point
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      theme = "/etc/grub-themes/lain";
      gfxmodeEfi = "1920x1080";
    };
  };

  # NVIDIA configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
    nvidia.open = false;
    nvidia.nvidiaSettings = true;
  };

  # NVIDIA unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "cuda_cudart"
    "libcublas"
    "cuda_cccl"
    "cuda_nvcc"
    "nvidia-x11"
    "nvidia-settings"
    "libnvoptix"
  ];

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

  # Ollama (with potential CUDA acceleration)
  services.ollama.enable = true;
  # services.ollama.acceleration = "cuda";  # Uncomment if needed

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
