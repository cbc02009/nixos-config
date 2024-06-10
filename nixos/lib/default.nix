{ inputs, lib, ... }:

with lib;
rec {

  firstOrDefault = first: default: if first != null then first else default;

  existsOrDefault = x: set: default: if builtins.hasAttr x set then builtins.getAttr x set else default;

  # Will be v. useful when i grok
  # https://github.com/ahbk/my-nixos/blob/5fe1521b11422c66fd823b442393b3b044a5a5b8/nix#L5
  # pick a list of attributes from an attrSet
  # mySystem.pick = attrNames: attrSet: filterAttrs (name: value: elem name attrNames) attrSet;

  # create an env-file (package) that can be sourced to set environment variables
  # mySystem.mkEnv = name: value: pkgs.writeText "${name}-env" (concatStringsSep "\n" (mapAttrsToList (n: v: "${n}=${v}") value));

  # loop over an attrSet and merge the attrSets returned from f into one (latter override the former in case of conflict)
  # mySystem.mergeAttrs = f: attrs: builtins.foldlAttrs (acc: name: value: (recursiveUpdate acc (f name value))) { } attrs;

  # main service builder
  mkService = options: (
    let
      user = existsOrDefault "user" options "568";
      group = existsOrDefault "group" options "568";
      
      subdomain = existsOrDefault "subdomainOverride" options options.app;
      host = existsOrDefault "host" options "${subdomain}.${options.domain}";

      enableBackups = (lib.attrsets.hasAttrByPath [ "persistence" "folder" ] options)
        && (lib.attrsets.attrByPath [ "persistence" "enable" ] true options);


      systemd.tmpfiles.rules = lib.optionals (lib.attrsets.hasAttrByPath [ "persistence" "folder" ] options) [ "d ${options.persistence.folder} 0750 ${user} ${group} -" ]
      ;
  );

