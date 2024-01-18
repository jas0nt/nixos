# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/jason/nixos/home/home.nix
    ];

  # mirror
  nix.settings.substituters = ["https://mirrors.ustc.edu.cn/nix-channels/store"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "nixos"; # Define your hostname.
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    pulseaudio.enable = true;
  };

  security.rtkit.enable = true;  # PulseAudio uses this
  sound.enable = true;

  services = {
    blueman.enable = true;
    openssh.enable = true;  # Enable the OpenSSH daemon.
    devmon.enable = true;
    gvfs.enable = true; 
    udisks2.enable = true;
    printing.enable = true;  # Enable CUPS to print documents.
    pipewire = {  # Enable sound with pipewire.
      enable = false;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # services.xserver.libinput.enable = true;  Enable touchpad support.
    aria2.enable = true;
  };

  # docker
  virtualisation.docker.enable = true;

  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-114n.psf.gz";
    keyMap = "us";
    colors = [
        "282a36" "ff5555" "50fa7b" "f1fa8c" "bd93f9" "ff79c6" "8be9fd" "f8f8f2"
        "6272a4" "ff7777" "70fa9b" "ffb86c" "cfa9ff" "ff88e8" "97e2ff" "ffffff"
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      wqy_zenhei  #steam
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-code-pro
    ];
  
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans CJK" ];
        sansSerif = [ "Noto Sans CJK" ];
        monospace = [ "Noto Sans CJK" ];
      };
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    #NIXOS_OZONE_WL = "1";  # # Hint Electon apps to use wayland
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  # X
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us";
    #xkbVariant = "qwerty";

    excludePackages = [ pkgs.xterm ];

    displayManager = {
      # Enable automatic login for the user.
      autoLogin.enable = true;
      autoLogin.user = "jason";
      sddm = {
          enable = true;
          theme = "where_is_my_sddm_theme";
          wayland.enable = true;
      };
      defaultSession = "hyprland";
      setupCommands = "Hyprland";
      #defaultSession = "none+awesome";
    };

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };

    xautolock = {
      enable = false;
      locker = "${pkgs.swaylock}/bin/swaylock";
      nowlocker = "${pkgs.swaylock}/bin/swaylock";
      time = 5;
    };
  };

  security.pam.services.swaylock.fprintAuth = false;  # Fix swaylock

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs = {
    hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = true;
    };

    waybar = {
      enable = true;
      package = pkgs.waybar;
    };

    fish.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xwayland
    qt6.qtwayland
    killall
    gnumake libgccjit cmake
    openssl
    nmap

    where-is-my-sddm-theme
    hyprpaper
    picom
    swaylock

    # Modern unix tools
    htop bottom bat eza broot jq du-dust duf fd procs httpie tree fzf ripgrep
    tmux
    cava
    genact
    lolcat
    nms
    systemctl-tui
    bluetuith
    git lazygit tig
    vim
    wget
    neofetch
    nnn ranger
    unzip p7zip

    rofi
    dmenu
    firefox
    pcmanfm
    clash-meta
    networkmanagerapplet
    grimblast  # screenshot
    nwg-look
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
