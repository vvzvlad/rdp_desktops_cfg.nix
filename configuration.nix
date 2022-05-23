# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      <home-manager/nixos> # exec "sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager && sudo nix-channel --update" in new system
      ./awesome-kiosk.nix
    ];

  awesome-kiosk.users = {
    rdp1.url = "https://yandex.ru";
    rdp2.url = "https://google.com";
    rdp3.url = "https://yandex.ru";
    rdp4.url = "https://google.com";
    rdp5.url = "https://yandex.ru";
    rdp6.url = "https://google.com";
    rdp7.url = "https://yandex.ru";
    rdp8.url = "https://google.com";
    rdp9.url = "https://yandex.ru";
    rdp10.url = "https://google.com";
    rdp11.url = "https://yandex.ru";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.
  time.timeZone = "Europe/Moscow";

  networking.interfaces.enp1s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    displayManager = {
        sddm.enable = true;
        defaultSession = "none+awesome";
    };

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
      ];
    };
  };

    services.xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.awesome}/bin/awesome";
      package = pkgs.xrdp.overrideAttrs (oldAttrs: {
        postInstall = oldAttrs.postInstall + ''
          substituteInPlace $out/etc/xrdp/startwm.sh \
            --replace "xterm" "awesome"
        '';
      });
    };


  #nixpkgs.overlays = [
  #  (final: prev: {
  #    xrdp = prev.xrdp.overrideAttrs (_: {
  #      postInstall = ''
  #        sed -i -e 's/ssl_protocols=TLSv1.2, TLSv1.3/ssl_protocols=TLSv1, TLSv1.1, TLSv1.2, TLSv1.3/' $out/etc/xrdp/xrdp.ini
  #        sed -i -e 's/crypt_level=high/crypt_level=none/' $out/etc/xrdp/xrdp.ini
  #        sed -i -e 's/xterm/awesome/' $out/etc/xrdp/startwm.sh
  #      '';
  #    });
  #  })
  #];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vvzvlad = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };




  # List packages installed in syАstem profile. To search, run "nix search wget"
  environment.systemPackages = with pkgs; [
    wget
    chromium
    mc
    git
    killall
    nix-index
  ];

  security.sudo.extraRules= [
  {  users = [ "vvzvlad" ];
    commands = [
      { command = "ALL" ;
        options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }
    ];
    }
  ];

  users.users."vvzvlad".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/mtlYUEoWutGWNhjGZ8XEV2G6Plt6o96uMRUYwnyHjGrNoz1oEfEWAFXExAp1ovPXI+m2Wm3VUgfDYiURUuqU8r8mRUvIml6lOljXtHVVKtHwMJOS3f3RCbWxGsTiQBIDUcNz8EtIqS5vAWwcj7P+Tsk8S/e/0ge5VdbR1wOTmWEnWc+JemVEMYTUxB5idnaQiB3M7dMguYc5u/7GdGOLyT/f70DABZAw/WCPIsA99/tQqPqp0T3I/r/c8ZpZOvZA9jB8+dXMMFJucoFimzNXmXBqNVIUmzkAUnpM91OUUKp3/mi5cdKdot/s80Tdar/SCszEYfA9j4vZffjfS34h vvzvlad@MBP.local"
  ];

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/mtlYUEoWutGWNhjGZ8XEV2G6Plt6o96uMRUYwnyHjGrNoz1oEfEWAFXExAp1ovPXI+m2Wm3VUgfDYiURUuqU8r8mRUvIml6lOljXtHVVKtHwMJOS3f3RCbWxGsTiQBIDUcNz8EtIqS5vAWwcj7P+Tsk8S/e/0ge5VdbR1wOTmWEnWc+JemVEMYTUxB5idnaQiB3M7dMguYc5u/7GdGOLyT/f70DABZAw/WCPIsA99/tQqPqp0T3I/r/c8ZpZOvZA9jB8+dXMMFJucoFimzNXmXBqNVIUmzkAUnpM91OUUKp3/mi5cdKdot/s80Tdar/SCszEYfA9j4vZffjfS34h vvzvlad@MBP.local"
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "yes";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

