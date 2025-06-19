{ pkgs, lib, ... }:
{

  environment.shells = with pkgs; [
    zsh
  ];

  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  programs.zsh.enable = true;

  nix = {
    package = pkgs.nixVersions.stable;
    settings.trusted-users = [ "@admin" ];
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

  };

  users.users.jrochala.home = "/Users/jrochala";

  ids.uids.nixbld = 300;

  system.primaryUser = "jrochala";
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark"; # Dark mode
      ApplePressAndHoldEnabled = false; # No accents
      KeyRepeat = 1; # I am speed
      InitialKeyRepeat = 15;
      AppleKeyboardUIMode = 3; # full control
      NSAutomaticQuoteSubstitutionEnabled = false; # No smart quotes
      NSAutomaticDashSubstitutionEnabled = false; # No em dash
      NSNavPanelExpandedStateForSaveMode = true; # Default to expanded "save" windows
      NSNavPanelExpandedStateForSaveMode2 = true; # don't ask
    };
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 30;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      _FXShowPosixPathInTitle = true;
    };
    trackpad.Clicking = false;
    loginwindow.GuestEnabled = false;
  };
 
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.stateVersion = 4;
}
