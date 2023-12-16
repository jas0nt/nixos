{ config, pkgs, ... }:

{
    imports =
    [ 
        <home-manager/nixos>
    ];


    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.jason = {
        isNormalUser = true;
        description = "jason";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        shell = pkgs.fish;
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.jason = { pkgs, ... }: {
        home.stateVersion = "23.11";

        services.dunst = {
            enable = true;
            package = pkgs.dunst;
            settings = {
                global = {
                    icon_theme = "BeautyLine";
                    enable_recursive_icon_lookup = true;
                    corner_radius = 15;
                    width = 400;
                    height = 300;
                    offset = "10x20";
                    origin = "bottom-right";
                    gaps = true;
                    gap_size = 10;
                    transparency = 50;
                    frame_color = "#282a36";
                    separator_height = 1;
                    separator_color = "#282a36";
                    font = "Noto Sans CJK 20";
                    progress_bar = true;
                    progress_bar_height = 10;
                    progress_bar_frame_width = 1;
                    progress_bar_min_width = 150;
                    progress_bar_max_width = 300;
                };
                urgency_low = {
                    background = "#282a36";
                    foreground = "#6272a4";
                    timeout = 10;
                };
                urgency_normal = {
                    background = "#282a36";
                    foreground = "#bd93f9";
                    timeout = 10;
                };
                urgency_critical = {
                    background = "#ff5555";
                    foreground = "#f8f8f2";
                    frame_color = "#ff5555";
                    timeout = 10;
                };
            };
        };

        home.sessionVariables = {
            EDITOR = "vim";
            BROWSER = "firefox";
            TERMINAL = "alacritty";
        };
	
        home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Ice";
            size = 20;
        };

        gtk = {
            enable = true;
            cursorTheme = {
                package = pkgs.bibata-cursors;
                name = "Bibata-Modern-Ice";
                size = 20;
            };
            iconTheme = {
                package = pkgs.beauty-line-icon-theme;
                name = "BeautyLine";
            };
        };

        home.packages = [
            pkgs.pasystray
            pkgs.pulsemixer

            pkgs.emacs pkgs.librime pkgs.emacsPackages.rime
            pkgs.vscode
            pkgs.alacritty
            pkgs.tree
            pkgs.sway-launcher-desktop
            (pkgs.python3.withPackages (ps: with ps; [
                pip virtualenv
            ]))

            pkgs.wpsoffice
            pkgs.qq
            pkgs.spotify pkgs.cmus
            pkgs.playerctl
            pkgs.mpv
            pkgs.vlc
            pkgs.feh
            pkgs.qbittorrent
            pkgs.calcure
            pkgs.localsend
            pkgs.quickemu
        ];

        programs = {
            bat.enable = true;
            jq.enable = true;
        };

        programs.git = {
            enable = true;
            userName = "Jas0nT";
            userEmail = "taoeta@gmail.com";
        };

        programs.fish = {
            enable = true;
            shellAliases = {
                fuckGFW = "export http_proxy=http://127.0.0.1:7890; and export https_proxy=http://127.0.0.1:7890";
            };
        };
	
        programs.autojump = {
            enable = true;
            enableFishIntegration = true;
        };

        home.file = {
            ".config/alacritty"     = { recursive = true; source = .config/alacritty; };
            ".config/hypr"          = { recursive = true; source = .config/hypr; };
            ".config/waybar"        = { recursive = true; source = .config/waybar; };
            ".config/fish"          = { recursive = true; source = .config/fish; };
            ".config/fontconfig"    = { recursive = true; source = .config/fontconfig; };
            ".config/ranger"        = { recursive = true; source = .config/ranger; };
            ".config/rofi"          = { recursive = true; source = .config/rofi; };
            ".config/systemd"       = { recursive = true; source = .config/systemd; };

            #".xprofile".source = ./.xprofile;
            ".config/mimeapps.list".source = .config/mimeapps.list;
            ".config/picom.conf".source = .config/picom.conf;

            # fcitx5 & rime
            ".local/share/fcitx5/themes/transparent-green"                         = { recursive = true; source = .local/share/fcitx5/themes/transparent-green; };
            ".config/fcitx5/conf/classicui.conf".source                            = .config/fcitx5/conf/classicui.conf;
            ".local/share/fcitx5/rime/default.custom.yaml".source                  = .local/share/fcitx5/rime/default.custom.yaml;
            ".local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml".source      = .local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml;
        };

    };
}
