{ vimPlugins }:

{
  enable = true;
  viAlias = true;
  vimAlias = true;

  extraConfig = (builtins.readFile ./config/.vimrc);

  # Neovim plugins
  plugins = with vimPlugins; [
    ctrlp
    editorconfig-vim
    gruvbox
    nerdtree
    nvim-tree-lua
    tabular
    vim-nix
    vim-sensible
  ];
}
