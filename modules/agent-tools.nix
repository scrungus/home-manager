{ pkgs, ... }:
{
  home.file.".codex/AGENTS.md".source = ../agent-config/AGENTS.md;
  home.file.".agents/skills" = {
    source = ../agent-config/skills;
    recursive = true;
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "zellij-share";
      runtimeInputs = [ pkgs.zellij ];
      text = builtins.readFile ../agent-config/zellij-share.sh;
    })
  ];
}
