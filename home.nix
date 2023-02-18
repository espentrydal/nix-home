{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "espen";
  home.homeDirectory = "/home/espen";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # For non-NixOS
  targets.genericLinux.enable = true;

  home.file = {
    ".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      rev = "v3.0.0";
      sha256 = "18q5j92fzmxwg8g9mzgdi5klfzcz0z01gr8q2y9hi4h4n864r059";
    };
  };

  imports = [
    ./home-packages.nix
    ./x11/alacritty.nix
    ./x11/i3.nix
    ./x11/polybar.nix
  ];

  home.sessionVariables = {
    EDITOR="nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  pam.sessionVariables = config.home.sessionVariables // {
    LANGUAGE	="en_US:en";
    LANG	="en_US.UTF-8";
  };


  # Programs
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm ];
    extraConfig = ''
          (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8"
                                            "-cp" "${pkgs.languagetool}/share/")
                languagetool-java-bin "${pkgs.jdk}/bin/java"
                languagetool-console-command "${pkgs.languagetool}/share/languagetool-commandline.jar"
                languagetool-server-command "${pkgs.languagetool}/share/languagetool-server.jar")
      '';
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
        set nocompatible            " disable compatibility to old-time vi
        set showmatch               " show matching
        set hlsearch                " highlight search
        set incsearch               " incremental search
        set tabstop=4               " number of columns occupied by a tab
        set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
        set expandtab               " converts tabs to white space
        set shiftwidth=4            " width for autoindents
        set autoindent              " indent a new line the same amount as the line just typed
        set number                  " add line numbers
        set wildmode=longest,list   " get bash-like tab completions
        "set cc=80                   " set an 80 column border for good coding style
        filetype plugin indent on   " allow auto-indenting depending on file type
        syntax on                   " syntax highlighting
        set clipboard=unnamedplus   " using system clipboard
        filetype plugin on
        set ttyfast                 " Speed up scrolling in Vim
        if &diff
          colorscheme blue
        endif
      '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-sensible
      nvim-tree-lua
      {
        plugin = pkgs.vimPlugins.vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    enable = true;
    userName = "Espen Trydal";
    userEmail = "espen@trydal.io";
    extraConfig = {
      credential.helper = "gpg";
      init.defaultBranch = "main";
    };
  };
  programs.gpg = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    profileExtra =''
      export XDG_DATA_DIRS="''$HOME/.nix-profile/share:''$XDG_DATA_DIRS"
    '';
    initExtra = ''
      if [[ "''$INSIDE_EMACS" = 'vterm' ]]; then
          alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
      fi

      vterm_printf() {
          if [ -n "''$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ]); then
              # Tell tmux to pass the escape sequences through
              printf "''\\ePtmux;''\\e''\\e]%s''\\007''\\e''\\''\\" "''$1"
          elif [ "''${TERM%%-*}" = "screen" ]; then
              # GNU screen (screen, screen-256color, screen-256color-bce)
              printf "''\\eP''\\e]%s''\\007''\\e''\\''\\" "''$1"
          else
              printf "''\\e]%s''\\e''\\''\\" "''$1"
          fi
      }

      vterm_prompt_end() {
          vterm_printf "51;A''$(whoami)@''$(hostname):''$(pwd)"
      }
      setopt PROMPT_SUBST
      PROMPT=''$PROMPT'%{''$(vterm_prompt_end)%}'

      '';
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
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
    shellAliases = {
      l = "ls -la";
      la = "ls -a";
      ll = "ls -l";
      e = "emacsclient -nw";
      tsf = "tailscale file";
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
      export XDG_DATA_DIRS="''$HOME/.nix-profile/share:''$XDG_DATA_DIRS";
    '';
    bashrcExtra = ''
      if [[ "''$INSIDE_EMACS" = 'vterm' ]]; then
          function clear() {
              vterm_printf "51;Evterm-clear-scrollback";
              tput clear;
          }
      fi

      vterm_printf() {
          if [ -n "''$TMUX" ] && ([ "''${TERM%%-*}" = "tmux" ] || [ "''${TERM%%-*}" = "screen" ]); then
              # Tell tmux to pass the escape sequences through
              printf "''\\ePtmux;''\\e''\\e]%s''\\007''\\e''\\''\\" "''$1"
          elif [ "''${TERM%%-*}" = "screen" ]; then
              # GNU screen (screen, screen-256color, screen-256color-bce)
              printf "''\\eP''\\e]%s''\\007''\\e''\\''\\" "''$1"
          else
              printf "''\\e]%s''\\e''\\''\\" "''$1"
          fi
      }

      vterm_prompt_end() {
          vterm_printf "51;A''$(whoami)@''$(hostname):''$(pwd)"
      }
      PS1=''$PS1''\'''\\''\[''$(vterm_prompt_end)''\\]''\'

      '';

    shellAliases = {
      l = "ls -la";
      la = "ls -a";
      ll = "ls -l";
      e = "emacsclient -nw";
      tsf = "tailscale file";
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    tmux.enableShellIntegration = true;
  };
  programs.tmux = {
    enable = true;
    shortcut = "b";
    plugins = with pkgs.tmuxPlugins ; [
      continuum
      cpu
      net-speed
      nord
      sensible
      tmux-fzf
    ];
    newSession = true;
    clock24 = true;
    extraConfig =
      ''
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'MunifTanjim/tmux-suspend'
      set -g @plugin 'MunifTanjim/tmux-mode-indicator'

      set -g @continuum-boot 'on'
      set -g @continuum-restore 'on'
      set -g status-right '%Y-%m-%d %H:%M #{tmux_mode_indicator}'

      # Initialize TMUX plugin manager (at the very bottom of tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'
      '';
  };

  # Services
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableSshSupport = true;
    defaultCacheTtl = 3600*3;
    defaultCacheTtlSsh = 3600*3;
  };

  # Extra
  fonts.fontconfig.enable = true;

  # Graphical applications
  xdg = {
    enable = true;
  };
  xsession = {
    enable = true;
    numlock.enable = true;
  };
  programs.keychain.enableXsessionIntegration = true;

  programs.autorandr.enable = true;
  
  programs.rofi = {
    enable = true;
  };

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open terminal";
      command = "alacritty";
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = "<Shift><Super>l";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
    };

    "org/gnome/calculator" = {
      button-mode = "programming";
      show-thousands = true;
      base = 10;
      word-size = 64;
      window-position = lib.hm.gvariant.mkTuple [100 100];
    };
  };

}

