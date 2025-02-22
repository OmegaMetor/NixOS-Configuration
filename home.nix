{ config, pkgs, ...}:
let
  discord = pkgs.discord.override { withVencord = true; };
in
{
  imports = [
    <catppuccin/modules/home-manager>
  ];
  home.username = "mattie";
  home.homeDirectory = "/home/mattie";

  home.packages = with pkgs; [
    wl-clipboard
    mako
    wofi
    waybar
    firefox
    git
    discord
    hyprcursor
    alacritty
  ];
  programs.bash.enable = true;
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    background = {
      path = "screenshot";
      blur_passes = 3;
      blur_size = 8;
    };
    input-field = {
      size = "200, 50";
      position = "0, -50";
      monitor = "";
      dots_center = true;
      placeholder_text = "Enter Password";
      fade_on_empty = true;
      fail_color = "$red";
      check_color = "$yellow";
      inner_color = "$base";
      outer_color = "$overlay0";
      font_color = "$text";
    };
    label = [
      {
        monitor = "";
        text = "$TIME";
        color = "$text";
        halign = "center";
        valign = "center";
        position = "0, 0";
      }
      {
        monitor = "";
        text = "Welcome Back";
        color = "$text";
        position = "0, 50";
        halign = "center";
        valign = "center";
      }
    ];
  };

  catppuccin.enable = true;
  catppuccin.cursors.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {     
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
        "$mod, E, exec, alacritty"
        "$mod, L, exec, hyprlock"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
      binds.workspace_back_and_forth = true;
      monitor = ", preferred, auto, 1";
      general.resize_on_border = true;
      input.touchpad.scroll_factor = .2;
      gestures.workspace_swipe = true;
      gestures.workspace_swipe_create_new = false;
      
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      window = {
        decorations = "full";
        title = "Alacritty";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };
      font = {
        normal = {
          family = "JetBrains Mono";
          style = "regular";
        };
        size = 15.00;
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  services.mpris-proxy.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
