{
  description = "Shared terminal and editor setup for home and work";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeManagerModules = {
      agent-tools = ./modules/agent-tools.nix;
      terminal = ./modules/terminal.nix;
      editor = ./modules/editor.nix;
    };

    homeConfigurations.mac = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        ./modules/agent-tools.nix
        ./modules/terminal.nix
        ./modules/editor.nix
        ./home.nix
      ];
    };
  };
}
