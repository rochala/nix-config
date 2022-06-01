{ pkgs }:

let

  homePackages = with pkgs; [
    tmux
    zsh-powerlevel10k
    pass
    passExtensions.pass-otp
    wget
    git
    ripgrep
    sumneko-lua-language-server
  ];
in homePackages
