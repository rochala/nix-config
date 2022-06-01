{ pkgs, ... }:
{
  home.file.".bloop/bloop.json".text =
    builtins.toJSON {
      javaOptions = [
        "-Xmx8G"
        "-Xss10m"
        "-XX:+CrashOnOutOfMemoryError"
      ];
    };
}
