{ config, lib, pkgs, ... }:
let
  codexSound = pkgs.writeShellApplication {
    name = "codex-sound";
    runtimeInputs = [ pkgs.jq pkgs.zellij ];
    text = builtins.readFile ./config/codex-sound.sh;
  };
  notifyOverride = lib.escapeShellArg (builtins.toJSON [ "${codexSound}/bin/codex-sound" ]);
in
{
  home = {
    username = "tyler";
    homeDirectory = "/Users/tyler";
    stateVersion = "26.05";
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];
  };

  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    shellAliases.c = "_codex_with_sound";
    shellAliases.np = "_apply_home_manager";
    initContent = ''
      _apply_home_manager() {
        command home-manager --extra-experimental-features 'nix-command flakes' switch \
          --flake "$HOME/Documents/code/home-manager#mac" "$@" || return

        local log_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/home-manager"
        mkdir -p -- "$log_dir" || return

        # The restart must survive the shell if np was run inside Zellij.
        command nohup /bin/sh -c '
          zellij kill-all-sessions --yes
          unset ZELLIJ ZELLIJ_PANE_ID ZELLIJ_SESSION_NAME
          exec zellij terminal
        ' </dev/null >"$log_dir/zellij-restart.log" 2>&1 &!
      }

      _codex_with_sound() {
        local -a notification_args
        notification_args=(-c 'tui.notification_condition="unfocused"' -c 'tui.notification_method="bel"')
        if [[ -n ''${ZELLIJ_PANE_ID-} ]]; then
          notification_args+=(-c 'tui.notifications=["approval-requested"]' -c notify=${notifyOverride})
        else
          notification_args+=(-c tui.notifications=true)
        fi
        command codex "''${notification_args[@]}" "$@"
      }
    '';
  };

  xdg.configFile."git/ignore".text = ''
    **/.claude/settings.local.json
  '';
}
