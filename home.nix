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
    initContent = ''
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
    shellAliases.np = "home-manager --extra-experimental-features 'nix-command flakes' switch --flake \"$HOME/Documents/code/home-manager#mac\"";
  };

  xdg.configFile."git/ignore".text = ''
    **/.claude/settings.local.json
  '';
}
