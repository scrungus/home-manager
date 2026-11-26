{ config, ... }:
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
    shellAliases.c = "codex -c tui.notifications=true -c 'tui.notification_condition=\"unfocused\"' -c 'tui.notification_method=\"osc9\"'";
  };

  xdg.configFile."git/ignore".text = ''
    **/.claude/settings.local.json
  '';
}
