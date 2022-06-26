{ config, pkgs, lib, ... }:

let
  externalPackages = import ./packages.nix { inherit pkgs; };
  allPackages = externalPackages;
in {
  home.stateVersion = "22.05";

  programs = {
    alacritty = import ./programs/alacritty/alacritty.nix;
    neovim = import ./programs/nvim/neovim.nix;
    zsh = import ./programs/zsh/zsh.nix { inherit pkgs; };

    fzf.enable = true;
    htop.enable = true;
    jq.enable = true;
    gpg.enable = true;
    bat.enable = true;
  };

  imports = [
    ./scala
  ];

  xdg.configFile."./nvim/lua".source = ./programs/nvim/lua;
  xdg.configFile."./nvim/plugin".source = ./programs/nvim/plugin;
  xdg.configFile."./tmux/tmux.conf".source = ./programs/tmux/tmux.conf;

  home = {
    username = "jrochala";
    packages = allPackages;
    sessionVariables = {
      LANG = "en_US.UTF-8";
      EDITOR = "nvim";
      TERMINAL = "alacritty";
      SHELL = "/Users/jrochala/.nix-profile/bin/zsh";
    };
    file = {
      "./karabiner/karabiner.json" = { source = ./programs/karabiner/karabiner.json; };
    };
  };
}


