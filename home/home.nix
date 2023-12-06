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
        extraGroups = [ "networkmanager" "wheel" ];
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
                    corner_radius = 10;
                    width = 300;
                    height = 300;
                    offset = "10x50";
                    origin = "top-right";
                    transparency = 50;
                    frame_color = "#bd93f9";
                    font = "Noto Sans CJK 20";
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
            name = "Bibata-Modern-Classic";
            size = 16;
        };

        gtk = {
            enable = true;
            cursorTheme = {
                package = pkgs.bibata-cursors;
                name = "Bibata-Modern-Classic";
                size = 16;
            };
            iconTheme = {
                package = pkgs.beauty-line-icon-theme;
                name = "BeautyLine";
            };
        };

        home.packages = [
            pkgs.pasystray
            pkgs.pulsemixer

            pkgs.emacs
            pkgs.vscode
            pkgs.alacritty
            pkgs.tig
            pkgs.tree
            (pkgs.python3.withPackages (ps: with ps; [
                pip virtualenv
            ]))

            pkgs.wpsoffice
            pkgs.steam
            pkgs.qq
            pkgs.spotify
            pkgs.playerctl
            pkgs.mpv
            pkgs.vlc
            pkgs.feh
            pkgs.qbittorrent
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
            ".config/awesome"       = { recursive = true; source = .config/awesome; };
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
