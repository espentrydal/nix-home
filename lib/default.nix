{ pkgs }:

let
  inherit (pkgs.lib) optionals;
in
{
  getHomeDirectory = username: "/home/${username}";
}
