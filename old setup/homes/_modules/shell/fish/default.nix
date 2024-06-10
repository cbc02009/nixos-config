{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (config.home) username homeDirectory;
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable = lib.mkEnableOption "fish";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.fish = {
        enable = true;

        plugins = [
          { name = "done"; src = pkgs.fishPlugins.done.src; }
          { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
        ];

        shellAbbrs = {
          cpr = "cp -rf";
          rmr = "rm -rf";
          md = "mkdir -p";
          rd = "rmdir";

          # nh
          nos = "git -C $FLAKE pull; nh os switch";

          # eza
          lsa = "eza -lag --git --icons --sort=type";
          l = "eza -lag --git -icons --sort=type";
          ll = "eza -l --git --icons --sort=type";
          la = "eza -lag --git --icons --sort=type";

          # the fuck
          fu = "fuck";

          # hwatch
          w = "hwatch";
        };

        shellInit = ''
          # Disable fish greeting
          set -g fish_greeting

          # Environment variables
          set -gx EDITOR nano
          set -gx VISUAL nano

        '';

        interactiveShellInit = ''
          function remove_path
            if set -l index (contains -i $argv[1] $PATH)
              set --erase --universal fish_user_paths[$index]
            end
          end

          function update_path
            if test -d $argv[1]
              fish_add_path -m $argv[1]
            else
              remove_path $argv[1]
            end
          end

          # Paths are in reverse priority order
          update_path /opt/homebrew/bin
          update_path ${homeDirectory}/.krew/bin
          update_path /nix/var/nix/profiles/default/bin
          update_path /run/current-system/sw/bin
          update_path /etc/profiles/per-user/${username}/bin
          update_path /run/wrappers/bin
          update_path ${homeDirectory}/.nix-profile/bin
          update_path ${homeDirectory}/go/bin
          update_path ${homeDirectory}/.cargo/bin
          update_path ${homeDirectory}/.local/bin
        '';
      };

      home.sessionVariables.fish_greeting = "";

      programs.nix-index.enable = true;
    })
  ];
}
