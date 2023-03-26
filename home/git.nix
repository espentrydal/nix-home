{ homeDirectory
, pkgs
}:

{
  enable = true;
  userName = "Espen Trydal";
  userEmail = "espen@trydal.io";
  #package = pkgs.gitAndTools.gitFull; # needs export GIT_SSH="/usr/bin/ssh" to work

  delta = { enable = true; };

  lfs = { enable = true; };

  ignores = [
    ".cache/"
    ".DS_Store"
    ".direnv/"
    ".idea/"
    "*.swp"
    "built-in-stubs.jar"
    "dumb.rdb"
    ".elixir_ls/"
    ".vscode/"
    "npm-debug.log"
  ];
  aliases = (import ./aliases.nix { inherit homeDirectory; }).git;

  extraConfig = {
    core = {
      editor = "nvim";
      whitespace = "trailing-space,space-before-tab";
    };

    commit.gpgsign = "true";
    gpg.program = "gpg";

    protocol.keybase.allow = "always";
    credential.helper = "cache --timeout=86400";
    pull.rebase = "false";
    init.defaultBranch = "main";

    user = { signingkey = "F4AC885BDDF438E59E36BD07E5642B7B3A2E441D"; };
  };
}
