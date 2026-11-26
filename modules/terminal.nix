{ lib, pkgs, ... }:
let
  newZellijWindow = pkgs.writeShellScriptBin "zellij-new-window" (
    lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      for app in "$HOME/Applications/Zellij.app" /Applications/Zellij.app; do
        if [ -d "$app" ]; then
          # Give Zellij time to create the window before asking macOS to focus it.
          (
            /bin/sleep 0.5
            /usr/bin/open -a "$app"
          ) &
          break
        fi
      done
    ''
    + ''
      exec ${pkgs.zellij}/bin/zellij terminal --working-directory "$PWD"
    ''
  );
in
{
  home.packages = [ pkgs.zellij newZellijWindow ];

  assertions = [{
    assertion = lib.versionAtLeast pkgs.zellij.version "0.46.0";
    message = "The shared terminal module needs Zellij 0.46 or newer for agent tab markers.";
  }];

  xdg.configFile."zellij/config.kdl".text = builtins.readFile ../config/zellij.kdl
    + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      copy_command "/usr/bin/pbcopy"
      copy_on_select true
    '';
  programs.zsh.initContent = builtins.readFile ../config/zellij-cwd.zsh;

  # Manage the profile even on machines that use a different terminal app.
  xdg.configFile."kitty/kitty.conf".text = builtins.readFile ../config/kitty.conf
    + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      bell_path /System/Library/Sounds/Glass.aiff
    '';
}
