{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.awesome-kiosk;
  userCfg = { name, config, ... }: {
    options = {
      url = mkOption {
        type = types.str;
        description = "URL to visit";
      };
      args = mkOption {
        type = types.listOf types.str;
        description = "List of CLI args to pass to chromium";
        default = [
          "--noerrdialogs"
          "--kiosk"
          "--incognito"
          "--force-device-scale-factor=0.79"
        ];
      };
    };
  };
in {
  options.awesome-kiosk = with types; {
    users = mkOption { type = attrsOf (submodule userCfg); };
  };

  config = {
    users.users =
      builtins.mapAttrs (name: config: { isNormalUser = true; initialPassword = "1"; }) cfg.users;
    home-manager.users = builtins.mapAttrs (name: config: {
      home.file.".config/awesome/rc.lua".source =
        pkgs.runCommand "rc.lua" { } ''
          cat ${pkgs.awesome}/etc/xdg/awesome/rc.lua | sed 's/    set_wallpaper(s)/    --set_wallpaper(s)/g' > $out
          printf "\nos.execute('${pkgs.chromium}/bin/chromium ${
            concatStringsSep " " config.args
          } \"${config.url}\" &')" >> $out
        '';
    }) cfg.users;
  };

}
