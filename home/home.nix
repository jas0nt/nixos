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
        home.stateVersion = "23.05";
        home.packages = [
            pkgs.emacs
            pkgs.vscode
            pkgs.alacritty
            pkgs.wpsoffice
            pkgs.steam
            pkgs.qq
            pkgs.spotify
            pkgs.playerctl
            pkgs.vlc
            pkgs.rofi
            pkgs.pasystray
            pkgs.pulsemixer
            pkgs.python3
        ];

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

        home.file = {
            ".config/alacritty"     = { recursive = true; source = .config/alacritty; };
            ".config/awesome"       = { recursive = true; source = .config/awesome; };
            ".config/fish"          = { recursive = true; source = .config/fish; };
            ".config/fontconfig"    = { recursive = true; source = .config/fontconfig; };
            ".config/ranger"        = { recursive = true; source = .config/ranger; };
            ".config/rofi"          = { recursive = true; source = .config/rofi; };
            ".config/systemd"       = { recursive = true; source = .config/systemd; };

            ".config/picom.conf".source = .config/picom.conf;
            ".local/share/fcitx5/rime/default.custom.yaml".source = rime/default.custom.yaml;
            ".local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml".source = rime/double_pinyin_flypy.schema.yaml;
        };

    };
}
