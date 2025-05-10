{ config, pkgs, ...}:
let
  discord = pkgs.discord.override { withVencord = true; };
in
{
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
    brightnessctl
    hypridle
    obsidian
    grim
    slurp
    prismlauncher
    tailscale
    libinput-gestures
    nixd
    ssh-to-age
    sops
  ];
  programs.vscode = {
    enable = true;
  };
  
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      global.hide_env_diff = true;
    };
  };
  programs.bash.enable = true;
  programs.hyprlock.enable = true;
  /*programs.hyprlock.settings = {
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
        text = "Welcome";
        color = "$text";
        position = "0, 50";
        halign = "center";
        valign = "center";
      }
    ];
  };*/

  gtk.iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.catppuccin-papirus-folders.override {
      flavor = "macchiato";
      accent = "blue";
    };
  };

  catppuccin.enable = true;
  catppuccin.cursors.enable = true;
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.size = 24;
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      exec-once = [
        "hypridle"
        "hyprctl setcursor 24"
        "discord"
        "libinput-gestures"
      ];
      "$mod" = "SUPER";

      bind = [
        # Program Keybinds Here
        "$mod, F, exec, nvidia-offload firefox"
        "$mod, E, exec, alacritty"
        "$mod, L, exec, (pidof my-shell && pkill -USR1 my-shell) || hyprlock"
      ]
      ++ (
        # Numbered Workspace Keybinds
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      )
      ++ [
        # Other Workspace Keybinds
        "$mod, D, workspace, name:Discord"
        "$mod, Left, workspace, m-1"
        "$mod, Right, workspace, m+1"
      ]
      ++ [
        # "System Keybinds"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ", XF86ScreenSaver, exec, hyprctl dispatch dpms toggle"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "$mod, c, killactive"
        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy "
      ];
      bindm = "$mod, mouse:272, movewindow";
      binds.workspace_back_and_forth = true;
      bindr = "SUPER, SPACE, global, :ToggleLauncher";
      monitor = ", preferred, auto, 1";
      general.resize_on_border = true;
      input.touchpad.scroll_factor = .4;
      input.touchpad.disable_while_typing = false;
      gestures.workspace_swipe = false;
      gestures.workspace_swipe_create_new = false;
      misc = {
        focus_on_activate = true;
        middle_click_paste = false;
      };
      windowrule = ["workspace name:Discord silent, class:discord"];
      layerrule = [
        "dimaround, my-shell-launcher"
        "blur, my-shell-launcher"
      ];
    };
  };

  # Libinput-gestures config

  home.file.".config/libinput-gestures.conf".text = ''
    gesture swipe left 3 hyprctl dispatch workspace m+1
    gesture swipe right 3 hyprctl dispatch workspace m-1
  '';

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "(pidof my-shell && pkill -USR1 my-shell) || (pidof hyprlock || hyprlock)";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  services.udiskie.enable = true;

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

  gtk.enable = true;

  services.mpris-proxy.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
