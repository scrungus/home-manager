{ pkgs, ... }:
{
  home.packages = [ pkgs.neovim ];
  programs.zsh.shellAliases.vi = "nvim";
  home.sessionVariables.EDITOR = "nvim";

  # The checkout at ~/.config/nvim stays writable and tracks its own Git branch.
}
