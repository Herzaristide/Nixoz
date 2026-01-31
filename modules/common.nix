{ lib, pkgs, ... }:

{
  # System state version
  system.stateVersion = "25.05";

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "default";

  # Timezone and locale
  time.timeZone = "Asia/Kathmandu";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Console keyboard layout (for TTY)
  console.keyMap = "fr";

  # User configuration
  programs.fish.enable = true;
  users.users.aristide = {
    isNormalUser = true;
    description = "Naman Adhikari";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "podman" ];
  };

  # Docker and Podman
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  # Common services
  services.printing.enable = true;
  services.passSecretService.enable = true;

  # Audio (Pipewire)
  services.pipewire.wireplumber.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Common environment variables
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "app.zen_browser.zen";
    DEFAULT_BROWSER = "app.zen_browser.zen";
    NIXOS_OZONE_WL = "1";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Common system packages (CLI tools that all hosts need)
  environment.systemPackages = with pkgs; [
    wget
    fish
    inotify-tools
    psmisc
    git
    curl
    jq
  ];
}
