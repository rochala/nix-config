{ config, lib, ... }:

let
  inherit (lib) mkIf;
  mkIfCaskPresent = cask: mkIf (lib.any (x: x == cask) config.homebrew.casks);
in {
  environment.shellInit = ''eval "$(${config.homebrew.brewPrefix}/brew shellenv)'';

  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-versions"
  ];

  homebrew.casks = [
    "alacritty"
    "alfred"
    "discord-ptb"
    "firefox"
    "slack"
    "spotify"
    "tutanota"
    "vlc"
    "signal"
    "steam"
    "karabiner-elements"
    "flux"
    "visual-studio-code"
  ];

}

