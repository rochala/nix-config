{ pkgs, ... }:
{
  enable = true;
  autocd = true;
  autosuggestion.enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;
  historySubstringSearch.enable = true;
  defaultKeymap = "viins";
  shellAliases = {
    la = "ls -la";
    ".." = "cd ..";
  };

  history = {
    size = 100000;
  };

  localVariables = {
    COMPLETION_WAITING_DOTS = "true";
    ZSH_HIGHLIGHT_MAXLENGTH = "50";
    HYPHEN_INSENSITIVE = "true";
  };

  initContent = let
    zshInitExtraBeforeCompInit = pkgs.lib.mkOrder 550 "
      zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' list-colors ''
      zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'
      zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
      zstyle ':completion:*:descriptions' format %F{default}%B%{$__WINCENT[ITALIC_ON]%}--- %d ---%{$__WINCENT[ITALIC_OFF]%}%b%f
      zstyle ':completion:*' menu select

      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
    ";

    zshConfig = pkgs.lib.mkOrder 1000 ''
      alias nvim-test="export XDG_CONFIG_HOME=~/.config/nix-config/programs; nvim; unset XDG_CONFIG_HOME"
      export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
      export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
      export PATH="$PATH:/Users/jrochala/Library/Application Support/Coursier/bin"
      export PATH="/opt/homebrew/opt/node@14/bin:$PATH"
      export PATH=~/.npm-packages/bin:$PATH
      export NODE_PATH=~/.npm-packages/lib/node_modules
      GPG_TTY=$(tty)
      export GPG_TTY

      # bindkey '^[[A' history-substring-search-up
      # bindkey '^[[B' history-substring-search-down

      source ~/.ghcup/env
    '';
  in
    pkgs.lib.mkMerge [ zshInitExtraBeforeCompInit zshConfig ];

}
