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
    python
    python2
    wget
    git
    unstable.lua-language-server
    ripgrep
    rnix-lsp
    gh
    docker
    colima
    languagetool
  ];

in homePackages
