{ pkgs, ... }:


let
  unstable = pkgs.unstable;

  homePackages = with pkgs; [
    tmux
    zsh-powerlevel10k
    pass
    gnupg
    openssl
    pinentry-curses
    passExtensions.pass-otp
    tree
    youtube-dl
    wget
    git
    unstable.lua-language-server
    ripgrep
    rnix-lsp
    gh
    docker
    colima
    languagetool
    nodejs_18
    rustup
  ];

in homePackages
