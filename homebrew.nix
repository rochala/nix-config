{ config, lib, ... }:

let
  inherit (lib) mkIf;
  mkIfCaskPresent = cask: mkIf (lib.any (x: x == cask) config.homebrew.casks);
in {
  environment.shellInit = ''eval "$(${config.homebrew.brewPrefix}/brew shellenv)'';

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    global.lockfiles = false;
    onActivation.upgrade = true;

    taps = [
      "homebrew/cask"
      "homebrew/cask-versions"
    ];

    brews = [
      "openjdk@17"
      "ltex-ls"
    ];

    casks = [
      "alacritty"
      "alfred"
      "temurin8"
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
      "qbittorrent"
      "firefox-developer-edition"
      "obsidian"
      "figma"
      "intellij-idea-ce"
      "google-chrome"
      "element"
      "nvidia-geforce-now"
      "visualvm"
    ];
  };

}

