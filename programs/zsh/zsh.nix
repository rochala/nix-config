{ pkgs, ... }:
{
  enable = true;
  autocd = true;
  enableAutosuggestions= true;
  enableCompletion = true;
  enableSyntaxHighlighting = true;
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
    ZSH_HIGHLIGHT_MAXLENGTH = "20";
    HYPHEN_INSENSITIVE = "true";
  };

  initExtraBeforeCompInit = "
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

  initExtra = ''
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
  '';

  plugins = [
    {
      name = "zsh-history-substring-search";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-history-substring-search";
        rev = "v1.0.2";
        sha256 = "Ptxik1r6anlP7QTqsN1S2Tli5lyRibkgGlVlwWZRG3k=";
      };
    }
  ];

}
