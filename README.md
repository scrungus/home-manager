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

Keep the existing `c` alias and use Claude Code 2.1.295 or newer for native
status reporting. Use Zellij's tabs for the per-agent status badge in any
terminal. The shared configuration translates desktop notification sequences
from panes into a terminal bell. An agent status marker by itself does not
guarantee a bell. Enable the bell on the active Apple Terminal or GNOME
Terminal profile.

## Check alerts

1. In the outer terminal, run `sleep 3; printf '\a'` and switch tabs or apps.
   This checks the terminal's audible bell separately from Zellij.
2. Open two tabs in Zellij and run `c` in one. Check that a turn completing
   and a request for input each appear on the right Zellij tab.
3. Repeat while watching the pane, on another tab, and in another app. The
   Codex alias requests notifications when unfocused. Verify sound and focus
   handling on each terminal, especially for Claude and the outer tab.
4. From a Zellij pane on Ubuntu, connect to VFOSv5 as usual and check Backspace.
   If it behaves differently, compare `TERM`, `stty -a`, and
   `infocmp "$TERM"` with a session opened directly from GNOME Terminal.
