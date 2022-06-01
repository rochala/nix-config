{ pkgs, config, ... }:

{
  imports = [ ./bloop.nix ];

  home.packages = with pkgs; [
    jdk
    scala
    ammonite
    scalafmt
    coursier
    sbt
  ];

  home.sessionVariables = {
    JVM_DEBUG = "-J-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005";
  };

  programs.java.enable = true;
}
