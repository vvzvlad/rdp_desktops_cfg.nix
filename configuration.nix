# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModule
      ./awesome-kiosk.nix
    ];
    
  nix.extraOptions = ''
      experimental-features = nix-command flakes
  '';
  home-manager.useGlobalPkgs = true;

  awesome-kiosk.users = {
    rdp1.url = "http://192.168.88.111:3006/d/zBbI5L57z/?kiosk=tv&to=now-1m&from=now-10d&refresh=5m";
    rdp2.url = "http://192.168.88.111:3006/d/mCtETQx7z/?kiosk=tv&to=now-1m&from=now-10d&refresh=7m";
    rdp3.url = "http://192.168.88.111:3006/d/w3V8TQxnz/?kiosk=tv&to=now-1m&from=now-10d&refresh=10m";
    rdp4.url = "http://192.168.88.111:3006/d/Gy2wTwx7k/?kiosk=tv&to=now-1m&from=now-15d&refresh=15m";
    rdp5.url = "http://192.168.88.111:3006/d/Ftv_owx7k/?kiosk=tv&to=now-1m&from=now-10d&refresh=1h";
    rdp6.url = "https://ru.tradingview.com/chart/";
    rdp7.url = "http://192.168.88.111:3006/d/mCtETQx7z/?kiosk=tv&to=now-1m&from=now-10d&refresh=7m";
    rdp8.url = "https://www.n2yo.com/";
    rdp9.url = "https://zoom.earth/maps/temperature/#view=57.5,70.1,4z";
    rdp10.url = "https://www.lightningmaps.org/#m=oss;t=3;s=0;o=0;b=;ts=0;y=49.9234;x=85.7888;z=3;d=2;dl=2;dc=0;";
    rdp11.url = "https://ru.tradingview.com/chart/";
  };



  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-rdp-server";
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
        substituteInPlace $out/etc/xrdp/xrdp.ini \
          --replace "ssl_protocols=TLSv1.2, TLSv1.3" "ssl_protocols=TLSv1, TLSv1.1, TLSv1.2, TLSv1.3" \
          --replace "crypt_level=high" "crypt_level=none"
      '';
    });
  };


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
    firefox
    brave
    mc
    git
    htop
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
  system.stateVersion = "22.05"; # Did you read the comment?

}

