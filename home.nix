{ config, pkgs, lib, hostname ? "", dotfilesDir ? "", ... }:

let
  # Get hostname from extraSpecialArgs, fallback to environment variable or default
  currentHostname = if hostname != "" then hostname else (builtins.getEnv "HOSTNAME");
  isDesktop = currentHostname != "exupery";
  # Use dotfilesDir if provided, otherwise fallback to ~/.dotfiles
  dotfilesPath = if dotfilesDir != "" then dotfilesDir else "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = "aristide";
  home.homeDirectory = "/home/aristide";
  home.stateVersion = "25.05"; 

  imports = [
    ./modules/fish/fish.nix
    ./modules/fastfetch/fastfetch.nix
  ] ++ lib.optionals isDesktop [
    ./modules/bongocat/bongocat.nix
    ./modules/kitty/kitty.nix
    ./modules/ghostty/ghostty.nix
    ./modules/waybar/waybar.nix
    ./modules/rofi/rofi.nix
    ./modules/hyprland/hyprland.nix
  ];

  home.packages = with pkgs; [
    # CLI tools - available on all hosts
    unzip
    git
    tmux
    btop
    curl
    jq
    atuin
    zoxide
    direnv
    starship
    fastfetch
    python311
    gcc
    lua-language-server
    luajit
    yazi
    toipe
    entr
    # Docker and Podman CLI tools
    docker
    podman
  ] ++ lib.optionals isDesktop [
    # GUI packages - only for desktop hosts (gary and zola)
    swww
    ffmpeg
    qbittorrent
    caligula
    zathura
    texliveMedium
    waybar
    kitty
    hyprsunset
    gimp
    audacity
    vlc
    ani-cli
    code-cursor
    libreoffice-qt6
    mpv
    kooha
    floorp
    hyprpaper
    rofi-wayland
    pyprland
    grim
    slurp
    wl-clipboard
    hyprlock
    hypridle
    waypaper
    pavucontrol
    cava
    playerctl
    copyq
    dunst
    libnotify
    brightnessctl
    imv
    ghostty
    powertop
    pulseaudio
    mpc
    ncmpcpp
    protonup
    octaveFull
    wf-recorder
    bibata-cursors
    desktop-file-utils
    xdg-desktop-portal
    xdg-desktop-portal-wlr
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  } // lib.optionalAttrs isDesktop {
    wallpaper = "/home/aristide/NMN/Luminarium";
    BROWSER = "app.zen_browser.zen";
    DEFAULT_BROWSER = "app.zen_browser.zen";
    NIXOS_OZONE_WL = "1";
  };

  xdg.mimeApps = lib.mkIf isDesktop {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      
      "x-scheme-handler/http" = "floorp.desktop";
      "x-scheme-handler/https" = "floorp.desktop";
      "x-scheme-handler/chrome" = "floorp.desktop";
      "text/html" = "floorp.desktop";
      "application/x-extension-htm" = "floorp.desktop";
      "application/x-extension-html" = "floorp.desktop";
      "application/x-extension-shtml" = "floorp.desktop";
      "application/xhtml+xml" = "floorp.desktop";
      "application/x-extension-xhtml" = "floorp.desktop";
      "application/x-extension-xht" = "floorp.desktop";
      "x-scheme-handler/unityhub" = "unityhub.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/jpg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/bmp" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/tiff" = "imv.desktop";
    };
  };

  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.fish.enable = true;

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/nvim";
    recursive = true;
  };

  nixpkgs.config.allowUnfree = true;

  xdg.portal = lib.mkIf isDesktop {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr 
      xdg-desktop-portal-gtk  
    ];
    config.common.default = "*"; 
  };
}
