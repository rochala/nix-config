{ pkgs, ... }:
{
  enable = true;
  package = pkgs.unstable.neovim-unwrapped;
  /* extraConfig = "lua require('init')"; */
}
