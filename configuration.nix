# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia-config.nix

    # sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
    # sudo nix-channel --update
    # nix-shell '<home-manager>' -A install
    <home-manager/nixos>
  ];

  # mirror
  nix.settings.substituters =
    [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi = { canTouchEfiVariables = true; };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      theme = /etc/nixos/sekiro_grub_theme;
      splashImage = /etc/nixos/sekiro_grub_theme/sekiro_2560x1440.png;
    };
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "nixos"; # Define your hostname.
    # proxy.default = "http://127.0.0.1:7890";
    # proxy.allProxy = "socks5://127.0.0.1:7890";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    firewall = {
      enable = false;
      allowedTCPPorts = [ 8080 ];
    };
    # extraHosts =
    #   ''
    #     185.199.108.133 raw.githubusercontent.com
    #   '';
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    pulseaudio.enable = false;
  };

  security.rtkit.enable = true; # PulseAudio uses this
  sound.enable = true;

  services = {
    blueman.enable = true;
    openssh.enable = true; # Enable the OpenSSH daemon.
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    printing.enable = true; # Enable CUPS to print documents.
    pipewire = { # Enable sound with pipewire.
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
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
      "282a36"
      "ff5555"
      "50fa7b"
      "f1fa8c"
      "bd93f9"
      "ff79c6"
      "8be9fd"
      "f8f8f2"
      "6272a4"
      "ff7777"
      "70fa9b"
      "ffb86c"
      "cfa9ff"
      "ff88e8"
      "97e2ff"
      "ffffff"
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
    fcitx5.addons = with pkgs; [ fcitx5-rime ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      wqy_zenhei # steam font
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "SF Pro"
          "FiraCode Nerd Font"
          "NotoSerif Nerd Font"
          "Noto Sans CJK"
        ];
        sansSerif = [
          "SF Pro"
          "FiraCode Nerd Font"
          "NotoSans Nerd Font"
          "Noto Sans CJK"
        ];
        monospace = [
          "SF Mono"
          "FiraCode Nerd Font"
          "NotoMono Nerd Font"
          "Noto Sans CJK"
        ];
        emoji = [ "Apple Color Emoji" "Noto Color Emoji" ];
      };
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    #NIXOS_OZONE_WL = "1";  # # Hint Electon apps to use wayland
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
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
        wayland.enable = false;
      };
      # defaultSession = "hyprland";
      # setupCommands = "Hyprland";

      defaultSession = "none+awesome";
    };

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };

    xautolock = {
      enable = true;
      locker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -gp";
      nowlocker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -gp";
      time = 15;
    };
  };

  security.pam.services.swaylock.fprintAuth = false; # Fix swaylock

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

    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "store";
    };

    fish.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libGL
    killall
    gnumake
    libgccjit
    cmake
    openssl
    nmap

    where-is-my-sddm-theme
    feh
    hyprpaper
    picom
    i3lock-fancy
    swaylock
    shutter # screenshot
    grimblast # screenshot wayland
    pasystray
    pulsemixer
    pwvucontrol # audio control #pavucontrol
    clash-meta
    xclip
    wl-clipboard
    freerdp

    # Modern unix tools
    btop
    htop
    bottom
    glances
    bat # cat
    choose # cut
    du-dust
    dua # du
    duf # df
    eza # ls
    fd # find
    httpie # curl
    procs # ps
    ripgrep # grep
    jq
    fx # json
    tree
    cht-sh
    tmux
    byobu
    neofetch
    cava
    genact
    lolcat
    nms
    systemctl-tui
    bluetuith
    lazygit
    tig
    vim
    wget
    ranger
    unzip
    p7zip

    # GUI apps
    kitty
    qview
    cinnamon.pix
    nomacs
    rofi
    dmenu
    firefox-bin
    pcmanfm
    networkmanagerapplet
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
  system.stateVersion = "23.11"; # Did you read the comment?

  # home-manager
  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };
  home-manager.useGlobalPkgs = true;
}
