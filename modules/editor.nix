{ pkgs, ... }:
{
  home.packages = [ pkgs.neovim ];
  programs.helix = {
    enable = true;
    settings.theme = "catppuccin_frappe";
  };
  programs.zsh.shellAliases.vi = "nvim";
  home.sessionVariables.EDITOR = "nvim";

  # The checkout at ~/.config/nvim stays writable and tracks its own Git branch.
}
