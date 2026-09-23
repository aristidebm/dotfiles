{ pkgs, ... }:

{
  systemd.user.services = {
    mpd = {
      Unit = {
        Description = "Music Player Daemon";
        Documentation = [ "man:mpd(1)" "man:mpd.conf(5)" ];
        After = [ "network.target" "sound.target" ];
      };
      Service = {
        Type = "notify";
        ExecStart = "${pkgs.mpd}/bin/mpd --systemd %h/.config/mpd/mpd.conf";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    mpd-mpris = {
      Unit = {
        Description = "mpd-mpris: an implementation of the MPRIS protocol for MPD";
        After = [ "mpd.service" ];
      };
      Service = {
        Type = "dbus";
        BusName = "org.mpris.MediaPlayer2.mpd";
        ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris --no-instance";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    emacs = {
      Unit = {
        Description = "Emacs: the extensible, self-documenting text editor";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "exec";
        ExecStart = "${pkgs.emacs}/bin/emacs --fg-daemon";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    kanata = {
      Unit = {
        Description = "Kanata keyboard remapper";
        Documentation = [ "https://github.com/jtroo/kanata" ];
      };
      Service = {
        Environment = "PATH=${pkgs.coreutils}/bin:${pkgs.util-linux}/bin:/usr/bin:/bin";
        Type = "simple";
        ExecStart = "${pkgs.kanata}/bin/kanata --cfg %h/.config/kanata/keymaps.kbd";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}