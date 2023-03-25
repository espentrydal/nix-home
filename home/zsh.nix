{ homeDirectory
, substituteAll
, fetchFromGitHub
}:

{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  autocd = false;

  plugins = [
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.5.0";
        sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
      };
    }
  ];
  oh-my-zsh = {
    enable = true;
    plugins = [
      "fzf"
      "git"
      "python"
      "man"
      "z"
    ];
    theme = "agnoster";
  };

  shellAliases = (import ./aliases.nix { inherit homeDirectory; }).shell;

  profileExtra =''
      export XDG_DATA_DIRS="''$HOME/.nix-profile/share:''$XDG_DATA_DIRS"
    '';
  initExtra = (builtins.readFile ./scripts/init.sh);

}
