{ homeDirectory
, pkgs
}:

{
  # Fancy replacement for cat
  bat.enable = true;

  # Navigate directory trees
  broot = {
    enable = true;
    enableZshIntegration = true;
  };

  # Easy shell environments
  direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    stdlib = ''
      use_riff() {
        watch_file Cargo.toml Cargo.lock
        eval "$(riff print-dev-env)"
      }
    '';
  };

  # Emacs
  emacs = {
    enable = true;
    package = pkgs.emacs-nox;
    extraPackages = epkgs: [ epkgs.vterm ];
    extraConfig = ''
          (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8"
                                            "-cp" "${pkgs.languagetool}/share/")
                languagetool-java-bin "${pkgs.jdk}/bin/java"
                languagetool-console-command "${pkgs.languagetool}/share/languagetool-commandline.jar"
                languagetool-server-command "${pkgs.languagetool}/share/languagetool-server.jar")
      '';
  };

  # Replacement for ls
  exa = {
    enable = true;
    enableAliases = true;
  };

  # Fish shell
  fish = import ./fish.nix { inherit homeDirectory pkgs; };

  # Fuzzy finder
  fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  # The GitHub CLI
  gh = {
    enable = true;
    settings = {
      editor = "vim";
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  # But of course
  git = import ./git.nix { inherit homeDirectory pkgs; };

  # GPG config
  gpg.enable = false; # doesn't work with pinentry

  # Configure HM itself
  home-manager = {
    enable = true;
  };

  # JSON parsing on the CLI
  jq.enable = true;

  # For Git rebases and such
  neovim = import ./neovim.nix {
    inherit (pkgs) vimPlugins;
  };

  # Speed up nix search functionality
  nix-index ={
    enable = true;
    enableZshIntegration = true;
  };

  # Experimental shell
  #nushell = import ./nushell.nix { inherit pkgs; };

  # Document conversion
  # pandoc = {
  #   enable = true;
  #   defaults = { metadata = { author = "Espen Trydal "; }; };
  # };

  # The provider of my shell aesthetic
  #starship = import ./starship.nix;

  # My most-used multiplexer
  tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    newSession = true;
    shortcut = "b";
    extraConfig = (builtins.readFile ./config/tmux.conf);

    plugins = with pkgs.tmuxPlugins; [
      continuum
      cpu
      net-speed
      nord
      sensible
      tmux-fzf
    ];
  };

  # VSCode
  #vscode = import ./vscode.nix { inherit pkgs; };

  # My fav shell
  zsh = import ./zsh.nix {
    inherit homeDirectory;
    inherit (pkgs) substituteAll;
    inherit (pkgs) fetchFromGitHub;
  };

}

