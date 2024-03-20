{ config, pkgs, ... }:

{
  home.stateVersion = "23.11";
  home.username = "jason";
  home.homeDirectory = "/home/jason";

  home.sessionVariables = {
    EDITOR = "lvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    iconTheme = {
      package = pkgs.beauty-line-icon-theme;
      name = "BeautyLine";
    };
  };

  # Nofification daemon
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = pkgs.lib.importTOML .config/dunst/dunstrc;
  };

  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      pip virtualenv
      epc orjson sexpdata six setuptools paramiko rapidfuzz
    ]))
    nodejs
    # nodePackages."@microsoft/inshellisense"
    rustc cargo rustfmt
    jdk
    lua

    emacs librime emacsPackages.rime
    vscode-fhs
    lunarvim

    sway-launcher-desktop
    calcure
    playerctl mpc-cli
    fortune pokemonsay
    miniserve

    wpsoffice
    qq
    spotify cmus
    mpv vlc
    qbittorrent motrix aria2
    localsend libsForQt5.kdeconnect-kde
    quickemu
    telegram-desktop
    obs-studio
  ];

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Jas0nT";
    userEmail = "taoeta@gmail.com";
    delta.enable = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      lock = "swaylock";
      logout = "loginctl terminate-user $USER";
      fuckGFW  = "export http_proxy=http://127.0.0.1:7890; and export https_proxy=http://127.0.0.1:7890; and export all_proxy=socks5://127.0.0.1:7890";
    };
    shellAbbrs = {
      nix-list-gens = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nix-del-gens = "nix-env --delete-generations --profile /nix/var/nix/profiles/system"; #gen numbers OR #older than 5 days: 5d
      icat = "kitten icat";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
    };
    functions = {
      my_audio_notify.body   = "dunstify -t 500 -i volume \"Vol: $(pulsemixer --get-volume)\"";
      my_audio_mute.body     = "pulsemixer --toggle-mute";
      my_audio_up.body       = "pulsemixer --change-volume +1\nmy_audio_notify";
      my_audio_down.body     = "pulsemixer --change-volume -1\nmy_audio_notify";
      my_launcher.body       = "sway-launcher-desktop";
      my_locker.body         = "swaylock";
      my_file_manager.body   = "ranger";
      my_screenshot.body     = "grimblast copysave area";
      gpu_fan.body           = "sudo nvidia-settings --display :1.0 -a \"[gpu:0]/GPUFanControlState=1\" -a \"[fan:0]/GPUTargetFanSpeed=$argv[1]\"";

      fish_greeting.body     = "fortune -s | pokemonsay -N";
      rgc.body               = "rg --json $argv | delta";
    };
  };

  programs.navi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    package = pkgs.starship;
    enable = true;
    enableFishIntegration = true;
    settings = pkgs.lib.importTOML .config/starship/starship.toml;
  };

  home.file = {
    # fcitx5 & rime
    ".local/share/fcitx5/themes/transparent-green"                         = { recursive = true; source = .local/share/fcitx5/themes/transparent-green; };
    ".config/fcitx5/conf/classicui.conf".source                            = .config/fcitx5/conf/classicui.conf;
    ".local/share/fcitx5/rime/default.custom.yaml".source                  = .local/share/fcitx5/rime/default.custom.yaml;
    ".local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml".source      = .local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml;

    ".local/share/fonts"                                                   = { recursive = true; source = .local/share/fonts; };
    ".config/autostart"                                                    = { recursive = true; source = .config/autostart; };
    ".config/alacritty"                                                    = { recursive = true; source = .config/alacritty; };
    ".config/kitty"                                                        = { recursive = true; source = .config/kitty; };
    ".config/hypr"                                                         = { recursive = true; source = .config/hypr; };
    ".config/waybar"                                                       = { recursive = true; source = .config/waybar; };
    ".config/swaylock"                                                     = { recursive = true; source = .config/swaylock; };
    ".config/awesome"                                                      = { recursive = true; source = .config/awesome; };
    # ".config/fontconfig"                                                   = { recursive = true; source = .config/fontconfig; };
    ".config/ranger"                                                       = { recursive = true; source = .config/ranger; };
    ".config/rofi"                                                         = { recursive = true; source = .config/rofi; };
    ".config/systemd/user"                                                 = { recursive = true; source = .config/systemd/user; };
    ".config/mimeapps.list".source                                         = .config/mimeapps.list;
    ".config/picom.conf".source                                            = .config/picom.conf;
    ".config/cava/config".source                                           = .config/cava/config;

  };
}
