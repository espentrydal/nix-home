{ homeDirectory }:

{
  shell = {
    # General
    # l = "ls -la";
    # la = "ls -a";
    # ll = "ls -l";
    e = "emacsclient -nw";

    "," = "comma";
    diff = "diff --color=auto";
    grep = "grep --color=auto";
    less = "less -R";

    ## Nix stuff. Inspired by: https://alexfedoseev.com/blog/post/nix-time.

    # Reload the Home Manager configuration (after git push)
    xx =
      "home-manager switch --flake github:espentrydal/nix-home/minimal && source ${homeDirectory}/.zshrc";

    # Run Nix garbage collection
    xgc = "nix-env --delete-generations old && nix-store --gc";

    # Nix flake helpers
    nfs = "nix flake show";
    nfu = "nix flake update";
  };
}
