# Home Manager

Shared Zellij, Kitty and Neovim setup for the Mac and the Ubuntu workstation.
Run Zellij on the workstation and launch `c` there. The work config owns the
Claude alias and any private SSH configuration.

## Mac

With Nix installed, build the standalone profile first:

```sh
nix flake lock
nix build .#homeConfigurations.mac.activationPackage
```

When ready, back up the existing Zsh and Kitty files during activation:

```sh
nix run github:nix-community/home-manager -- -b before-home-manager switch --flake .#mac
```

Open a fresh shell and check that `zellij --version` reports 0.46 or later.
Kitty is optional and its existing app can read the managed profile. Kitty
uses the macOS Glass sound on the Mac and the system bell on Linux.

Run `hx` to open Helix with Catppuccin Frappé. After activation, run `np`
from any directory to apply changes to this Mac profile. On success, `np`
stops all running Zellij sessions without prompting and opens a fresh Zellij
window. Save work in those panes first. If an older shell doesn't know
`np`, open a fresh tab or run `exec zsh -l`.

Neovim reads the existing writable checkout at `~/.config/nvim`. On a new
machine, clone it once if that directory is empty or absent:

```sh
git clone https://github.com/scrungus/kickstart.nvim.git ~/.config/nvim
```

Run `git -C ~/.config/nvim pull --ff-only` to update to the tip of the branch.

## Work integration

Add this repository as a flake input in the private work repo, or use a
local path input while trying it out. Add
`shared.homeManagerModules.terminal` and `shared.homeManagerModules.editor`
to the existing Home Manager module list, where `shared` is the input name.
Use a Nixpkgs revision with Zellij 0.46 or later. Resolve any existing
declarations of the same Kitty or Zellij files before switching.

Run `zellij terminal` on the local desktop to open Zellij in its own window.
This uses the shared Frappé palette and top tab bar on macOS and Ubuntu.
The Ubuntu package needs the native terminal feature and a desktop session
with X11 or Wayland.

Press `Ctrl+T`, then `H` or `L` to switch tabs. Open a new tab in the
focused shell's directory with `Ctrl+T`, then `N`, or open a desktop window
in that directory with `Ctrl+T`, then `W`. The shared Zsh config reports
the local directory to Zellij at each prompt.

Keep the existing `c` alias and use Claude Code 2.1.295 or newer for native
status reporting. Use Zellij's tabs for the per-agent status badge in any
terminal. The shared configuration translates desktop notification sequences
from panes into a terminal bell. An agent status marker by itself does not
guarantee a bell. Enable the bell on the active Apple Terminal or GNOME
Terminal profile if using one of those emulators. In Zellij's own terminal,
the bell is audible and desktop notifications are disabled.

## Check alerts

1. In the outer terminal, run `sleep 3; printf '\a'` and switch tabs or apps.
   This checks the terminal's audible bell separately from Zellij.
2. Open two tabs in Zellij and run `c` in one. Check that a turn completing
   and a request for input each appear on the right Zellij tab.
3. Repeat while watching the pane, on another tab, and in another app. On Mac,
   `c` inside Zellij plays Glass directly for Codex turn completions when
   the pane is out of view. Codex approval prompts use the terminal bell.
   Verify Claude sound and focus handling on Ubuntu separately.
4. From a Zellij pane on Ubuntu, connect to VFOSv5 as usual and check Backspace.
   If it behaves differently, compare `TERM`, `stty -a`, and
   `infocmp "$TERM"` with a session opened directly from GNOME Terminal.

## Reset Zellij sessions

Save any work in the panes, then quit Zellij.app. From Apple Terminal,
run these in order to stop the running sessions, clear saved sessions, and
verify the list before reopening Zellij:

```sh
zellij kill-all-sessions
zellij delete-all-sessions
zellij list-sessions
```

This clears sessions and keeps the Home Manager settings.
